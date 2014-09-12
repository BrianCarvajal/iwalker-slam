%%TODO: tener en cuenta separacion entre eje ruedas (rob.X) y el sensor

clear;
close all;
load('data/Sensors_data.mat');
laserData = LaserData('data/Sensors_Data.mat');

%% Adecuamos el vector de velocidades
wheel_speed = [left_angular_speed(:,2)*0.01, right_angular_speed(:,2)*0.01];
samples_wheels = size(left_angular_speed,1);



%% Inicializamos robot
V = diag([0.01, 0.1*pi/180].^2);
rob = DifferentialRobot(V);
rob.S = 0.52;
rob.r = 0.10;
rob.maxwspeed = Inf;
rob.alphalim = Inf;
rob.dt = 0.02;
rob.updateDifferential([0, 0]);
% Noise in range-bearing form
%W = diag([0.15, 5*pi/180].^2);
%Noise in (x,y) form
W = diag([0.030, 0.030].^2);
sensor = RangeBearingSensor(rob, Map(0), W);

P0 = diag([0.05, 0.05, 0.01].^2);
ekf = EKFSLAM(rob, V, P0, sensor, W, []);


plot_enabled = true;
M = [];

samples_laser = size(polar_laser_data,1);
j = 1;

map = FeatureMap();
features = [];
P = [];
Pr = [];
t_fex = 0.0;

h = figure;
axis equal;
hold on;
for i = 1:samples_wheels
    
    
    odo = rob.updateDifferential(wheel_speed(i,:));
    ekf.prediction(odo);
    %rob.x = ekf.x_est(1:3);
    %T = rob.transform_matrix();
    T = se2(ekf.x_est(1), ekf.x_est(2), ekf.x_est(3));
    Tr = se2(rob.x(1), rob.x(2), rob.x(3));
    
    
    %% Una lecture del LRF cada 20 lecturas de los encoders
    if mod(i-1,20) == 0 && j < samples_laser
        tic;
        s = laserData.getScanning(j);
        
        %% Obtenemos una lectura
        [d, a]  = s.getRange(:);
        
        % plot laser data
         p = polar2cartesian(d,a);
         p = [p(:,1:2), ones(length(p),1)];
         pp = (Tr * se2(0.6, 0, 0)*p')';
         
         Pr = vertcat(Pr,pp);
         %scatter(pp(:,1), pp(:,2), 1, '.c');
         pp = (T * se2(0.6, 0, 0)  * p')';
        % scatter(pp(:,1), pp(:,2), 1, '.m');
         P = vertcat(P, pp);
%          h = findobj(gcf, 'Tag', 'LaserPoints');
%          if isempty(h)
%              scatter(P(:,1), P(:,2), 5, '.b');
%          else
%              set(h, 'XData', P(:,1), 'YData', P(:,2));
%          end
        
        
        features = extract_features([d, a]);
        
        if ~isempty(features)
            for f = features
                f.transform(T*se2(0.6,0,0));
                
            end
            
            F = features;
            features = map.add_features(features);

            
            for f = features
                %f.plot();
                %z = cartesian2polar(f.pos, rob.x(1:2)', rob.x(3));
                z = cartesian2polar(f.pos, ekf.x_est(1:2)', ekf.x_est(3));
                %z = T\[f.pos 1]';
                %z = z(1:2)';
                %p = polar2cartesian(z(1), z(2));
                % scatter(p(1), p(2), 5, 'bo');
                
                js = f.id;
                

                ekf.innovation([f.x f.y], js, z);
                
                xm_est = ekf.x_est(4:end);
                
               % X = xm_est(1:2:end-1);
               % Y = xm_est(2:2:end);
                
              %  f.plot('r');
              %  scatter(X(js), Y(js), 'b');
                
                %f.plot();
            end
            
            % update features position
            
        %    compare_ekf_features(map,ekf);
            map.update_features(xm_est);
            %clf;
            t = toc;
            t_fex = t_fex +  t/149; 
        end
        j = j+1;
        %clf;
       % map.plot('b');
       % rob.plot_xy('b');
        %ekf.plot_xy('r');
        
        %scatter(rob.x(1), rob.x(2), 5 , '*r');
         %drawnow;
        
    end
    
    
    %rob.plot();
    
    
    
    if plot_enabled
        
%         clf;
%         hold on;
%         scatter(P(:,1), P(:,2), 'g.');
%         scatter(rob.x(1), rob.x(2),'.r');
%         scatter(ekf.x_est(1), ekf.x_est(2), 'bo');
%         drawnow;
%         pause(0.01)
        %M = [M ; getframe(h)];
        %hold off;
        % M = [M ; getframe(gcf)];
        
    end
    
    
end

figure;
axis equal;
hold on;
scatter(Pr(:,1), Pr(:,2), 1, 'b');
rob.plot_xy('b');

figure;
axis equal;
hold on;

scatter(P(:,1), P(:,2), 1, 'b')
ekf.plot_xy('r');
map.plot('g');
ekf.plot_map
