%Landmark SLAM's landmark class
%
%   This class represents the landmarks used in SLAM algorithm.
%
%   Methods:
%
%   Static methods
%
%   Properties
%       id:  unique identificator
%       pos: position x, y (1x2)
%       ang: angle
%       ori: orientation
%
%   Examples:


classdef Landmark < handle
    
    properties
        pos         % x and y position in wolrd frame
        posl        % x and y position in local frame
        V           % covariance matrix
        type        % type
        remarks     % times seen before
        id          % unique id
        hist_pos
        matched_landmark %if the landarmk is anonymous and match some know ,
                         % stores a reference to that landmark
    end
    
    
    properties (Dependent = true)
        x, y
    end
    
    methods
        function obj = Landmark(pos, type)
            %Landmark object constructor
            
             if ~strcmpi(type, 'corner') && ...
                ~strcmpi(type, 'oclusor') && ...
                ~strcmpi(type, 'virtual')
                error('Invalid argumment: type');
             end
             
            if numel(pos) ~= 2
               error('Invalid argument: pos');
            end
            
            obj.pos = pos(:);
            obj.posl = pos(:);
            obj.type = type;
            obj.V = ones(2,2)*0.001;
            obj.matched_landmark = [];
        end
        
        function x = get.x(lan)
            x = lan.pos(1,:);
        end
        
        function y = get.y(lan)
            y = lan.pos(2,:);
        end
        
        function set.x(lan, x)
            lan.pos(1,:) = x;
        end
        
        function set.y(lan, y)
            lan.pos(2,:) = y;
        end
        
            
        function transform(lan, T)
            lan.pos = pTransform(lan.pos, T);
        end
        
        function z = h(lan, xv)
            %Landmark.h Landmark range and bearing
            %
            % Z = L.h(XV) is the observation (1x2), range and bearing, from
            % robot at pose XV (1x3) to the current landmark
            %
            % Notes::
            % - Supports vectorized operation where XV (Nx3) and Z (Nx2).
            %
            % See also Landmark.Hx, Landmark.Hw, Landmark.Hxf.
            
            dx = lan.x - xv(:,1);
            dy = lan.y - xv(:,2);
            z = [sqrt(dx.^2 + dy.^2) atan2(dy, dx)-xv(:,3) ];   % range & bearing measurement
        end
        
        function J = Hx(lan, xv)
            %Landmark.Hx Jacobian dh/dxv
            %
            % J = L.Hx(XV) returns the Jacobian dh/dxv (2x3) at the vehicle
            % state XV (3x1) for the current landmark.
            %
            %
            % See also Landmark.h.
            
            Delta = lan.pos - xv(1:2)';
            r = norm(Delta);
            J = [
                -Delta(1)/r,    -Delta(2)/r,        0
                Delta(2)/(r^2),  -Delta(1)/(r^2),   -1
                ];
        end
        
        
        
        function J = Hxf(lan, xv)
            %Landmark.Hxf Jacobian dh/dxf
            %
            % J = L.Hxf(XV) is the Jacobian dh/dxv (2x2) at the vehicle
            % state XV (3x1) for the current landmark
            %
            % See also Landmark.h.
            
            Delta = lan.pos - xv(1:2)';
            r = norm(Delta);
            J = [
                Delta(1)/r,         Delta(2)/r
                -Delta(2)/(r^2),    Delta(1)/(r^2)
                ];
        end
        
        function J = Hw(lan, xv)
            %Landmark.Hx Jacobian dh/dv
            %
            % J = L.Hw(XV) is the Jacobian dh/dv (2x2) at the vehicle
            % state XV (3x1) for the current landmark.
            %
            %  J = L.Hw() as above but take the robot pose from L.robot.
            %
            % See also Landmark.h.
            J = eye(2,2);
        end
        
        function J = Gx(lid, xv, z)
            %Landmark.Gxv Jacobian dg/dx
            %
            % J = L.Gx(XV, Z) is the Jacobian dg/dxv (2x3) at the vehicle
            % state XV (3x1) for observation Z (2x1).
            
            theta = xv(3);
            r = z(1);
            bearing = z(2);
            J = [
                1,   0,   -r*sin(theta + bearing);
                0,   1,    r*cos(theta + bearing)
                ];
        end
        
        function J = Gz(lan, xv, z)
            %Landmark.Gz Jacobian dg/dz
            %
            % J = L.Gz(XV, Z) is the Jacobian dg/dz (2x2) at the vehicle state XV (3x1) for
            % observation Z (2x1).
            
            theta = xv(3);
            r = z(1);
            bearing = z(2);
            J = [
                cos(theta + bearing),   -r*sin(theta + bearing);
                sin(theta + bearing),    r*cos(theta + bearing)
                ];
        end

        function update(lan, x, P)
            %if lan.pos ~= p
            lan.pos = x;
            lan.V = P;
            %  lan.times_updated = lan.times_updated + 1;
            %lan.hist_pos = [lan.hist_pos; lan.pos];
            %end
        end
        
        function d = euclideanDistance(lan1, lan2)
            d = sqrt((lan1.x - lan2.x)^2+(lan1.y - lan2.y)^2);
        end

        function md = mahalanobisDistance(lan1, lan2, S)
            %d = euclideanDistance(lan1, lan2);
            d = [lan1.x - lan2.x; lan1.y - lan2.y];
            md = d'*inv(S)*d;
        end
        
        function s = sameness(l1, l2)
            s = sqrt( (l1.x - l2.x)^2 + (l1.y - l2.y)^2 );
        end
        
        function [v,i] = best_match(lan, landmarks)
            s = zeros(length(landmarks), 1);
            for k = 1: length(landmarks)  
                s(k) = lan.sameness(landmarks(k));
            end
            %s = lan.sameness(features);
            [v, i ] = min(s);
        end
        
    end
    
end

