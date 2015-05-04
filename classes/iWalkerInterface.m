classdef iWalkerInterface < hgsetget
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties 
        canusb
        lidar
        time
        log
        running
    end
    
    properties (SetAccess = protected, Hidden = true)
        canusb_timer
        lidar_timer;      
        prevPose
    end
    
    events
        lidarReaded
        canusbReaded
    end
    
    methods (Abstract)
        initLog(this)
        lidar_callback(this, t, ~)
        canusb_callback(this, t, ~)
    end
    
    methods
        function this = iWalkerInterface()
            this.prevPose = [];
            this.time = 0;
            this.log.endTime = 0;
            this.lidar_timer = timer(...
                'Name', 'LidarTimer', ...
                'BusyMode', 'queue', ...
                'Period', 0.5, ...
                'ExecutionMode', 'fixedRate', ...
                'TimerFcn', @this.lidar_callback);
            this.canusb_timer = timer(...
                'Name', 'CANUSBTimer', ...
                'BusyMode', 'queue', ...
                'Period', 0.5, ...
                'ExecutionMode', 'fixedRate', ...
                'TimerFcn', @this.canusb_callback);
            this.running = false;
        end
        
        function delete(this)
           this.stop();
           this.canusb.delete();
           this.lidar.delete();
           delete(this.lidar_timer);
           delete(this.canusb_timer);
        end
        
        function start(this)
            this.running = true;
            this.initLog();
            this.time = 0;
            tic;            
            start(this.canusb_timer);
            start(this.lidar_timer);
        end
        
        function stop(this)
            if this.running
                this.running = false;
                this.log.endTime = toc;
                stop(this.lidar_timer);
                stop(this.canusb_timer);
            end
        end
        
        function setLidarSampleTime(this, st)
            if strcmp(this.lidar_timer.Running, 'off') && st > 0
                this.lidar_timer.Period = st;
            end
        end
        
        function setCANUSBSampleTime(this, st)
            if strcmp(this.canusb_timer.Running, 'off') && st > 0
                this.canusb_timer.Period = st;
            end
        end
        
        function success = connect(this, COM)
            success.canusb = this.canusb.connect();
            success.lidar = this.lidar.connect(COM);
        end
        
        function success = disconnect(this)
            success.canusb = this.canusb.disconnect();
            success.lidar = this.lidar.disconnect();
        end
        
        
    end
    
    methods (Access = protected)
       function odo = computeOdometry(this, pose, speed)
            Xp = this.prevPose;
            if isempty(Xp)
                odo = [0 0];
            else
                odo = [sqrt((pose(1)-Xp(1))^2 + (pose(2)-Xp(2))^2) pose(3)-Xp(3)];                     
                % If velocity is negative, the distance is negative
                if speed < 0
                    odo(1) = -odo(1);
                end
                % If odmetry is high, it's due to overflow. We set the odometry to
                % zero.
                if abs(odo(1)) > 1
                    odo = [0 0];
                end
            end
            this.prevPose = pose;
        end 
    end
    
    methods (Static, Access = protected)
        function n = bytes2double(msB, lsB)
            n = double(typecast(uint8([lsB msB]), 'int16'));
        end
    end
    
end

