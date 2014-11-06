%LandmarkExtractor SLAM's landmark extractor
%
%   This class extracts landmarks from range data of a LIDAR sensor.
%
%

classdef LandmarkExtractor < handle

  
    properties
        
        %% Paremeters of the algorithm
        
        % Filtering
        validRange      % [min max] range data
        
        % Clusterization
        maxClusterDist  % max distance of two consecutive points in the same cluster
        
        % Split and Merge
        splitDist       % max point distance to a segment without split
        maxOutliers     % max number of outliers in a line
        % Landmark
        angularTolerance
        
    end
    
    
    
    methods
        function ext = LandmarkExtractor()
            
            %% Default parameters
            ext.validRange = [0.02 5];
            ext.maxClusterDist = 0.25;
            ext.splitDist = 0.1;
            ext.angularTolerance = 15.0;
            ext.maxOutliers = 3;
        end
        
        % p  : points in local frame
        % pw : points in world frame
        function [Landmarks, Info] = extract(ext, range, p, pw)
            
            Landmarks = [];
            %% Get points inside valid range
            %valid = find(range > opt.validRange(1) & range < opt.validRange(2));
            p = p(:, range > ext.validRange(1) & range < ext.validRange(2));
            pw = pw(:, range > ext.validRange(1) & range < ext.validRange(2));
            %% Clusterize
            ep = endpoints(p, ext.maxClusterDist, 0);
            
            %% Split and Merge
            LL = [];
            VV = [];
            for k = 1: size(ep, 2)
                pp = p(:, ep(1,k):ep(2,k));
                [L, V]= splitAndMerge(pp, ext.splitDist, ext.maxOutliers);
                
                % Add index offset
                offset = ep(1,k) - 1;
                L = L + offset;
                V = V + offset;
                
                LL = [LL L];
                VV = [VV V];
            end
            ls = [];
            %% Fit lines
            for i = 1:length(LL)
                if LL(2,i) - LL(1, i) > 5
                    pl = pw(:, LL(1, i):LL(2,i));
                    ls = [ls LineSegment(pl(1,:), pl(2,:))];
                end
            end
            
            %% Create Landmarks
            isLandmark = false(length(p), 1);
            landmark_count = 0;
            for i = 1:length(ls)-1
               for j = i+1:length(ls)-1
                   px = ls(i).intersect(ls(j));
                   lan = Landmark(px', [0 0]', 0, 0, [], []);
                   landmark_count = landmark_count + 1;
                   lan.id = landmark_count;
                   Landmarks = [Landmarks lan];
               end
            end
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
            
            
            %% Save outputs
            if nargout > 1
                Info.p = p;
                %Ret.valid = valid;
                Info.clusters = ep;
                Info.edges = LL;
                Info.vertices = VV;
                Info.segments = ls;
            end
            
        end
        
        
    end
end
