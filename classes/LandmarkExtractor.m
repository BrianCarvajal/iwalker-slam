classdef LandmarkExtractor < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    

    properties
        
        %% Paremeters of the algorithm
        
        % Filtering
        validRange      % [min max] range data
        
        % Clusterization
        maxClusterDist  % max distance of two consecutive points in the same cluster
        
        % Split and Merge
        splitDist       % max point distance to a segment without split

        % Landmark
        angularTolerance
        
    end
    
    
    
    methods
        function ext = LandmarkExtractor()
            
            %% Default parameters
            ext.validRange = [0.02 3.8];
            ext.maxClusterDist = 0.10;
            ext.splitDist = 0.05;
            ext.angularTolerance = 15.0;
        end
        
        function [Landmarks, Ret] = extract(ext, range, p)
            
            Landmarks = [];
            %% Get points inside valid range
            %valid = find(range > opt.validRange(1) & range < opt.validRange(2));
            p = p(:, range > ext.validRange(1) & range < ext.validRange(2));
            
            %% Clusterize
            ep = endpoints(p, ext.maxClusterDist, 0);
            
            %% Split and Merge
            LL = [];
            VV = [];
            for k = 1: size(ep, 2)
                pp = p(:, ep(1,k):ep(2,k));
                [L, V]= splitAndMerge(pp, ext.splitDist);
                
                % Add index offset
                offset = ep(1,k) - 1;
                L = L + offset;
                V = V + offset;
                
                LL = [LL L];
                VV = [VV V];
            end
            
            %% Create Landmarks
            isLandmark = false(length(p), 1);
            for i = 1: length(LL) - 1
                % Vertex
                if LL(2, i) == LL(1, i+1)
                    i0 = LL(1, i);      % previous vertice index
                    i1 = LL(2, i);      % current vertice index
                    i2 = LL(2, i+1);    % next vertice index
                    
                    a = p(:, i0);
                    b = p(:, i1);
                    c = p(:, i2);
                    
                    u1 = (a - b)/norm(a - b);
                    u2 = (c - b)/norm(c - b);
                    
                    % angle =  atan2d(det([u1 u2]), dot(u1, u2));
                    angle = atan2d( u1(1)*u2(2)-u1(2)*u2(1) , u1(1)*u2(1)+u1(2)*u2(2) );
                                   
                    if abs(abs(angle) - 90) < ext.angularTolerance
                                      
                        u = a + c - 2*b;
                        ori = atan2d(u(2), u(1));
                        if ori < 0
                            ori = ori + 360;
                        end
                        lan = Landmark(b, angle, ori, u1, u2);                    
                        isLandmark(i1) = true;
                        if isLandmark(i0)
                           lan.prev = Landmarks(end);
                           Landmarks(end).next = lan;
                        end
                        Landmarks = [Landmarks lan];
                        
                    end
                end
            end
            
            
            %% Save outputs
            if nargout > 1
                Ret.p = p;
                %Ret.valid = valid;
                Ret.clusters = ep;
                Ret.edges = LL;
                Ret.vertices = VV;
            end
            
        end
        
        
    end
end
