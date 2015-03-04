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
           this.log.pose = timeseries();
           this.log.pose.Name = 'iWalker Pose: [x | y | theta]';
           this.log.pose.DataInfo.Units = 'm';
           
           this.log.rps = timeseries();
           this.log.rps.Name = 'angular velocities: [left | right]';
           this.log.rps.DataInfo.Units = 'rad/s';
           
           this.log.odo = timeseries();
           this.log.odo.Name = 'odometry [distance | theta]';
           this.log.odo.DataInfo.Units = 'm | rad';
           
           this.log.imu = timeseries();
           this.log.imu.Name = 'IMU: [accelX | accelY | gyroYaw]';
           this.log.imu.DataInfo.Units = 'mm/s^2 | mm/s^2 | �/s';
           
           this.log.forces = timeseries();
           this.log.forces.Name = 'Forces: [lHandX | lHandY | lHandZ | lHBrake | rHandX | rHandY | rHandZ | rHandBrake | lLeg | rLeg]';
           this.log.forces.DataInfo.Units = 'N';
           
           this.log.range = timeseries();
           this.log.range.Name = 'scan range';
           this.log.range.DataInfo.Units = 'mm';
           
           this.log.angle = timeseries();
           this.log.angle.Name = 'scan angle';
           this.log.angle.DataInfo.Units = 'degrees';
        end             
        
        function [pose, odo, w] = readWheels(this)
            data = double(this.canusb.read(290));
            ldata = double(this.canusb.read(256));
            rdata = double(this.canusb.read(288));
            
            x =     data(1)*256 + data(2);
            y =     data(3)*256 + data(4);
            th =    data(7)*256 + data(8);
            pose = [x y th]/1000; % mm to m
            
            w(1) = ldata(1)*256 + ldata(2);
            w(2) = rdata(1)*256 + rdata(2);
            
            w = w*((2*pi)/600); %drpm to rad/s
            
            % Compute odometry based on two consecutive poses
            Xp = this.prevPose;
            odo = [sqrt((pose(1)-Xp(1))^2 + (pose(2)-Xp(2))^2) pose(3)-Xp(3)];
            
            % If velocity is negative, the distance is negative
            advance = (w(1) + w(2)) / 2;
            if advance < 0
                odo(1) = -odo(1);
            end
            % If odmetry is high, it's due to overflow.
            % We set the odometry to zero.
            if abs(odo(1)) > 5
                odo = [0 0];
            end
        
            this.prevPose = pose;           
        end
        
        
        function imu = readIMU(this)
            data = double(this.canusb.read(768));
            imu.accX = data(1)*256 + data(2);
            imu.accY = data(3)*256 + data(4);
            imu.gyrYaw = data(5)*256 + data(6);
        end
        
        function forces = readForces(this)
            data1 = double(this.canusb.read(1024));
            data2 = double(this.canusb.read(1056));
            data3 = double(this.canusb.read(512));
            data4 = double(this.canusb.read(544));
            
            forces.leftHandX = data1(1)*256 + data1(2);
            forces.leftHandY = data1(3)*256 + data1(4);
            forces.leftHandZ = data1(5)*256 + data1(6);
            forces.leftHandBrake = data1(8);
           
            forces.rightHandX = data2(1)*256 + data2(2);
            forces.rightHandY = data2(3)*256 + data2(4);
            forces.rightHandZ = data2(5)*256 + data2(6);
            forces.rightHandBrake = data2(8);
            
            forces.leftLeg = data3(1)*256 + data3(2);
            
            forces.rightLeg = data4(1)*256 + data4(2); 
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
            this.time = toc;
            d = [];
            d.range = this.lidar.getScan();
            d.angle = ((0.3515625 *((1:682) - 1)) - 120);
            notify(this, 'lidarReaded', iWalkerEventData(d));
            
            this.log.range = this.log.range.addsample('Time', timestamp, 'Data', d.range);
            this.log.angle = this.log.angle.addsample('Time', timestamp, 'Data', d.angle);
        end
        
        function canusb_callback(this, t, ~)
            this.time = toc;
            d = [];
            [d.pose, d.odo, d.rps] = this.readWheels();
            d.imu = this.readIMU();
            d.forces = this.readForces();
            notify(this, 'canusbReaded', iWalkerEventData(d));
                       
            this.log.pose = this.log.pose.addsample('Time', timestamp, 'Data', d.pose);
            this.log.odo = this.log.odo.addsample('Time', timestamp, 'Data', d.odo);
            this.log.rps = this.log.rps.addsample('Time', timestamp, 'Data', d.rps);
            this.log.imu = this.log.rps.addsample('Time', timestamp, 'Data', struct2array(d.imu));
            this.log.forces = this.log.rps.addsample('Time', timestamp, 'Data', d.forces));
        end
        
     end
    
end
