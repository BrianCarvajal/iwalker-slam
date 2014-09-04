classdef GridMap < handle
    %UNTITLED7 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        resMap  % size of each cell, in m
        sizeMap        % size of the map, in 
        map         % a NxM matrix
        origin

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
        end
        
        function [i, j] = getIndex(gm, p)
            if ~ gm.isInsideMap(p)
               error('Point outside the map'); 
            end
            
            x = round(p./gm.resMap + gm.origin);
            
            i = size(gm.map, 2) - x(2);
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
             
             pfree = 0.9;
             pocc = pfree - 1;
             lfree = logOdds(pfree);
             locc = logOdds(pocc);
             
%              for i = ind
%                 gm.map(i) = 1; 
%              end
%              return;
             
             for k = 1 : length(ind) - 1
                 i = ind(k);
                 gm.map(i) = gm.map(i) + 0.1;%GridMap.updateCell(gm.map(i), lfree);
             end
             
             zi = ind(end);
             if intercept
                gm.map(zi) = gm.map(zi) - 0.1; %GridMap.updateCell(gm.map(zi), locc);
             else
                 gm.map(zi) = gm.map(zi) + 0.1; GridMap.updateCell(gm.map(zi), lfree);
             end
        end
    end
    
    methods (Static)
        function P = updateCell(Pprev, lsensor)
           lprev = logOdds(Pprev);
           lcurr = lprev + lsensor;
           P = 1 - (1 / (1 + exp(lcurr)));
        end
    end
    
end

