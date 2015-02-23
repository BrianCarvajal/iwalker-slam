function stepPlotRobotMapEssai(pl, rob, I)
   % axis([rob.x(1)-4 rob.x(1)+4 rob.x(2)-4 rob.x(2)+4]);
    h = findobj(pl.ha, 'Tag', 'image');
    if ~isempty(h)
        set(h, 'CData', I);
    end
    
    pl.plotRobot(rob.x, 'iWalker', 'r');
    if ~isempty(rob.x_hist)
        pl.plotTrace(rob.x_hist(:, 1:2), 'trace.iWalker', 'r');
    end
    
end

