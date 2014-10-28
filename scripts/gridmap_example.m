
%clear all;
close all;

dlog = DataLog('iwalker-slam\data\laser_essai.mat');

lid = LIDAR();
rob = DifferentialRobot();
rob.dt = dlog.wheels.dt;
rob.attachLidar(lid, [0.6,0,0]);
dlog.startPolling();
figure;
gm = GridMap([-5 40], [-15 15], 0.1);
h = imshow(gm.image, gm.R );
pl = Plotter(h);
hold on
axis xy
tt = 0;
total = 0;
while dlog.availableData()

   [data, timestamp, source] = dlog.nextData();
   
   switch source
       case 'wheels'
           rob.updateDifferential(double(data));
           pl.plotRobot(rob.x, 'r');
           hold off;
       case 'laser'  
           tic;
           lid.setRangeData(double(data)/1000, timestamp);
           
            p = lid.p; 
            T = lid.globalTransform;
            r = lid.range;
            rlim = [0.02 3.8];
            gm.update(p,T,r,rlim);
  
%             for i = 1:length(p)
%                tic
%                if lid.range(i) > 0.02                   
%                     gm.setBeam(xs', p(:,i)', lid.range(i) < 3.8);
%                end
%                t = toc;
%                tt = 0.1 * t + 0.9 * tt;
%                total = total + t;
%                %num2str(tt)
%             end
            set(h, 'CData', gm.image);
            hold on;
            
   end  
    %
    drawnow;
end

