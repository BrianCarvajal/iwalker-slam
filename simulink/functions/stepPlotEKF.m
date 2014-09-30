function stepPlotEKF(pl, ekf)
    %axis([rob.x(1)-3 rob.x(1)+3 rob.x(2)-3 rob.x(2)+3]);
    pl.plotRobot(ekf.x_est(1:3), 'EKF.x');
    if ~isempty(ekf.history)
        xvh = [ekf.history.xv_est];
        pl.plotTrace(xvh(1:2,:)', 'EKF.trace', 'r');
    end
    pl.plotErrorXY(ekf.P_est(1:2, 1:2), ekf.x_est(1:3), 'EKF.errorXY', 'c');
    pl.plotErrorAngle(ekf.P_est(3,3), ekf.x_est(1:3), 'EKF.errorTheta', 'y');
end

