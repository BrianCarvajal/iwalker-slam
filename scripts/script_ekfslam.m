



close all;

dlog = DataLog('iwalker-slam\data\laser_dataset08.mat');

lid = LIDAR();
rob = DifferentialRobot();
rob.dt = dlog.wheels.dt;
rob.attachLidar(lid, [0.6,0,0]);
dlog.startPolling();

ext = LandmarkExtractor();
ext.angularTolerance = 10.0;

map = LandmarkMap('test');


V = diag([0.005, 0.1*pi/180].^2);
P0 = diag([0.05, 0.05, 0.01].^2);
W = diag([0.05, 3*pi/180].^2);
ekf = EKFSLAM(rob, V, P0, 'map', map, 'estMap', true, 'W', W);

retHist = [];


figure;
axis equal;
hold on;
whitebg([0 0 0]);
grid on;

pl = Plotter(gca);

while dlog.availableData()
    
    [data, timestamp, source] = dlog.nextData();
    
    switch source
        
        
        case 'wheels'
            odo = rob.updateDifferential(double(data)/100);
            ekf.prediction(odo);
            %rob.x = ekf.x_est(1:3);
            axis([rob.x(1)-3 rob.x(1)+3 rob.x(2)-3 rob.x(2)+3]);
            %rob.plot;
            pl.plotRobot(rob.x, 'iii');
            pl.plotErrorXY(ekf.P_est(1:2,1:2), ekf.x_est(1:3), 'errorXY', 'c');
            pl.plotErrorAngle(ekf.P_est(3,3), ekf.x_est(1:3), 'errorAngle', 'y');
            xvh = [ekf.history.xv_est];
            pl.plotTrace(xvh(1:2,:)', 'trace.ekf', 'r');
            pl.plotTrace(rob.x_hist(:, 1:2), 'trace.rob', 'y');
            %rob.plot_xy('r');
            %ekf.plot_xy('b');
           
            pause(dlog.wheels.dt);
            hb = findobj(gcf, 'Tag', 'PlotBeam');
            if ~isempty(hb)
               set(hb, 'XData', NaN, 'YData', NaN'); 
            end
            drawnow;
        case 'laser'
            
            lid.setRangeData(double(data)/1000, timestamp);
            
            %% Transform the points: use the ekf estimaton
            x = ekf.x_est(1:3);
            
            T = se2(x(1), x(2), x(3)) * se2(lid.x(1), lid.x(2), lid.x(3));
            p = pTransform(lid.p, T);
            
            
            
            
            [landmarks, ret] = ext.extract(lid.range, p);
            retHist = [retHist, ret];
            if ~isempty(landmarks)
                
                if isempty(map.landmarks)
                    for lan = landmarks
                        map.addLandmarks(lan);
                        ekf.innovation(lan);
                    end
                else
                    for lan = landmarks
                       [v, i] = map.bestMatch(lan); 
                       
                       if v > 0.20
                           map.addLandmarks(lan);
                       else
                           lan.id = i;
                       end
                       
                       ekf.innovation(lan);
                       
                    end
                end
                map.landmarks.plot();
                
               
                xl = pTransform([0.6; 0], se2(x(1), x(2), x(3)));
                
                XB = [NaN];
                YB = [NaN];
                for lan = landmarks      
                    XB = [XB xl(1) lan.x NaN];
                    YB = [YB xl(2) lan.y NaN];                  
                end
                hb = findobj(gcf, 'Tag', 'PlotBeam');
                if isempty(hb)
                    hb = line([xl(1), lan.x], [xl(2), lan.y], 'Color', 'g');
                    set(hb, 'Tag', 'PlotBeam');
                else
                    set(hb, 'XData', XB, 'YData', YB);
                end
                
                
            end
            L = ret.edges;
            p = ret.p;
            for i = 1: size(L,2)
                
                X = p(1, L(:,i));
                Y = p(2, L(:,i));               
                line(X, Y, 'Color', 'r', 'LineWidth', 1);                
               
            end
            %pause(dlog.laser.dt);
            drawnow;
    end
    
    
    
end

