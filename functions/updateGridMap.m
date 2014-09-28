function updateGridMap(x, y, th, range)
    persistent lid rob gm h;

    if isempty(lid)
        lid = LIDAR();
        rob = DifferentialRobot();
        rob.attachLidar(lid, [0.6, 0, 0]);
        gm = GridMap([60 60], 0.05);
    end

    if isempty(h)
        h = imshow(gm.map );
    end

    lid.setRangeData(double(range)/1000, 0);
    T = se2(x, y, th) * se2(lid.x(1), lid.x(2), lid.x(3));
    p = pTransform(lid.p, T);

    xs = pTransform([0.6; 0], T);
    for i = 1:length(p)
        if lid.range(i) > 0.02
            gm.setBeam(xs', p(:,i)', lid.range(i) < 3.8);
        end
    end
    set(h, 'CData', gm.map);
end