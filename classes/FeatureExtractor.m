%LandmarkExtractor SLAM's landmark extractor
%
%   This class extracts landmarks from range data of a LIDAR sensor.
%
%

classdef FeatureExtractor < handle

  
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
        function ext = FeatureExtractor()
            
            %% Default parameters
            ext.validRange = [0.01 5.5];
            ext.deadZoneAngle = 165;
            ext.maxClusterDist = 0.3;
            ext.minClusterPoints = 3;
            ext.maxOutliers = 1;
            ext.splitDist = 0.15;
            ext.lengthSegmentThresh = 0.5;
            ext.collinearityThresh = 0.3;
            % outputs
            ext.output = [];
        end
        

        function extract(ext, r, a, pw)  
            %pw = [r.*cosd(a); r.*sind(a)];
            %% Clusterize
            C = clusterize(pw, r, a, ext.validRange, ext.maxClusterDist, 3);
            
            %% Segment extraction
            S = repmat(Segment, size(C));
            sidx = 0;
            for c = C
                n = size(c.p, 2);            
                if c.valid && n > ext.minClusterPoints         
                    segs = splitAndFit(c.p, ext.splitDist, 5, ext.maxOutliers);
                    prevSeg = [];
                    for s = segs
                       if s.d > ext.lengthSegmentThresh
                          if ~isempty(prevSeg)
                             % If the previus segment is valid, we link
                             % the two segments
                             s.Sa = prevSeg;
                             prevSeg.Sb = s;
                          end
                          sidx = sidx + 1;
                          S(sidx) = s;
                          prevSeg = s;
                       else
                           prevSeg = [];
                       end
                    end
                end
            end
            S = S(1:sidx);

            %% Corner extraction
            Corners = repmat(CornerFeature, size(S));
            icor = 0;
            % Save corners Landmarks
            for s = S
               if ~isempty(s.Sb) && ...
                   s.perpendicularity(s.Sb) > 0.8
                   pc = s.interesection(s.Sb);
                   icor = icor + 1;
                   Corners(icor) = CornerFeature(pc, diag([0.01, 1*pi/180]));
               end
            end
            Corners = Corners(1:icor);
            
            %% Agroup segment in lines
            agrouped = false(1,length(S));
            S2 = [];
            for i = 1:length(S)
                if ~agrouped(i)
                    group = i;
                    agrouped(i) = true;
                    if isempty(S(i).Sb)
                        for j = i+1:length(S)
                            if ~agrouped(j) && isempty(S(j).Sa)
                                dd = pdist2(S(i).b, S(j).a);
                                rd = abs(S(i).rho - S(j).rho);
                                td = abs(angdiff(S(i).theta, S(j).theta));

                                if rd < 0.2 && td*180/pi < 20 && dd < 0.6
                                    agrouped(j) = true;
                                    group = [group j];
                                end
                            end
                        end
                    end
                    S2 = [S2 Segment([S(group).p])];
                end
                
                %seglins = [seglins SegmentedLine(S(group))];
            end
            S = S2;
            
            Segments = repmat(SegmentFeature, size(S));
            iseg = 0;
            for s = S
                if s.d > 1
                    sf = SegmentFeature([s.rho, s.theta, s.sd s.ed], diag([0.01, 1*pi/180]));
                    iseg = iseg + 1;
                    sf.id = -iseg;
                    Segments(iseg) = sf;
                end
            end
            Segments = Segments(1:iseg);
            

            ext.output.segments = S;
            ext.output.corners = Corners;
            ext.output.segmentFeatures = Segments;
            ext.output.clusters = C;
                    
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
