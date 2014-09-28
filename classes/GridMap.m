%Gridmap A occupancy grid map class
%
%   This class represents a occupancy grid map class. The map is
%   represented by a NxM matrix of resolution R. Each cell of the map
%   represents a (N/R)x(M/R) area and keeps the probability P that the area
%   is occupied (P = 1) or empty (P = 0). Initially, all the cells are set to
%   P = 0.5. This case means that the area is not explored yet.
%
%   Methods
%
%   Static methods
%
%   Properties
%
%   Examples
%
%   TODO
%       - Autoresize
%       - Custom origin
%       - Custom pfree


classdef GridMap < handle
    
    properties (SetAccess = private)
        resMap  % size of each cell, in m
        sizeMap        % size of the map, in
        map         % a NxM matrix
        origin
        pfree
        pocc
        lfree
        locc
    end
    
    methods
        function gm = GridMap(sizeMap, resMap)
            if ~isequal(size(sizeMap), [1 2])
                error('size must be a 1x2 vector');
            end
            if resMap <= 0
                error('resolution must be greather than 0');
            end
            gm.resMap = resMap;
            gm.sizeMap = sizeMap;
            gm.origin = (sizeMap/2/resMap);
            
            % figure size of the matrix
            n = floor(sizeMap(1)/resMap);
            m = floor(sizeMap(2)/resMap);
            
            if (n < 1) || (m < 1)
                error('resolution must be less than size');
            end
            
            gm.map = zeros(m, n, 'double');
            gm.map(:) = 0.5;
            
            
            
            gm.pfree = 0.9;
            gm.pocc = 1 - gm.pfree;
            gm.lfree = logit(gm.pfree);
            gm.locc = logit(gm.pocc);
            
        end
        
        function [i, j] = getIndex(gm, p)
            if ~ gm.isInsideMap(p)
                error('Point outside the map');
            end
            
            x = round(p./gm.resMap + gm.origin);
            
            i = size(gm.map, 1) - x(2);
            j =  x(1);
            
            if nargout < 2
                i = [i, j];
            end
        end
        
        function b = isInsideMap(gm, p)
            b = p(1) > -gm.sizeMap(1)/2 && ...
                p(1) <  gm.sizeMap(1)/2 && ...
                p(2) > -gm.sizeMap(2)/2 && ...
                p(2) <  gm.sizeMap(2)/2;
        end
        
        function setBeam(gm, s, z, intercept)
            c1 = gm.getIndex(s);
            c2 = gm.getIndex(z);
            [I,J] = rasterize_line(c1, c2);
            ind = sub2ind(size(gm.map), I, J);
            
%           Vectorized code
            gm.map(ind(1:end-1)) = GridMap.updateCell(gm.map(ind(1:end-1)), gm.lfree);
            llast = intercept * gm.locc + ~intercept * gm.lfree;
            gm.map(ind(end)) = GridMap.updateCell(gm.map(ind(end)), llast);
            
%           Straightforward code
%             for k = 1 : length(ind) - 1
%                 i = ind(k);
%                 gm.map(i) = GridMap.updateCell(gm.map(i), gm.lfree);
%             end
%             if intercept
%                 gm.map(ind(end)) = GridMap.updateCell(gm.map(ind(end)), gm.locc);
%             else
%                 gm.map(ind(end)) = GridMap.updateCell(gm.map(ind(end)), gm.lfree);
%             end                                 
        end
        
        function map = update(gm, lid,  xr, p) 
            T = se2(xr(1), xr(2), xr(3)) * se2(0.6, 0, 0);disp('.');
            p = pTransform(p, T);disp('.');
            xs = pTransform([0.6; 0], T);disp('.');
            for i = 1:length(p)
                if lid.range(i) > 0.02
                    gm.setBeam(xs', p(:,i)', lid.range(i) < 3.8);
                end
            end
            disp('.');
            map = gm.map;disp('.');
        end
        
    end
    
    
    
    methods (Static)
        function P = updateCell(Pprev, lsensor)
            lprev = logit(Pprev);
            lcurr = lprev + lsensor;
            P = 1 - (1 ./ (1 + exp(lcurr)));
        end
    end
    
end

