classdef iWalkerRoboPeak < hgsetget
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    
    
    properties
        canusb
        rplidar 
        
        
    end
    
    properties (SetAccess = private, Hidden = true)
        canusb_timer
        rplidar_timer;      
        prevPose
    end
    
    events
        lidarReaded
        canusbReaded
    end
    
    methods
        function this = iWalkerRoboPeak()
            this.prevPose = [0 0 0];
            this.rplidar_timer = timer(...
                'Name', 'RPLidarTimer', ...
                'BusyMode', 'queue', ...
                'Period', 0.5, ...
                'ExecutionMode', 'fixedRate', ...
                'TimerFcn', @this.rplidar_callback);
            this.canusb_timer = timer(...
                'Name', 'CANUSBTimer', ...
                'BusyMode', 'queue', ...
                'Period', 0.5, ...
                'ExecutionMode', 'fixedRate', ...
                'TimerFcn', @this.canusb_callback);
        end
        
        function delete(this)
           this.canusb.delete();
           this.rplidar.delete();
           delete(this.rplidar_timer);
           delete(this.canusb_timer);
        end
        
        function start(this)
            start(this.rplidar_timer);
            start(this.canusb_timer);
        end
        
        function stop(this)
            stop(this.rplidar_timer);
            stop(this.canusb_timer);
        end
        
        function setLidarSampleTime(this, st)
            if strcmp(this.rplidar_timer.Running, 'off') && st > 0
                this.rplidar_timer.Period = st;
            end
        end
        
        function setCANUSBSampleTime(this, st)
            if strcmp(this.canusb_timer.Running, 'off') && st > 0
                this.canusb_timer.Period = st;
            end
        end
             
          
        function connect(this, COM)
            this.rplidar = RPLidarInterface();
            this.rplidar.connect(COM);
            this.canusb = CANUSBInterface();
        end
        
        function [pose, odo] = readPose(this)
            data = double(this.canusb.read(772));
            x =     data(1)*256 + data(2);
            y =     data(3)*256 + data(4);
            th =    data(7)*256 + data(8);
            pose = [x y th];
            
            Xp = this.prevPose;
            odo = [sqrt((pose(1)-Xp(1))^2 + (pose(2)-Xp(2))^2) pose(3)-Xp(3)];            
            this.prevPose = pose;           
        end
        
        function w = readAngularVelocity(this)
           ldata = double(this.canusb.read(768));
           rdata = double(this.canusb.read(769));
             
           w(1) = ldata(1)*256 + ldata(2);
           w(2) = rdata(1)*256 + rdata(2);                     
        end
        
        function rplidar_callback(this, t, ~)
            d = [];
            [d.freq, d.count, d.range, d.angle] = this.rplidar.getScan();          
            notify(this, 'lidarReaded', iWalkerEventData(d));           
        end
        
        function canusb_callback(this, t, ~)
            d = [];
            [d.pose, d.odo] = this.readPose();
            d.w = this.readAngularVelocity();
            notify(this, 'canusbReaded', iWalkerEventData(d)); 
        end
    end
    
end

