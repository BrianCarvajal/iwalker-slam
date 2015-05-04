

r = RPLidarInterface();
if (r.connect(3))
    rad = RadarAxes('radius', 3);
    colormap('cool');
    lid = LIDAR();
    f = 1;
    while ( ishandle(rad.Parent))
        [f,c,range,angle, quality] = r.getScan();
        if c > 0
            range = range(1:c);
            angle = angle(1:c);
            quality = quality(1:c);
            lid.newScan(range/1000, angle);
            rad.drawPoints('p', lid.p(:,:), 5, quality, 'x');
            %rad.drawRays('r', lid.p(:,:), 1, quality, '-')

            pause(0.2);
        end
    end  
end

rad.delete();
r.delete();