classdef iWalkerRoboPeak < iWalkerInterface
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here         

    
    methods
        function this = iWalkerRoboPeak()
            this = this@iWalkerInterface();
            this.lidar = RPLidarInterface();
            this.canusb = CANUSBInterface();           
            this.initLog();
        end
                 
        function initLog(this)
           this.log.pose = timeseries();
           this.log.pose.Name = 'iWalker Pose';
           this.log.pose.DataInfo.Units = 'm';
           
           this.log.rps = timeseries();
           this.log.rps.Name = 'angular velocities';
           this.log.rps.DataInfo.Units = 'rad/s';
           
           this.log.odo = timeseries();
           this.log.odo.Name = 'odometry';
           this.log.odo.DataInfo.Units = 'm | rad';
           
           this.log.range = timeseries();
           this.log.range.Name = 'scan range';
           this.log.range.DataInfo.Units = 'mm';
           
           this.log.angle = timeseries();
           this.log.angle.Name = 'scan angle';
           this.log.angle.DataInfo.Units = 'degrees';
           
           this.log.freq = timeseries();
           this.log.freq.Name = 'scan frequency';
           this.log.freq.DataInfo.Units = 'Hz';
           
           this.log.count = timeseries();
           this.log.count.Name = 'scan count';
           this.log.count.DataInfo.Units = 'scalar';          
        end
         
        function [pose, odo, w] = readWheels(this)
            data = double(this.canusb.read(772));
            ldata = double(this.canusb.read(768));
            rdata = double(this.canusb.read(769));
            
            x =     iWalkerInterface.bytes2double(data(1),data(2));
            y =     iWalkerInterface.bytes2double(data(3),data(4));
            th =    iWalkerInterface.bytes2double(data(7),data(8));
            pose = [x y th]/1000; % mm to m
            
            w(1) = iWalkerInterface.bytes2double(ldata(1),ldata(2));
            w(2) = iWalkerInterface.bytes2double(rdata(1),rdata(2));
            
            w = w/94.7; % mm/s to rad/s
            
            Xp = this.prevPose;
            odo = [sqrt((pose(1)-Xp(1))^2 + (pose(2)-Xp(2))^2) pose(3)-Xp(3)];                     
            
            advance = (w(1) + w(2)) / 2;
            if advance < 0
                odo(1) = -odo(1);
            end
            % If odmetry is high, it's due to overflow. We set the odometry to
            % zero.
            if abs(odo(1)) > 5
                odo = [0 0];
            end
            
            this.prevPose = pose;           
        end
             
        function lidar_callback(this, t, ~)
            try
                timestamp = toc;
                this.time = timestamp;
                d = [];
                [d.freq, d.count, d.range, d.angle] = this.lidar.getScan();
                notify(this, 'lidarReaded', iWalkerEventData(d));

                this.log.freq = this.log.freq.addsample('Time', timestamp, 'Data', d.freq);
                this.log.count = this.log.count.addsample('Time', timestamp, 'Data', d.count);
                this.log.range = this.log.range.addsample('Time', timestamp, 'Data', d.range);
                this.log.angle = this.log.angle.addsample('Time', timestamp, 'Data', d.angle);
            catch
                
            end
        end
        
        function canusb_callback(this, t, ~)
            try 
                timestamp = toc;
                this.time = timestamp;
                d = [];
                [d.pose, d.odo, d.rps] = this.readWheels();
                notify(this, 'canusbReaded', iWalkerEventData(d));

                this.log.pose = this.log.pose.addsample('Time', timestamp, 'Data', d.pose);
                this.log.odo = this.log.odo.addsample('Time', timestamp, 'Data', d.odo);
                this.log.rps = this.log.rps.addsample('Time', timestamp, 'Data', d.rps);
            catch
                
            end
        end
    end
    
end

