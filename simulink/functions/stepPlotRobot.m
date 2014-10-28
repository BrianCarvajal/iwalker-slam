function stepPlotRobot(pl, rob)
   % axis([rob.x(1)-4 rob.x(1)+4 rob.x(2)-4 rob.x(2)+4]);
    pl.plotRobot(rob.x, 'iWalker', 'r');
    if ~isempty(rob.x_hist) && size(rob.x_hist,1) > 505
        pl.plotTrace(rob.x_hist(end-500:end, 1:2), 'trace.iWalker', 'r');
    end
    
end

