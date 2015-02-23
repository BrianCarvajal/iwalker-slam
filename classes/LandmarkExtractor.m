%LandmarkExtractor SLAM's landmark extractor
%
%   This class extracts landmarks from range data of a LIDAR sensor.
%
%

classdef LandmarkExtractor < handle

  
    properties
        
        %% Paremeters of the algorithm
        validRange      % [min max] range data
        deadZoneAngle         
        maxClusterDist
        minClusterPoints
        maxOutliers
        splitDist
        lengthSegmentThresh
        collinearityThresh
        
        
       
    end
    
    properties (SetAccess = private)
        output
    end
    
    
    
    methods
        function ext = LandmarkExtractor()
            
            %% Default parameters
            ext.validRange = [0.01 5.5];
            ext.deadZoneAngle = 165;
            ext.maxClusterDist = 0.3;
            ext.minClusterPoints = 3;
            ext.maxOutliers = 3;
            ext.splitDist = 0.15;
            ext.lengthSegmentThresh = 0.5;
            ext.collinearityThresh = 0.1;
            % outputs
            ext.output = [];
        end
        

        function Landmarks = extract(ext, lid)
            
            r = lid.range;
            r(r==0 | r>6) = 6;
            a = lid.angle;
            p = [r .* cosd(a); r .* sind(a)];
            Tw = lid.Tw;
            pw = pTransform(p, Tw);
            
            Landmarks = [];
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%% Preproces %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            
            %% Find points in dead zone (behind iwalker)
            deadZone = lid.angle > 180-ext.deadZoneAngle/2 & lid.angle < 180+ext.deadZoneAngle/2;
            pDeadZone = p(:,deadZone);
            pwDeadZone = pw(:,deadZone);
            p = p(:, ~deadZone);
            pw = pw(:, ~deadZone);
            r = r(~deadZone);
            a = a(~deadZone);
            
            %% Find outliers
            pd = pdist2next(p);
            outlier = false(size(pd));
            for i = 2:length(outlier)-1
                outlier(i) = pd(i-1) > ext.maxClusterDist && pd(i) > ext.maxClusterDist;
            end
            pOutlier = p(:, outlier);
            pwOutlier = pw(:, outlier);
            p = p(:, ~outlier);
            pw = pw(:, ~outlier);
            r = r(~outlier);
            a = a(~outlier);
            
            
            p = lid.p(:, ~lid.outliers & ~lid.inDeadAngle);
            pw = lid.pw(:, ~lid.outliers & ~lid.inDeadAngle);
            r = lid.range(~lid.outliers & ~lid.inDeadAngle);
            a = lid.angle(~lid.outliers & ~lid.inDeadAngle);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%% Line extraction %%%%%%%%%%%%%%%%%%%%%%%%%%
            
            %% Clusterize
            C = clusterize(p,r,a, ext.validRange, ext.maxClusterDist);
            
            
            %% Split and Merge
            LL = [];
            VV = [];
            oclusor = false(1,length(pw));
            for i = 1: length(C)
                cl = C{i};
                n = cl.end - cl.start;
                if n > ext.minClusterPoints && ~cl.outOfRange
                    oclusor(cl.start) = cl.startOclusor;
                    oclusor(cl.end) = cl.endOclusor;
                    pp = pw(:, cl.start:cl.end);
                    [L, V]= splitAndMerge(pp, ext.splitDist, ext.maxOutliers);
                    % Add index offset
                    offset = cl.start - 1;
                    L = L + offset;
                    V = V + offset;
                    
                    LL = [LL L];
                    VV = [VV V];
                end
            end
            
            olans = [];
            %% Fit segments
            segs = [];
            for i = 1:size(LL,2)
                if LL(2,i) - LL(1, i) > 5    
                    pl = pw(:, LL(1, i):LL(2,i));
                    s = Segment(pl);
                    if s.d > ext.lengthSegmentThresh
                        if oclusor(LL(1,i))
                            s.aOclusor = true;
                            Landmarks = [Landmarks Landmark(s.a,2)];
                        end
                        if oclusor(LL(2,i))
                            s.bOclusor = true;
                            Landmarks = [Landmarks Landmark(s.b,2)];
                        end
                        segs = [segs s];
                    end
                end
            end
            
            %% Agroup segment in lines
            agrouped = false(1,length(segs));
            seglins = [];
            for i = 1:length(segs)
               if ~agrouped(i)
                  group = i;
                  agrouped(i) = true;
                  for j = i+1:length(segs)
                     if ~agrouped(j)
                        if collinearity(segs(i), segs(j)) < ext.collinearityThresh
                           agrouped(j) = true;
                           group = [group j];
                        end
                     end
                  end
                  seglins = [seglins SegmentedLine(segs(group))];
               end
            end
            
            %% Construct Landmarks
            for i = 1:length(seglins)
                for j = i+1:length(seglins)
                    k = seglins(i).perpendicularity(seglins(j));
                    if k > 0.5
                        %TODO: implement SegmentedLine.interesections !
                        [qq, ff] = seglins(i).interesection(seglins(j));
                        if ff == 1 % virtual landmark
                            %vlans = [vlans Landmark(qq, 3)];
                        elseif ff == 2
                           % elans = [elans Landmark(qq, 2)];
                        elseif ff == 3 % corner landmark
                            Landmarks = [Landmarks Landmark(qq, 1)];
                        end
                    end
                end
            end

            %% Find points too near or too far (just for paint)
            outRange = r < ext.validRange(1) | r > ext.validRange(2);
            pOutRange = p(:,outRange);
            pwOutRange = pw(:,outRange);
            p = p(:, ~outRange);
            pw = pw(:, ~outRange); 
            
            ext.output.segments = segs;
            ext.output.lines = seglins;
            ext.output.landmarks = Landmarks;
            ext.output.p = p;
            ext.output.pDeadZone = pDeadZone;
            ext.output.pOutlier = pOutlier;
            ext.output.pOutRange = pOutRange;
            ext.output.pw = pw;
            ext.output.pwDeadZone = pwDeadZone;
            ext.output.pwOutlier = pwOutlier;
            ext.output.pwOutRange = pwOutRange;
            ext.output.clusters = C;
            ext.output.edges = LL;
            ext.output.vertices = VV;
            ext.output.segments = segs;
            ext.output.lines = seglins;            
