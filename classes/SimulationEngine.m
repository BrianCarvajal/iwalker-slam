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
    
    properties (Access = private)
        lastXr
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
            this.lid.outlierDist = s.FeatureExtractor_ClusterSplitDist;
            this.lid.horizon = s.Lidar_Horizon;
            this.lid.deadAngle = s.Lidar_DeadAngle;

            % Landmark Map
            this.map = FeatureMap();
            
            
            % Landmar Extractor
            this.ext = FeatureExtractor();
            this.ext.validRange = this.lid.validRange;
            this.ext.maxClusterDist = s.FeatureExtractor_ClusterSplitDist;
            this.ext.splitDist = s.FeatureExtractor_LineSplitDist;
            this.ext.maxOutliers = s.FeatureExtractor_MaxOutliers;
            
            % Robot
            V = diag([s.EKF_Vd, s.EKF_Vth*pi/180].^2);
            this.rob = DifferentialRobot('Vr', V);
            this.rob.Xr0 = [s.Rob_x0; s.Rob_y0; s.Rob_th0*pi/180];
            this.rob.attachLidar(this.lid, [s.Lidar_x s.Lidar_y s.Lidar_th*pi/180]);
            this.lastXr = [Inf; Inf; Inf];           
            % EKF
            
            P0 = diag([s.EKF_P0x s.EKF_P0y s.EKF_P0th*pi/180].^2);
            W = diag([0.1, 0.1*pi/180].^2);
            this.ekf = EKFSLAM(this.rob, this.map, P0);
            
            
            this.ekf.X(1:3) = this.rob.Xr(1:3);
            this.ekf.keepHistory = true;
            
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
            rob = this.rob;
            ekf = this.ekf;
            rob.updateOdometry(odo);
            %if odo(1) ~= 0 || odo(2) ~= 0
                ekf.prediction(odo);
                rob.Xr = ekf.X(1:3);
            %end
            
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
            ekf = this.ekf;
            rob = this.rob;
%             q = [];
%             if lid.count > 0
%                 q = lid.pw(:, lid.valid & lid.range > 1);                
%             end
                  
            lid.newScan(range, angle);
            
%             if lid.count > 1 && ~isempty(q)
%                 p = lid.pw(:, lid.valid & lid.range > 1);
%                 p3 = vertcat(p, ones(1,size(p,2)));
%                 q3 = vertcat(q, ones(1,size(q,2)));
%                 [TR, TT] = icp(p3,q3, 'Matching', 'kDtree');
%                 TM = TR;
%                 TM(1:2,3) = TT(1:2);
%                 TM(3,:) = [0 0 1];
%                 rot = atan2(TM(2,1), TM(1,1));
%                 if abs(rot*180/pi) > 1
%                     this.rob.x(3) = this.rob.x(3) - rot;
%                 end
%             end
            
 
            pw = lid.pw(:, ~lid.outliers & ~lid.inDeadAngle);
            r = lid.range(~lid.outliers & ~lid.inDeadAngle);
            a = lid.angle(~lid.outliers & ~lid.inDeadAngle);
            ext.extract(r, a, pw);
            
            out = ext.output;
            for corner = out.corners
                ekf.innovation(corner);
            end
            for sf = out.segmentFeatures
               ekf.innovation(sf); 
            end
            
            
            rob.Xr = ekf.X(1:3);
            
            
            if this.settings.GridMap_Enabled
                dd = sum((rob.Xr(1:2) - this.lastXr(1:2)).^2);
                da = angdiff(rob.Xr(3), this.lastXr(3));
                if dd > 0 || da > 0
                    v = downsample(find(lid.valid), 20);
                    gmp.update(lid.x', lid.pw(:,v), lid.range(v), ext.validRange);
                    this.lastXr = rob.Xr;
                end
            end
                
        end
    end
    
end

