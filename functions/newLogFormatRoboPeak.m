function log = newLogFormatHokuyo( file )
    f = load(file);
    if ~isfield(f, 'drpm') || ...
            ~isfield(f, 'pose') || ...
            ~isfield(f, 'imu') || ...
            ~isfield(f, 'forces') || ...
            ~isfield(f, 'range') || ...
            ~isfield(f, 'reactive')
       error('Not valid file'); 
    end
    log = [];
    log.type = 'iWalkerHokuyo';
    log.endTime = max(f.pose.Time(end), f.range.Time(end));
    
    log.can.pose = f.pose; 
    log.can.pose.Data = double(log.can.pose.Data)./1000;  % mm to m and mrad to rad
    log.can.pose.Name = 'iWalker Pose: [x | y | theta]';
    log.can.pose.DataInfo.Units = 'm';
    
    log.can.w = f.drpm;
    log.can.w.Data = double(log.can.w.Data)./94.7; % mm/s to rad/s
    log.can.w.Name = 'angular velocities: [left | right]';
    log.can.w.DataInfo.Units = 'rad/s';
    
    log.can.odo = timeseries();
    log.can.odo.Name = 'odometry [distance | theta]';
    log.can.odo.DataInfo.Units = 'm | rad';   
    Xp = [];
    for i = 1:size(log.can.pose.Data, 1)
        pose = log.can.pose.Data(i, :);
        speed = sum(log.can.w.Data(i,:));
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
        log.can.odo = log.can.odo.addsample('Time', log.can.pose.Time(i), 'Data', odo);
        Xp = pose;
    end
    
    
    log.can.imu = f.imu;
    log.can.imu.Name = 'IMU: [accelX | accelY | gyroPsi]';
    log.can.imu.DataInfo.Units = 'mm/s^2 | mm/s^2 | º/s';
    
    
    log.can.forces = f.forces;
    log.can.forces.Name = 'Forces: [lHandX | lHandY | lHandZ | lHBrake | rHandX | rHandY | rHandZ | rHandBrake | lLeg | rLeg]';
    log.can.forces.DataInfo.Units = 'N';
    
    log.lidar.range = f.range;
    log.lidar.range.Data = double(log.lidar.range.Data);
    log.lidar.range.Name = 'scan range';
    log.lidar.range.DataInfo.Units = 'mm';

    log.lidar.angle = timeseries();
    log.lidar.angle.Name = 'scan angle';
    log.lidar.angle.DataInfo.Units = 'degrees';
    angle = ((0.3515625 *((1:682) - 1)) - 120);
    for i = 1:size(log.lidar.range.Data, 1)
        log.lidar.angle = log.lidar.angle.addsample('Time', log.lidar.range.Time(i), 'Data', angle);
    end
      

end

