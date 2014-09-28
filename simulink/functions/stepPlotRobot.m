function stepPlotRobot(pl, rob)
    axis([rob.x(1)-3 rob.x(1)+3 rob.x(2)-3 rob.x(2)+3]);
    pl.plotRobot(rob.x, 'iWalker');
    pl.plotTrace(rob.x_hist(:, 1:2), 'trace.iWalker', 'r');
end

