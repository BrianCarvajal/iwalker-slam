classdef iWalkerInterface < hgsetget
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties 
        canusb
        lidar
        time
        log
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
            this.prevPose = [0 0 0];
            this.time = 0;
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
        end
        
        function delete(this)
           this.stop();
           this.canusb.delete();
           this.lidar.delete();
           delete(this.lidar_timer);
           delete(this.canusb_timer);
        end
        
        function start(this)
            this.initLog();
            this.time = 0;
            tic;
            start(this.lidar_timer);
            start(this.canusb_timer);
        end
        
        function stop(this)
            stop(this.lidar_timer);
            stop(this.canusb_timer);
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
            success.lidar = this.lidar.connect(COM);
            success.canusb = this.canusb.connect();
        end
        
        function success = disconnect(this)
            success.lidar = this.lidar.disconnect();
            success.canusb = this.canusb.disconnect();
        end
    end
    
end

