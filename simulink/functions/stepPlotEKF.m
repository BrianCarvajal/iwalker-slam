function stepPlotEKF(pl, ekf)
    x = ekf.x_est(1:3);
    %axis([x(1)-3 x(1)+3 x(2)-3 x(2)+3]);
    pl.plotRobot(x, 'EKF.x', 'c');
    if ~isempty(ekf.history)
        xvh = [ekf.history.xv_est];
        pl.plotTrace(xvh(1:2,:)', 'EKF.trace', 'r');
    end
    pl.plotErrorXY(ekf.P_est(1:2, 1:2), x, 'EKF.errorXY', 'c');
    pl.plotErrorAngle(ekf.P_est(3,3), x, 'EKF.errorTheta', 'y');
end

