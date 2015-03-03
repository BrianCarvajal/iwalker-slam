

r = URGInterface();
if (r.connect(5))
    rad = RadarAxes();
    lid = LIDAR();
    f = 1;
    while ( ishandle(rad.Parent))
        range = r.getScan();
        angle = ((0.3515625 *((1:682) - 1)) - 120);
        lid.newScan(range/1000, angle);
        rad.drawPoints('p', lid.p(:,lid.valid), 1, [0 0.7 0.7], '.');
        rad.drawRays('r', lid.p(:,lid.valid), [0 0.3 0.3], 1, '-')

        pause(0.2);
    end 
    rad.delete();
end

r.delete();