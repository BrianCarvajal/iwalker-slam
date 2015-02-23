classdef DataLog < hgsetget
    
    properties
        % Log input data. All the logs must have a common dt divisor.
        pose    % pose computed by iWheels (mm)
        w       % angular speed
        range   % range data of the laser (m)
        angle   % angle data of the laser (degrees)
        
        % Log output data
        rob_x
        ekf_x
        ekf_P
        
        dt
    end
    
    properties (Access = public)
        i_wheels
        i_lidar
        currentTime
        
        fixed_angle
    end
    
    properties (Dependent)
        endTime
    end
    
    methods
        function obj = DataLog(varargin)
            % Set default property values
            obj.pose =  [];
            obj.w = [];
            obj.range = [];
            obj.angle = [];
            
            % Set user-supplied property values
            if nargin > 0
                set(obj, varargin{:} );
            end       
            if (isempty(obj.pose) || isempty(obj.range))
                error('pose and range data is mandatory');
            end
            
            % Hokuyo lidar does not suply angle data, it's fixed
            if isempty(obj.angle)
               obj.fixed_angle =  ((0.3515625 *((1:682) - 1)) - 120);
            end
            
            
            dt = obj.pose.TimeInfo.Increment;
            if (obj.range.TimeInfo.Increment > dt)
                if (mod(obj.range.TimeInfo.Increment, dt) ~= 0)
                    error('Incompatible sample times');
                end
            else
                if (mod(dt, obj.range.TimeInfo.Increment) ~= 0)
                    error('Incompatible sample times');
                end
                dt = obj.range.TimeInfo.Increment;
            end
            
            obj.dt = dt;
            
            obj.rob_x = timeseries();
            obj.rob_x.name = 'rob_x';
            obj.ekf_x = timeseries();
            obj.ekf_x.name = 'ekf_x';
            obj.ekf_P = timeseries();
            obj.ekf_P.name = 'ekf_P';           
        end
        
        function t = get.endTime(obj)
            t = 0;
            if ~isempty(obj.pose)
                t = max(t, obj.pose.TimeInfo.End);
            end
            if ~isempty(obj.range)
                t = max(t, obj.range.TimeInfo.End);
            end
        end
        
        % returns the bounding box [-xy +xy] of the area
        function lims = limits(obj)
            if ~isempty(obj.pose)
                %first data is always zero, second is offset. We recover
                %all the data and substract the offset
                y = obj.pose.Data(2:end,1) - obj.pose.Data(2,1); 
                x = obj.pose.Data(2:end,2) - obj.pose.Data(2,2);              
                xl = max(abs(x'));
                yl = max(abs(y'));
                m = max([xl yl]);
                lims = [-m m]/1000; % mm to m
            else
               lims = [0 0 0 0]; 
            end
        end
        
        function init(obj)
            obj.i_wheels = 1;
            obj.i_lidar = 1;
            obj.currentTime = 0;
        end
        
        function b = remainingData(obj)
            b = obj.i_wheels <= obj.pose.TimeInfo.Length || ...
                obj.i_lidar <= obj.range.TimeInfo.Length;           
        end
        
        function [data, ts] = nextSample(obj)
            data = [];
            ts = obj.currentTime;

            if obj.i_wheels <= obj.pose.TimeInfo.Length && ... 
               abs(obj.pose.Time(obj.i_wheels) - ts) < 0.00001
                % computation of the odometry based on two consecutive
                % poses. odo = [dx, dtheta]
                if (obj.i_wheels == 1)
                    odo = [0 0];
                else
                    X = obj.pose.Data(obj.i_wheels,:);
                    Xp = obj.pose.Data(obj.i_wheels - 1,:);
                    odo = [ sqrt((X(1)-Xp(1))^2 + (X(2)-Xp(2))^2) X(3)-Xp(3)]/1000;
                    
                    if sum(obj.w.Data(obj.i_wheels, :)) < 0 %if negative velocity, dx is negative
                        odo(1) = -odo(1);
                    end
                    if abs(odo(1)) > 1
                        odo = [0 0];
                    end
                    
                end
                
                ws.source = 'wheels';
                ws.data.odo = odo;
                ws.data.pose = obj.pose.Data(obj.i_wheels,:);
                ws.data.w = obj.w.Data(obj.i_wheels,:);
                
                data = [data ws];
                obj.i_wheels = obj.i_wheels + 1;
            end
            
            if obj.i_lidar <= obj.range.TimeInfo.Length && ...
               abs(obj.range.Time(obj.i_lidar) - ts) <  0.00001
                ls.source = 'lidar';
                if isempty(obj.angle)
                    ls.data.range = double(obj.range.Data(obj.i_lidar,:));
                    ls.data.angle = obj.fixed_angle;
                    data = [data ls];
                else
                    len = length(obj.range.Data(obj.i_lidar,:));
                    while len > 0 && obj.range.Data(obj.i_lidar, len) == 0
                        len = len - 1;
                    end
                    if len > 0
                        ls.data.range = obj.range.Data(obj.i_lidar,1:len);
                        ls.data.angle = obj.angle.Data(obj.i_lidar,1:len);
                        data = [data ls];
                    end
                end
                obj.i_lidar = obj.i_lidar + 1;
            end
            obj.currentTime = obj.currentTime + obj.dt;
        end
        
    end
end

