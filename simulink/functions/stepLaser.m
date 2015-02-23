function stepLaser( data, rob, lid, ext, pl )
    lid.setRangeData(double(data)/1000, 0);
    x = rob.x;
    T = se2(x(1), x(2), x(3)) * se2(lid.x(1), lid.x(2), lid.x(3));
    p = pTransform(lid.p, T);
    [lands, Res] = ext.extract(lid.range, p);
    pl.plotPoints(p(1,:), p(2,:), 'laserdata', 'g');
    pl.plotSplitAndMerge(Res, 's&m'); 
end

