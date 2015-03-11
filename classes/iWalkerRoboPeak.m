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
           this.log.type = 'iWalkerRoboPeak';
            
           this.log.can.pose = timeseries();
           this.log.can.pose.Name = 'iWalker Pose';
           this.log.can.pose.DataInfo.Units = 'm';
           
           this.log.can.w = timeseries();
           this.log.can.w.Name = 'angular velocities';
           this.log.can.w.DataInfo.Units = 'rad/s';
           
           this.log.can.odo = timeseries();
           this.log.can.odo.Name = 'odometry';
           this.log.can.odo.DataInfo.Units = 'm | rad';
           
           this.log.lidar.range = timeseries();
           this.log.lidar.range.Name = 'scan range';
           this.log.lidar.range.DataInfo.Units = 'mm';
           
           this.log.lidar.angle = timeseries();
           this.log.lidar.angle.Name = 'scan angle';
           this.log.lidar.angle.DataInfo.Units = 'degrees';
           
           this.log.lidar.freq = timeseries();
           this.log.lidar.freq.Name = 'scan frequency';
           this.log.lidar.freq.DataInfo.Units = 'Hz';
           
           this.log.lidar.count = timeseries();
           this.log.lidar.count.Name = 'scan count';
           this.log.lidar.count.DataInfo.Units = 'scalar';          
        end
         
        function [pose, odo, w] = readWheels(this)
            data = double(this.canusb.read(772));
            ldata = double(this.canusb.read(768));
            rdata = double(this.canusb.read(769));
            
            x =     iWalkerInterface.bytes2double(data(1),data(2));
            y =     iWalkerInterface.bytes2double(data(3),data(4));
            th =    iWalkerInterface.bytes2double(data(7),data(8));
            pose = [x y th]/1000; % mm to m and mrad to rad
            
            w(1) = iWalkerInterface.bytes2double(ldata(1),ldata(2));
            w(2) = iWalkerInterface.bytes2double(rdata(1),rdata(2));
            
            w = w/94.7; % mm/s to rad/s
            
            speed = (w(1) + w(2)) / 2;
            odo = this.computeOdometry(pose, speed);       
        end
             
        function lidar_callback(this, t, ~)
            try
                timestamp = toc;
                d = [];
                [d.freq, d.count, d.range, d.angle] = this.lidar.getScan();
                d.angle = mod(d.angle + 180, 360);
                if isempty(this.log.lidar.range.Time)
                    dt = 0;
                else
                    dt = timestamp - this.log.lidar.range.Time(end);
                end
                notify(this, 'lidarReaded', iWalkerEventData(d, timestamp, dt));

                this.log.lidar.freq = this.log.lidar.freq.addsample('Time', timestamp, 'Data', d.freq);
                this.log.lidar.count = this.log.lidar.count.addsample('Time', timestamp, 'Data', d.count);
                this.log.lidar.range = this.log.lidar.range.addsample('Time', timestamp, 'Data', d.range);
                this.log.lidar.angle = this.log.lidar.angle.addsample('Time', timestamp, 'Data', d.angle);
            catch
                
            end
        end
        
        function canusb_callback(this, t, ~)
            try 
                timestamp = toc;
                this.time = timestamp;
                d = [];
                [d.pose, d.odo, d.w] = this.readWheels();                
                if isempty(this.log.can.pose.Time)
                    dt = 0;
                else
                    dt = timestamp - this.log.can.pose.Time(end);
                end                
                notify(this, 'canusbReaded', iWalkerEventData(d,timestamp, dt));
                
                this.log.can.pose = this.log.can.pose.addsample('Time', timestamp, 'Data', d.pose);
                this.log.can.odo = this.log.can.odo.addsample('Time', timestamp, 'Data', d.odo);
                this.log.can.w = this.log.can.w.addsample('Time', timestamp, 'Data', d.w);
            catch
                
            end
        end
    end
    
end

