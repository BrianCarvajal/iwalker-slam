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
        function this = SimulationEngine()
            
            % Default settings
%             s.dt = 0.01;
%             s.lid_x = [0.6 0, 0]; %[0.35, 0, 0]; [Hokuyo / RPLidar]
%             s.lid_type = 'rplidar'; % rplidar or hokuyo
%             s.modegmp = false;
%             s.V = diag([0.005, 0.1*pi/180].^2);
%             s.W = diag([0.1, 0.05*pi/180].^2);
%             s.P0 = diag([0.05, 0.05, 0.01].^2);
%             s.gmp_xlim = [-20 20];
%             s.gmp_ylim = [-20 20];
%             s.gmp_res = 0.10;
%             s.ext_validRange = [0.10 7];
%             s.ext_maxClustDist = 0.15;
%             s.ext_SplitDist = 0.10;
%             s.ext_angularTolerance = 15.0;
%             s.ext_ext.maxOutliers = 3;
%             obj.settings = s;  
            
%             obj.init();
        end
        
        function init(this)
            s = this.settings;
            
            % Lidar
            this.lid = LIDAR();
            this.lid.validRange = [s.Lidar_RangeMin s.Lidar_RangeMax];
            this.lid.outlierDist = s.LandmarkExtractor_ClusterSplitDist;
            this.lid.horizon = s.Lidar_Horizon;
            this.lid.deadAngle = s.Lidar_DeadAngle;
            % Landmark Map
            this.map = LandmarkMap('manual mapping');
            
            
            % Landmar Extractor
            this.ext = LandmarkExtractor();
            this.ext.validRange = this.lid.validRange;
            this.ext.maxClusterDist = s.LandmarkExtractor_ClusterSplitDist;
            this.ext.splitDist = s.LandmarkExtractor_LineSplitDist;
            this.ext.maxOutliers = s.LandmarkExtractor_MaxOutliers;
            
            % Robot
            this.rob = DifferentialRobot();
            this.rob.x0 = [s.Rob_x0; s.Rob_y0; s.Rob_th0*pi/180];
            this.rob.dt = s.Rob_dt;
            this.rob.attachLidar(this.lid, [s.Lidar_x s.Lidar_y s.Lidar_th]);
                        
            % EKF
            V = diag([s.EKF_Vd, s.EKF_Vth*pi/180].^2);
            P0 = diag([s.EKF_P0x s.EKF_P0y s.EKF_P0th*pi/180].^2);
            W = V; % TODO
            this.ekf = EKFSLAM(this.rob, V, P0, 'map', this.map, 'estMap', false, 'W', V);
            this.ekf.x_est(1:3) = this.rob.x(1:3);
            
            % Grid Map
            xlims = [s.GridMap_LimitsMinX s.GridMap_LimitsMaxX];
            ylims = [s.GridMap_LimitsMinY s.GridMap_LimitsMaxY];
            if s.GridMap_ByteMode
                this.gmp = GridMap8b(s.GridMap_Resolution, xlims , ylims);
            else
                this.gmp = GridMap(s.GridMap_Resolution, xlims , ylims);
                this.gmp.setPlfree(s.GridMap_Plfree);
            end 
        end
        
        function stepOdometry(this, odo)
            this.rob.updateOdometry(odo);
            if odo(1) ~= 0 || odo(2) ~= 0
                this.ekf.prediction(odo);
            end
            % Save log for future querys
        end
        
        function stepScan(this, range, angle)
        %SimulationEngine.stepScan Process a new scan input
        %
        % SimulationEngine.stepScan(R, A)       
        %   R:  a vector with range data, in m.
        %   A:  a vector with angle data, in degrees.    
            
            % A lot of stuff to do here...
            lid = this.lid;
            gmp = this.gmp;
            ext = this.ext;
            
            lid.newScan(range, angle);
            ext.extract(lid);
            if this.settings.GridMap_Enabled     
                gmp.update(lid.x, lid.pw(:,lid.valid), lid.range(lid.valid), ext.validRange);
            end
        end
    end
    
end

