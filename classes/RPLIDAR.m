%LIDAR sensor class
%
% This class models the sensor LIDAR URG-04LX
%
% Methods::
%   setRangeData    set new range data
%   Hx
%
%
% Properties
%   robot           robot where the LIDAR is attached
%   dis
%   T               Transform matrix to robot frame (3x3)
%   W               measurement covariance matrix (2x2)
%
% Properties (readonly)::
%   data_length     number of points sensed
%   ang           angs of the sensed points
%   range           ranges of the sensed points
%   timestamp       acquisition time, expressed in seconds
%
% See also DifferentialRobot

classdef RPLIDAR < handle
    
    
    properties
        robot           % robot where the LIDAR is attached
        T               % transform matrix to robot frame
        plotTag
    end
    
    properties (SetAccess = private)
        data_length  % number of points sensed
        ang          % angles of the sensed points
        range        % ranges of the sensed points
        p            % cartesian points in local frame
        pw           % cartesian points in world frame
        x            % pose in global frame
    end
    
    properties (Access = private)
        lupsin = zeros(1, 682);            % lookup table for sin
        lupcos = zeros(1, 682);           % lookup table for cos
    end
    
    methods
        function lid = RPLIDAR(robot, T)
        %LIDAR object constructor
        %
        % lid = LIDAR(ROB, T) is an object representing a URG-04LX LIDAR.
        %   Rob: an instance of DifferentialRobot class, where the sensor
        %        is attached.
        %   T:   The transform matrix to robot frame.
        %
        % Examples:
        %   A robot with the sensor attached at 50 cm in the x Axis 
        %   from the origin of the robot frame.
        %
        %   rob = DifferentialRobot();
        %   T = se(0.50, 0, 0);
        %   lid = LIDAR(rob, T);
        %
        % See also DifferentialRobot.
            if nargin == 0
               robot = [];
               T = se2(0,0,0);
            
            else
                if isempty(robot) || ~isa(robot, 'DifferentialRobot')
                error('robot must be DifferentialRobot object');
                end
                if isempty(T) || ~isequal(size(T),[3 3])
                    error('T must be a 3x3 matrix');
                end
            end
            lid.robot = robot;
            lid.T = T;
            lid.data_length = 0;
            lid.plotTag = 'LIDAR.plot';
            % precalculate the angles for cartesian conversion
            
            lid.setScan(0, 0);
            
        end
        
        function T = globalTransform(lid)
           if isempty(lid.robot)
              T = lid.T;
           else
              T = lid.robot.globalTransform * lid.T;
           end
        end
        
        function p = setScan(lid, range, angle)
        %LIDAR.setScan Set new scan data
        %
        % lid.setRangeData(R, A) sets new range data R with timestamp T        
        %   R:  a vector with range data, in mm.
        %   A:  a vector with angle data, in degrees.
        %
            if length(range) ~= length(range)
                error('Range and angle lenght must be the same');
            end
            lid.data_length = length(range);
            lid.range = double(range);
            lid.ang = angle;
            lid.p = [lid.range .* cosd(angle); lid.range .* sind(angle)];
            Tw = lid.globalTransform();
            lid.pw = pTransform(lid.p, Tw);
            lid.x = pTransform([0;0], Tw);
            p = lid.p;           
        end
        
        function h = plot(lid, hg)
            if nargin < 2 ||  ~ishghandle(hg)
            	hg = gcf;
            end
            
            h = findobj(hg, 'Tag', lid.plotTag);
            
            if isempty(h)
                h = hgtransform();
                set(h, 'Tag', lid.plotTag);
                
                hp = [];
                %% LIDAR itslef
%                 t = (1/16:1/8:1)'*2*pi;
%                 x = sin(t) * 25 + lid.x(1);
%                 y = cos(t) * 25 + lid.x(2);
%                 hp = [hp fill(x,y,'r', 'EdgeColor', 'None')];
                %%
                
                %hp = [hp line([0 lid.x(1)], [0 lid.x(2)], 'Color', 'r', 'LineWidth', 3)];
                
                for hh=hp
                    set(hh, 'Parent', h);
                end
                %set(h, 'Matrix', lid.robot.T);
            end
        end
        
        function plot_range(lid, hg)                      
            if nargin < 2 ||  ~ishghandle(hg)
                hg = gcf;
            end

            p = lid.p;
            if isempty(p)
                return
            end
            
            
            
            xr = lid.robot.x;
            T = se2(xr(1), xr(2), xr(3));
            p = T * [p; ones(1, size(p,2));];
  

   
            h = findobj(hg, 'Tag', 'plot.Range');
            
            if isempty(h)
                h = scatter(p(1,:), p(2,:), 1,'o', 'fill');
                set(h, 'Tag', 'plot.Range');
            else
                x = p(1,:);
                y = p(2,:);
                set(h, 'XData', x, 'YData', y);
            end
            
%             x = double(lid.range) .* lid.lupcos;
%             y = double(lid.range) .* lid.lupsin;
%             
%             xx = [];
%             yy = [];
%             for i = 1:1:length(x)
%                xx = [xx 0 x(i) NaN];
%                yy = [yy 0 y(i) NaN];
%             end
%             
% 
%             
%             if isempty(h)
%                 h = hgtransform();
%                 set(h, 'Tag', 'plot.Range');
%                 hold on;
%                 hp = [];
%                 hp = [hp plot(x, y, '.')];
%                 hp = [hp line(xx, yy, 'Color', [0 1 0.5], 'LineWidth', 0.01, 'LineStyle', '--')];
%                 
%                 for hh=hp
%                     set(hh, 'Parent', h);
%                 end
%   
%             else
%                 set(h, 'XData', x, 'YData', y);
%             end
        end
              
        
        
        
    end
end
