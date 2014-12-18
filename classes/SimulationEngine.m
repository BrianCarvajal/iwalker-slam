classdef SimulationEngine < handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        rob
        lid
        map
        gmp
        ext
        ekf
            
        settings
    end
    
    methods
        function obj = SimulationEngine()
            
            % Default settings
            s.dt = 0.01;
            s.lid_x = [0.35, 0, 0];
            s.lid_type = 'rplidar'; % rplidar or hokuyo
            s.modegmp = false;
            s.V = diag([0.005, 0.1*pi/180].^2);
            s.W = diag([0.1, 0.05*pi/180].^2);
            s.P0 = diag([0.05, 0.05, 0.01].^2);
            s.gmp_xlim = [-20 20];
            s.gmp_ylim = [-20 20];
            s.gmp_res = 0.10;
            s.ext_validRange = [0.10 7];
            s.ext_maxClustDist = 0.15;
            s.ext_SplitDist = 0.10;
            s.ext_angularTolerance = 15.0;
            s.ext_ext.maxOutliers = 3;
            obj.settings = s;  
            
            obj.initialize();
        end
        
        function initialize(obj)
            s = obj.settings;
            
            % Lidar
            obj.lid = RPLIDAR();
            
            % Landmark Map
            obj.map = LandmarkMap('manual mapping');
            
            % Landmar Extractor
            obj.ext = LandmarkExtractor();
            obj.ext.validRange = s.ext_validRange;
            obj.ext.maxClusterDist = s.ext_maxClustDist;
            obj.ext.splitDist =s.ext_SplitDist;
            obj.ext.angularTolerance = s.ext_angularTolerance;
            obj.ext.maxOutliers = s.ext_ext.maxOutliers;
            
            % Robot
            obj.rob = DifferentialRobot();
            obj.rob.x0 = [0; 0; pi/2];
            obj.rob.dt = s.dt;
            obj.rob.attachLidar(obj.lid, s.lid_x);
                        
            % EKF
            obj.ekf = EKFSLAM(obj.rob, s.V, s.P0, 'map', obj.map, 'estMap', false, 'W', s.W);
            obj.ekf.x_est(1:3) = obj.rob.x(1:3);
            
            % Grid Map
            if s.modegmp
                obj.gmp = GridMap8b(s.gmp_res, s.gmp_xlim, s.gmp_ylim);
            else
                obj.gmp = GridMap(s.gmp_res, s.gmp_xlim, s.gmp_ylim);
            end          
        end
        
        function stepOdometry(obj, odo)
            obj.rob.updateOdometry(odo);
            if odo(1) ~= 0 || odo(2) ~= 0
                obj.ekf.prediction(odo);
            end
            % Save log for future querys
        end
        
        function stepScan(obj, range, angle)
            if nargin < 3 && strcmp(obj.settings.lid_type, 'rplidar')
                error('rplidar requires range and angle input');
            end
            
            % A lot of stuff to do here...
        end
    end
    
end

