function stepPlotRobot(pl, rob)
    axis([rob.x(1)-4 rob.x(1)+4 rob.x(2)-4 rob.x(2)+4]);
    pl.plotRobot(rob.x, 'iWalker', 'r');
    if ~isempty(rob.x_hist)
        pl.plotTrace(rob.x_hist(:, 1:2), 'trace.iWalker', 'r');
    end
    
end

