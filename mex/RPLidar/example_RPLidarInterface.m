

r = RPLidarInterface();
if (r.connect(3))
    rad = RadarAxes();
    lid = LIDAR();
    f = 1;
    while ( ishandle(rad.Parent))
        [f,c,range,angle] = r.getScan();
        lid.newScan(range/1000, angle);
        rad.drawPoints('p', lid.p(:,lid.valid), 1, [0 0.7 0.7], '.');
        rad.drawRays('r', lid.p(:,lid.valid), [0 0.3 0.3], 1, '-')

        pause(0.2);
    end  
end

rad.delete();
r.delete();