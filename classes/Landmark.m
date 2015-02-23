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
    
    properties (Constant)
        %% Enumerations (native enumerations matlab's are crap)
        TYPE = struct('Corner', 1, 'Oclusor', 2, 'Virtual', 3);
    end
    
    properties (Dependent = true)
        x, y
    end
    
    methods
        function obj = Landmark(pos, type)
            %Landmark object constructor
            %           
            obj.pos = pos;
            obj.posl = pos;
            obj.type = type;
            obj.V = [0 0; 0 0];
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
        
        function b = isConvex(lan)
            b = lan.ang < 0;
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
        
        function update(lan, p)
            %if lan.pos ~= p
            lan.pos = p;
            %  lan.times_updated = lan.times_updated + 1;
            %lan.hist_pos = [lan.hist_pos; lan.pos];
            %end
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
        
        
        
%         function plot(lans, argv)
%             if nargin < 2
%                 argv = 'r';
%             end
%             hold on;
%             
%             hg = gcf;   
%             
%             for lan = lans
%                 u1 = lan.u1 * 0.1;
%                 u2 = lan.u2 * 0.1;
%                 X = [lan.x + u1(1), lan.x, lan.x + u2(1)];
%                 Y = [lan.y + u1(2), lan.y, lan.y + u2(2)];
%                 if lan.isConvex()
%                     color = 'c';
%                 else
%                     color = 'y';
%                 end
%                 
%                 tag = ['Landmark_', num2str(lan.id)];
%                 h = findobj(hg, 'Tag', tag);
%                 if isempty(h)
%                     h = line(X, Y, 'Color', color, 'LineWidth', 5);
%                     %text(lan.x , lan.y, int2str(lan.id), 'FontSize', 20, 'Color', 'r');
%                     set(h, 'Tag', tag);
%                     set(h, 'UserData', lan);
%                 else
%                     set(h, 'XData', X, 'YData', Y, 'Color', color);
%                 end
% 
%             end
%             
%         end
%         
%         function plot_hist(lan, argv)
%             h = lan.hist_pos;
%             plot(h(:,1), h(:,2), 'o-r');
%         end
    end
    
end

