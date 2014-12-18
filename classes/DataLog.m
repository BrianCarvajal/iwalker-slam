classdef DataLog < hgsetget
  
    properties
        % Log input data
        pose    % pose computed by iWheels (mm)
        w       % angular speed
        range   % range data of the laser (m)
        angle   % angle data of the laser (degrees)
        
        % Log output data
        rob_x
        ekf_x
        ekf_P
    end
    
    properties (Access = private)
       i_wheels
       i_lidar
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
            
              
        function b = remainingData(obj)
            b = obj.i_wheels <= obj.pose.TimeInfo.Length && ...
                obj.i_lidar <= obj.range.TimeInfo.Length;   
            
        end
        
        function [source, data, ts] = getData(obj)
            pose_available =  obj.i_wheels <= obj.pose.TimeInfo.Length;
            lidar_available = obj.i_lidar <= obj.range.TimeInfo.Length;

            if pose_available && lidar_available             
                if obj.pose.Time(obj.i_wheels) <= obj.range.Time(obj.i_lidar)
                   source = 'wheels';
                else
                    source = 'lidar';
                end
            elseif pose_available
                source = 'wheels';
            elseif lidar_available
                source = 'lidar';
            else
                source = 'none';
                data = [];
                ts = [];
            end
            
            switch source
                case 'wheels'
                    % computation of the odometry based on two consecutive
                    % poses. Data = odo = [dx, dtheta]
                    if (obj.i_wheels == 1)
                        data = [0 0];
                    else
                        X = obj.pose.Data(obj.i_wheels,:);
                        Xp = obj.pose.Data(obj.i_wheels - 1,:);
                        data = [ sqrt((X(1)-Xp(1))^2 + (Y(2)-Xp(2))^2) X(3)-Xp(3)]/1000;
                        
                        if sum(obj.w.Data(obj.i_wheels, :)) < 0 %if negative velocity, dx is negative 
                            data(1) = -data(1);
                        end

                    end
                    ts = obj.pose.Time(obj.i_wheels);
                    obj.i_wheels = obj.i_wheels + 1;
                case 'lidar'
                    data = [obj.range.Data(obj.i_lidar,:) ; obj.angle.Data(obj.i_lidar,:)];
                    ts = obj.range.Time;
            end
        end
    end
end

