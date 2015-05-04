classdef EKFSLAM < hgsetget
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        X
        P
        P0
        rob
        map
        featureIndex
        
        estimateMap
        history
        keepHistory
    end
    
    methods
        
        function this = EKFSLAM(rob, map, P0)
            this.rob = rob;
            this.map = map;
            this.P0 = P0;
            this.keepHistory = true;
            this.estimateMap = true;
            
            this.init();
        end
        
        function init(this)
            this.rob.init();
            %this.map.init();
            
            this.P = this.P0;
            this.X = this.rob.Xr(:);
            
            this.history = [];
        end
        
        function prediction(this, odo)
            % split the state vector and covariance into chunks for
            % robot and map
            Xr_est = this.X(1:3);
            Xm_est = this.X(4:end);
            
            Prr_est = this.P(1:3,1:3);
            Pmm_est = this.P(4:end,4:end);
            Prm_est = this.P(1:3,4:end);
            
            % evaluate the state update function and the Jacobians
            % and predict its covariance
            Xr_pred = this.rob.f(Xr_est', odo)';
            
            Fx = this.rob.Fx(Xr_est, odo);
            Fv = this.rob.Fv(Xr_est, odo);
            Prr_pred = Fx*Prr_est*Fx' + Fv*this.rob.Vr*Fv';
            
            % compute the correlations
            Prm_pred = Fx*Prm_est;
            
            Pmm_pred = Pmm_est;
            Xm_pred = Xm_est;
            
            % put the chunks back together again
            this.X = [Xr_pred; Xm_pred];
            this.P = [Prr_pred Prm_pred; Prm_pred' Pmm_pred];
            
            if this.estimateMap
                this.updateMap();
            end
            
            % record time history
            if this.keepHistory
                this.saveHistory();
            end
        end
        
        function innovation(this, feature)
            if feature.isAnonymous()
                %% Data asociation
                mapFeature = this.dataAsociation(feature);              
            end
            
            X_pred = this.X;
            Xr_pred = X_pred(1:3);
            Xm_pred = X_pred(4:end);
            P_pred = this.P;
            
            if isempty(mapFeature) && ~this.estimateMap
               return; 
            end
            
            if isempty(mapFeature)
                %% New feautre: add to map
                if isa(feature, 'CornerFeature')
                    this.extendMap(feature);
                else
                    if feature.len > 1.5
                        feature.visibleSide = lineSide(feature.sp, feature.ep, Xr_pred(1:2));
                        this.extendMap(feature);
                    end
                end
                
            else
                %% Previous feature
                
%                 if mapFeature.updates > 5
%                     
%                 else
                    
                
                
                % get the map feature
                %mapFeature = this.map.features(feature.id);
                
                % get the feature index for state vector and covariance matrix
                %fi = this.featureIndex(mapFeature.id);
                
                % innovation in range-bearing form
                z = feature.h(Xr_pred');
                z_pred = mapFeature.h(Xr_pred');
                innov(1) = z(1) - z_pred(1);
                innov(2) = angdiff(z(2), z_pred(2));
%                 if abs(innov(1)) > 1
%                     beep;
%                     return;
%                 end
                
                if this.estimateMap
                    % index of the map feature
                    fi = this.featureIndex(mapFeature.id);
                    % compute Jacobian for this particular feature
                    Hx_k = mapFeature.Hxf(Xr_pred');
                    % create the Jacobian for all features
                    Hxm = zeros(2, length(Xm_pred));
                    Hxm(:, fi:fi+1) = Hx_k;
                else
                    Hxm = [];
                end
                Hxr = mapFeature.Hxr(Xr_pred');
                Hw = mapFeature.Hw(Xr_pred);
                Hx = [Hxr Hxm];
                
                %                 % compute Jacobian for this particular feature
                %                 Hx_k = mapFeature.Hxf(Xr_pred');
                %
                %                 % create the Jacobian for all features
                %                 Hx = zeros(2, length(Xm_pred));
                %                 Hx(:, fi:fi+1) = Hx_k;
                %                 Hw = mapFeature.Hw(Xr_pred);
                %
                %                 % concatenate Hx for for robot and map
                %                 Hxr = mapFeature.Hxr(Xr_pred');
                %                 Hx = [Hxr Hx];
                
                % compute innovation covariance
                S = Hx*P_pred*Hx' + Hw*feature.Vf*Hw';
                
                % compute the Kalman gain
                K = P_pred*Hx' / S;
                
                % update the state vector
                X_est = X_pred + K*innov';
                
                % wrap heading state for a vehicle
                X_est(3) = angdiff(X_est(3));
                
                % update the covariance
                % we use the Joseph form
                I = eye(size(P_pred));
                P_est = (I-K*Hx)*P_pred*(I-K*Hx)' + K*feature.Vf*K';
                
                % enforce P to be symmetric
                P_est = 0.5*(P_est+P_est');
                
                %                 % update features in map
                %                 Xm_est = X_est(4:end);
                %                 Pm_est = P_est(4:end, 4:end);
                %                 for feature = this.map.features
                %                     fi = this.featureIndex(feature.id);
                %                     Xf = Xm_est(fi:fi+1);
                %                     Pf = Pm_est(fi:fi+1, fi:fi+1);
                %                     feature.update(Xf, Pf);
                %                 end
                
                this.X = X_est;
                this.P = P_est;
                
                if this.estimateMap
                    this.updateMap();
                end
                
                % record time history
%                 if this.keepHistory
%                     this.saveHistory();
%                 end
            end
            
            
        end
        
    end
    
    methods (Access = private)
        
        function saveHistory(this)
            hist = [];
            hist.Xr = this.X(1:3);
            hist.Pr = this.P(1:3, 1:3);
            hist.X = this.X;
            hist.P = this.P;
            this.history = [this.history hist];
        end
        
        function updateMap(this)
            Xm = this.X(4:end);
            Pm = this.P(4:end, 4:end);
            for feature = this.map.features
                fi = this.featureIndex(feature.id);
                Xf = Xm(fi:fi+1);
                Pf = Pm(fi:fi+1, fi:fi+1);
                feature.update(Xf, Pf);
            end
        end
        
        function mapFeature = dataAsociation(this, feature)
            mapFeature = [];
            X_pred = this.X;
            Xr_pred = X_pred(1:3);
            Xm_pred = X_pred(4:end);
            P_pred = this.P;
            if isa(feature, 'CornerFeature')
                candidates = [];
                z = feature.h(Xr_pred');
                for corner = this.map.corners
                    if this.estimateMap
                        % index of the map feature
                        fi = this.featureIndex(corner.id);
                        % compute Jacobian for this particular feature
                        Hx_k = corner.Hxf(Xr_pred');
                        % create the Jacobian for all features
                        Hxm = zeros(2, length(Xm_pred));
                        Hxm(:, fi:fi+1) = Hx_k;
                    else
                        Hxm = [];
                    end
                    Hxr = corner.Hxr(Xr_pred');
                    Hw = corner.Hw(Xr_pred);
                    Hx = [Hxr Hxm];
                    
                    % compute innovation covariance
                    S = Hx*P_pred*Hx' + Hw*feature.Vf*Hw';
                    
                    % innovation in range-bearing form
                    
                    z_pred = corner.h(Xr_pred');
                    innov(1) = z(1) - z_pred(1);
                    innov(2) = angdiff(z(2), z_pred(2));

                    md = innov*(S\innov');
                    
                    if md^2 < 10
                        candidate.corner = corner;
                        candidate.md = md;
                        mapFeature= corner;
                        candidates = [candidates; candidate];
                    end
                end
                if ~isempty(candidates)
                    if size(candidates,1) == 1
                        mapFeature = candidates(1).corner;
                    else
                        % chose the best segment and delete the rest
                        
                        %segs = [candidates.segment];
                        %[~, i] = max([segs.len]);
                        [~, i] = min([candidates.md]);
                        mapFeature = candidates(i).corner;
                        if this.estimateMap
                            % delete the other segments
                            for j = 1:length(candidates)
                                if  j ~= i
                                    this.deleteFeature(candidates(j).corner);
                                    beep
                                end
                            end
                        end
                    end
                end
            else
                candidates = [];
                side = lineSide(feature.sp, feature.ep, Xr_pred(1:2));
                z = feature.h(Xr_pred);
                for segment = this.map.segments
  
                    if ~feature.overlaps(segment, 1)
                        continue;
                    end
                    
                    if side ~= segment.visibleSide
                        continue;
                    end

                    ed = point2segment(feature.ep', segment.ep', segment.sp');
                    sd = point2segment(feature.sp', segment.ep', segment.sp');
                    if ed > 1 || sd > 1
                        continue;
                    end

                    if this.estimateMap
                        % index of the map feature
                        fi = this.featureIndex(segment.id);
                        % compute Jacobian for this particular feature
                        Hx_k = segment.Hxf(Xr_pred);
                        % create the Jacobian for all features
                        Hxm = zeros(2, length(Xm_pred));
                        Hxm(:, fi:fi+1) = Hx_k;
                    else
                        Hxm = [];
                    end
                    Hxr = segment.Hxr(Xr_pred);
                    Hw = segment.Hw(Xr_pred);
                    Hx = [Hxr Hxm];

                    % compute innovation covariance
                    S = Hx*P_pred*Hx' + Hw*feature.Vf*Hw';

                    % innovation in range-bearing form

                    z_pred = segment.h(Xr_pred);
                    innov(1) = z(1) - z_pred(1);
                    innov(2) = angdiff(z(2), z_pred(2));

%                     if innov(1) > 0.2 || innov(2) > 20*pi/180
%                        continue; 
%                     end
%                     
                    md = innov*(S\innov');
                    if md > 10
                       continue; 
                    end
%                     md = ed + sd;
%                     if ed+sd < 5
                        candidate.segment = segment;
                        candidate.md = md;
                        candidates = [candidates; candidate];

%                     end
                end
                if isempty(candidates) && ...
                    ~isempty(this.map.segments) ...
                    && feature.len > 1
                    
                    disp('empty!');
                    
                end
                if ~isempty(candidates)
                        % chose the best segment and delete the rest
                        
                        %segs = [candidates.segment];
                        %[~, i] = max([segs.len]);
                        [~, i] = min([candidates.md]);
                        mapFeature = candidates(i).segment;
                        if this.estimateMap
                            % update length of the map segment
                            segs = [candidates.segment feature];
                            mapFeature.s = min([segs.s]);
                            mapFeature.e = max([segs.e]);
                        
                            % delete the other segments
                            for j = 1:length(candidates)
                                if  j ~= i && candidates(j).segment.updates < 10
                                    this.deleteFeature(candidates(j).segment);
                                end
                            end
                        end
                    
                end
            end
        end
        
        function extendMap(this, feature)
            % split the state vector and covariance into chunks for
            % vehicle and map
            Xr = this.X(1:3);
            Xm = this.X(4:end);
            
            % extend the state vector
            Xf = feature.Xf(:);
            X_ext = [Xr; Xm; Xf(1:2)];
            
            
            % get the Jacobian for the new feature
            z = feature.h(Xr');
            Gz = feature.Gz(Xr, z);
            
            % extend the covariance matrix
            Gx = feature.Gx(Xr, z);
            n = length(this.X);
            M = [eye(n) zeros(n,2); Gx zeros(2,n-3) Gz];
            P_ext = M*blkdiag(this.P, feature.Vf)*M';
            
            % add the feature to the map and obtain its id
            this.map.addFeature(feature);
            
            % record the position in the state vector where this
            % feature's state starts
            this.featureIndex(feature.id) = length(Xm) + 1;
            
            this.X = X_ext;
            this.P = P_ext;
        end
        
        function deleteFeature(this, feature)
            fi = this.featureIndex(feature.id);
            % update index of features with a greater id
            this.featureIndex(feature.id:end) = ...
                this.featureIndex(feature.id:end) - 2;
            
            this.featureIndex(feature.id) = NaN;
            % delete feature from state vector and covariance matrix
            n = size(this.P, 1);
            ir = 1:1:n;
            irv = ir ~= 3+fi & ir ~= 4+fi;
            
            this.X = this.X(irv);
            this.P = this.P(irv, irv);
            
            this.map.deleteFeature(feature);
            
        end
        
        
        
        
    end
    
end