%             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             %% Get points inside valid range
%             %valid = find(range > opt.validRange(1) & range < opt.validRange(2));
%             p = p(:, range > ext.validRange(1) & range < ext.validRange(2));
%             pw = pw(:, range > ext.validRange(1) & range < ext.validRange(2));
%             %% Clusterize
%             ep = endpoints(p, ext.maxClusterDist);
%             
%             %% Split and Merge
%             LL = [];
%             VV = [];
%             for k = 1: size(ep, 2)
%                 n = ep(2,k) - ep(1,k) + 1; % number of points
%                 if n > 5 % minimum 5 points per cluster
%                     pp = p(:, ep(1,k):ep(2,k));
%                     [L, V]= splitAndMerge(pp, ext.splitDist, ext.maxOutliers);
% 
%                     % Add index offset
%                     offset = ep(1,k) - 1;
%                     L = L + offset;
%                     V = V + offset;
% 
%                     LL = [LL L];
%                     VV = [VV V];
%                 end
%             end
%             segs = [];
%             %% Fit segments
%             for i = 1:length(LL)
%                 if LL(2,i) - LL(1, i) > 5
%                     pl = pw(:, LL(1, i):LL(2,i));
%                     s = Segment(pl);
%                     if s.d > 0.15
%                         segs = [segs Segment(pl)];
%                     end
%                 end
%             end
%             
%             %% Agroup segment in lines
%             agrouped = false(1,length(segs));
%             seglins = [];
%             for i = 1:length(segs)
%                if ~agrouped(i)
%                   group = i;
%                   agrouped(i) = true;
%                   for j = i+1:length(segs)
%                      if ~agrouped(j)
%                         if collinearity(segs(i), segs(j)) < 1
%                            agrouped(j) = true;
%                            group = [group j];
%                         end
%                      end
%                   end
%                   seglins = [seglins SegmentedLine(segs(group))];
%                end
%             end
%             
            %% Create Landmarks
%             isLandmark = false(length(p), 1);
%             landmark_count = 0;
%             for i = 1:length(ls)-1
%                for j = i+1:length(ls)-1
%                    px = ls(i).intersect(ls(j));
%                    lan = Landmark(px', [0 0]', 0, 0, [], []);
%                    landmark_count = landmark_count + 1;
%                    lan.id = landmark_count;
%                    Landmarks = [Landmarks lan];
%                end
%             end
%             for i = 1: length(LL) - 1
%                 % Vertex
%                 if LL(2, i) == LL(1, i+1)
%                     i0 = LL(1, i);      % previous vertice index
%                     i1 = LL(2, i);      % current vertice index
%                     i2 = LL(2, i+1);    % next vertice index
%                     
%                     a = p(:, i0);
%                     b = p(:, i1);
%                     c = p(:, i2);
%                     
%                     u1 = (a - b)/norm(a - b);
%                     u2 = (c - b)/norm(c - b);
%                     
%                     % angle =  atan2d(det([u1 u2]), dot(u1, u2));
%                     angle = atan2d( u1(1)*u2(2)-u1(2)*u2(1) , u1(1)*u2(1)+u1(2)*u2(2) );
%                                    
%                     if abs(abs(angle) - 90) < ext.angularTolerance
%                                       
%                         u = a + c - 2*b;
%                         ori = atan2d(u(2), u(1));
%                         if ori < 0
%                             ori = ori + 360;
%                         end
%                         
%                         lan = Landmark(pw(:,i1), b, angle, ori, u1, u2);
%                         landmark_count = landmark_count + 1;
%                         lan.id = -landmark_count;
%                         isLandmark(i1) = true;
%                         if isLandmark(i0)
%                            lan.prev = Landmarks(end);
%                            Landmarks(end).next = lan;
%                         end
%                         Landmarks = [Landmarks lan];
%                         
%                     end
%                 end
%             end
%             ext.segments = segs;
%             ext.lines = seglins;
%             %% Save outputs
%             if nargout > 1
%                 Info.p = p;
%                 %Ret.valid = valid;
%                 Info.clusters = ep;
%                 Info.edges = LL;
%                 Info.vertices = VV;
%                 Info.segments = segs;
%             end
            
        end
        
        
    end
end
