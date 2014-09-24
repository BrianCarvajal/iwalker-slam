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
%   angle           angles of the sensed points
%   range           ranges of the sensed points
%   timestamp       acquisition time, expressed in seconds
%
% See also DifferentialRobot

classdef LIDAR < handle
    
    
    properties
        robot           % robot where the LIDAR is attached
        x               % pose relative to robot
        plotTag
    end
    
    properties (SetAccess = private)
        data_length     % number of points sensed
        angle           % angles of the sensed points
        range           % ranges of the sensed points
        timestamp       % acquisition time, expressed in seconds
        p               % cartesian points
    end
    
    properties (Access = private)
        lupsin            % lookup table for sin
        lupcos            % lookup table for cos
    end
    
    methods
        function lid = LIDAR(robot, T)
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
               x = [];
            
            else
                if isempty(robot) || ~isa(robot, 'DifferentialRobot')
                error('robot must be DifferentialRobot object');
                end
                if isempty(T) || ~isequal(size(T),[3 3])
                    error('T must be a 3x3 matrix');
                end
            end
            lid.robot = robot;
            lid.x = x;
            lid.data_length = 682;
            lid.plotTag = 'LIDAR.plot';
            % precalculate the angles for cartesian conversion
            for i = 1 : lid.data_length
                lid.angle(i) = ((0.3515625 *(i - 1)) - 120) * pi / 180.0;
                lid.lupsin(i) = sin(lid.angle(i));
                lid.lupcos(i) = cos(lid.angle(i));
            end
            lid.setRangeData(zeros(1,682), 0);
        end
        
        
        function p = setRangeData(lid, range, timestamp)
        %LIDAR.setRangeData Set new range data
        %
        % lid.setRangeData(R, T) sets new range data R with timestamp T        
        %   R:  a vector with lid.data_lenght elements. Each element
        %   represents a distance in m.
        %   T:  acquisition time, expressed in seconds.
        %
            if length(range) ~= lid.data_length
                error('Range lenght must be %d', lid.data_length);
            end
            lid.timestamp = double(timestamp);
            lid.range = double(range);
            lid.p = [lid.range .* lid.lupcos; lid.range .* lid.lupsin];
            p = lid.p;
%             if ~isempty(lid.robot)
%                 rob = lid.robot;
%                 T = se2(rob.x(1), rob.x(2), rob.x(3)) * se2(lid.x(1), lid.x(2), lid.x(3));
%                 lid.p = pTransform(lid.p, T);
%             end
            
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
                
                hp = [hp line([0 lid.x(1)], [0 lid.x(2)], 'Color', 'r', 'LineWidth', 3)];
                
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
