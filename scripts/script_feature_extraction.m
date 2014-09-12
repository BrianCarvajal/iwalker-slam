
clear;
load('data/Sensors_data.mat');
laserData = LaserData('data/Sensors_Data.mat');

%% Adecuamos el vector de velocidades
wheel_speed = [left_angular_speed(:,2)*0.01, right_angular_speed(:,2)*0.01];
samples_wheels = size(left_angular_speed,1);

%% Inicializamos robot
rob = DifferentialRobot();
rob.S = 0.52;
rob.r = 0.1;
rob.maxwspeed = Inf;
rob.alphalim = Inf;
rob.dt = 0.02;
rob.updateDifferential([0, 0]);

plot_enabled = true;
M = [];

samples_laser = size(polar_laser_data,1);
j = 1; 



h = figure;
hold on;
for i = 1:samples_wheels
    
    
    rob.updateDifferential(wheel_speed(i,:));
    T = rob.transform_matrix();
    
    %% Una lecture del LRF cada 20 lecturas de los encoders
    if mod(i-1,20) == 0 && j < samples_laser
        
        s = laserData.getScanning(j);
        
        %% Obtenemos una lectura
        [d, a]  = s.getRange(:);
              
        features = extract_features([d, a]);
               
        if ~isempty(features)
            for f = features
                f.transform(T);
                f.plot('b');
            end
        end
        
       
       j = j+1; 
    end
    
    
    
    %scatter(rob.x(1), rob.x(2), 1, '.r');
    rob.plot();
    
    if plot_enabled
       drawnow;
       pause(0.02)
       M = [M ; getframe(h)];
        %hold off;
       % M = [M ; getframe(gcf)];
    end
    

end
