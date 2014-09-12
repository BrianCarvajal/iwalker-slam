
%clear all;
close all;

dlog = DataLog('iwalker-slam\data\laser_dataset07.mat');

lid = LIDAR();
rob = DifferentialRobot();
rob.dt = dlog.wheels.dt;
rob.attachLidar(lid, [0.6,0,0]);
dlog.startPolling();
figure;
axis equal;
pl = Plotter(gca);
gm = GridMap([60 60], 0.05);
h = imshow(gm.map );

tt = 0;
total = 0;
while dlog.availableData()

   [data, timestamp, source] = dlog.nextData();
   
   switch source
       case 'wheels'
           rob.updateDifferential(double(data)/100);
       case 'laser'   
           lid.setRangeData(double(data)/1000, timestamp);
            x = rob.x;
            T = se2(x(1), x(2), x(3)) * se2(lid.x(1), lid.x(2), lid.x(3));
            p = pTransform(lid.p, T);
            
            xs = pTransform([0.6; 0], T);
            for i = 1:length(p)
               tic
               if lid.range(i) > 0.02                   
                    gm.setBeam(xs', p(:,i)', lid.range(i) < 3.8);
               end
               t = toc;
               tt = 0.1 * t + 0.9 * tt;
               total = total + t;
               %num2str(tt)
            end
            set(h, 'CData', gm.map);
            
   end  
    %
    drawnow;
end

