classdef iWalkerHokuyo < iWalkerInterface
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    
     methods
        function this = iWalkerHokuyo()
            this = this@iWalkerInterface();
            this.lidar = URGInterface();
            this.canusb = CANUSBInterface(); 
            this.initLog();
        end       
        
        function initLog(this)
           this.log.type = 'iWalkerHokuyo';
            
           this.log.can.pose = timeseries();
           this.log.can.pose.Name = 'iWalker Pose: [x | y | theta]';
           this.log.can.pose.DataInfo.Units = 'm';
           
           this.log.can.w = timeseries();
           this.log.can.w.Name = 'angular velocities: [left | right]';
           this.log.can.w.DataInfo.Units = 'rad/s';
           
           this.log.can.odo = timeseries();
           this.log.can.odo.Name = 'odometry [distance | theta]';
           this.log.can.odo.DataInfo.Units = 'm | rad';
           
           this.log.can.imu = timeseries();
           this.log.can.imu.Name = 'IMU: [accelX | accelY | gyroPsi]';
           this.log.can.imu.DataInfo.Units = 'mm/s^2 | mm/s^2 | º/s';
           
           this.log.can.forces = timeseries();
           this.log.can.forces.Name = 'Forces: [lHandX | lHandY | lHandZ | lHBrake | rHandX | rHandY | rHandZ | rHandBrake | lLeg | rLeg]';
           this.log.can.forces.DataInfo.Units = 'N';
           
           this.log.lidar.range = timeseries();
           this.log.lidar.range.Name = 'scan range';
           this.log.lidar.range.DataInfo.Units = 'mm';
           
           this.log.lidar.angle = timeseries();
           this.log.lidar.angle.Name = 'scan angle';
           this.log.lidar.angle.DataInfo.Units = 'degrees';
        end             
        
        function [pose, odo, w] = readWheels(this)
            data = this.canusb.read(290);
            ldata = this.canusb.read(256);
            rdata = this.canusb.read(288);
            
            x =     iWalkerInterface.bytes2double(data(1),data(2));
            y =     iWalkerInterface.bytes2double(data(3),data(4));
            th =    iWalkerInterface.bytes2double(data(7),data(8));
            pose = [x y th]/1000; % mm to m
            
            w(1) = iWalkerInterface.bytes2double(ldata(1),ldata(2));
            w(2) = iWalkerInterface.bytes2double(rdata(1),rdata(2));
            
            w = w*((2*pi)/600); %drpm to rad/s
            
            speed = (w(1) + w(2)) / 2;
            odo = this.computeOdometry(pose, speed);            
        end
        
        
        function imu = readIMU(this)
            data = this.canusb.read(768);
            imu.accX = iWalkerInterface.bytes2double(data(1),data(2));
            imu.accY = iWalkerInterface.bytes2double(data(3),data(4));
            imu.gyrPsi = iWalkerInterface.bytes2double(data(5),data(6));
        end
        
        function forces = readForces(this)
            data1 = this.canusb.read(1024);
            data2 = this.canusb.read(1056);
            data3 = this.canusb.read(512);
            data4 = this.canusb.read(544);
            
            forces.leftHandX = iWalkerInterface.bytes2double(data1(1),data1(2));
            forces.leftHandY = iWalkerInterface.bytes2double(data1(3),data1(4));
            forces.leftHandZ = iWalkerInterface.bytes2double(data1(5),data1(6));
            forces.leftHandBrake = double(data1(8));
           
            forces.rightHandX = iWalkerInterface.bytes2double(data2(1),data2(2));
            forces.rightHandY = iWalkerInterface.bytes2double(data2(3),data2(4));
            forces.rightHandZ = iWalkerInterface.bytes2double(data2(5),data2(6));
            forces.rightHandBrake = double(data2(8));
            
            forces.leftLeg = iWalkerInterface.bytes2double(data3(1),data3(2));
            
            forces.rightLeg = iWalkerInterface.bytes2double(data4(1),data4(2));
        end
        
        function writeReactive(this, lLambda, rLambda, lNu, rNu)
            data = zeros(1,8, 'uint8');
            data(1) = lLambda;
            data(2) = rLambda;
            data(3) = lNu;
            data(4) = rNu;
            this.canusb.write(1280, 4, data)
        end
        
        function lidar_callback(this, t, ~)
            try
                timestamp = toc;
                d = [];
                d.range = this.lidar.getScan();
                d.angle = ((0.3515625 *((1:682) - 1)) - 120);
                if isempty(this.log.lidar.range.Time)
                    dt = 0;
                else
                    dt = timestamp - this.log.lidar.range.Time(end);
                end
                notify(this, 'lidarReaded', iWalkerEventData(d, timestamp, dt));

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
                d.imu = this.readIMU();
                d.forces = this.readForces();              
                if isempty(this.log.can.pose.Time)
                    dt = 0;
                else
                    dt = timestamp - this.log.can.pose.Time(end);
                end               
                notify(this, 'canusbReaded', iWalkerEventData(d,timestamp, dt));

                this.log.can.pose = this.log.can.pose.addsample('Time', timestamp, 'Data', d.pose);
                this.log.can.odo = this.log.can.odo.addsample('Time', timestamp, 'Data', d.odo);
                this.log.can.w = this.log.can.w.addsample('Time', timestamp, 'Data', d.w);
                this.log.can.imu = this.log.can.imu.addsample('Time', timestamp, 'Data', struct2array(d.imu));
                this.log.can.forces = this.log.can.forces.addsample('Time', timestamp, 'Data', struct2array(d.forces));
            catch
                
            end
        end
     end
    
end

