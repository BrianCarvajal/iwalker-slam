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


classdef GridMap8b < handle
    
    properties (SetAccess = private)
        resMap      % size of each cell, in m
        sizeMap     % size of the map, in
        map         % a NxM matrix
        R           % imref2d instance, type help for more information
        origin
        inc
    end
    
    methods
        function gm = GridMap8b(res, xlim, ylim)
            if nargin < 3
               xlim = [-50 50];
               ylim = [-50 50]; 
            end
            if res <= 0
                error('resolution must be greather than 0');
            end
            
            n = floor((xlim(2) - xlim(1)) / res);
            m = floor((ylim(2) - ylim(1)) / res); 
            if (n < 1) || (m < 1)
                error('resolution must be less than size');
            end

            gm.R = imref2d([m,n], xlim, ylim);
            [oi, oj] = gm.R.worldToSubscript(0, 0);
            gm.origin = [oi oj];
            gm.sizeMap = [m n];
            gm.resMap = res;
            gm.map = ones([m n], 'uint8')*128;
            gm.inc = 20;            
        end
        
        function [i, j] = getIndex(gm, p)
            if ~ gm.isInsideMap(p)
                error('Point outside the map');
            end
            
            x = round(p./gm.resMap);% + gm.origin;           
            i =  x(2) + gm.origin(1);
            j =  x(1) + gm.origin(2);
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
        
        function resizeMap(gm, p)
            error('Not implemented');
            return;
            increment = 5;
            if p(1) < gm.R.XWorldLimits(1)
                x = p(1) - increment;
                xlim = [x gm.R.XWorldLimits(2)];
            elseif p(1) > gm.R.XWorldLimits(2)
                x = p(1) + increment;
                xlim = [gm.R.XWorldLimits(1) x];
            else
                x = p(1);
                xlim = gm.R.XWorldLimits;
            end
            if p(2) < gm.R.YWorldLimits(1)
                y = p(2) - increment;
                ylim = [y gm.R.YWorldLimits(2)];
            elseif p(2) > gm.R.YWorldLimits(2)
                y = p(2) + increment;
                ylim = [gm.R.YWorldLimits(1) y];
            else
                y = p(2);
                ylim = [gm.R.YWorldLimits(1) gm.R.YWorldLimits(2)];
            end
            n = floor((xlim(2) - xlim(1)) / gm.resMap);
            m = floor((ylim(2) - ylim(1)) / gm.resMap);
            gm.R = imref2d([m n], xlim, ylim);
            [i, j] = gm.R.worldToSubscript(x,y);
            gm.map(i,j) = 0.0001;
        end        
        
        function setBeam(gm, s, z, intercept)
            try 
                [si, sj] = gm.getIndex(s);
                [zi, zj] = gm.getIndex(z);
                [I,J] = GridMap8b.rasterizeLine(si,sj,zi,zj);
                ind = sub2ind(size(gm.map), I, J);

                %           Vectorized code
                gm.map(ind(1:end-1)) = gm.map(ind(1:end-1)) + GridMap8b.cellIncrement(gm.map(ind(1:end-1)));
                if intercept
                    gm.map(ind(end)) = gm.map(ind(end)) -  GridMap8b.cellIncrement(gm.inc);
                else
                    gm.map(ind(end)) = gm.map(ind(end)) +  GridMap8b.cellIncrement(gm.inc);
                end
            catch
                
            end

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
        
        %GridMap.update Update the gridmap with the new sensor data
            %
            % M = GM.update(XS, P, R, RLIM) updates the grid map GM with the 
            % laser data from sensor pose. 
            % XS is the position of the sensor.
            % P are the cartesians points.
            % R are the range of those points.
            % RLIM = [min, max], where min sets the minimal range for trace
            % a beam and max sets where we consider the beam intersects an
            % obstacle or not.

        function update(gm, xs, p, range, rlim)
            for i = 1:length(p)
                if range(i) > rlim(1)
                    gm.setBeam(xs', p(:,i)', range(i) < rlim(2));
                end
            end 
        end
        
        function img = image(gm)
            img = gm.map;
        end
    end
    
    
    
    methods (Static)
        function x = cellIncrement(x)
            if x >= 127
                x = (257-x)/2;
            else
               x = x/2 + 1; 
            end
        end

        
        function [ X, Y ] = rasterizeLine( x1, y1, x2, y2 )
            dx = abs(x2 - x1);
            dy = abs(y2 - y1);
            s = max(dx, dy);
            P = zeros(2, s);
            if x1 < x2
                sx = 1;
            else
                sx = -1;
            end
            if y1 < y2
                sy = 1;
            else
                sy = -1;
            end
            err = dx - dy;
            i = 1;
            while x1 ~= x2 || y1 ~= y2
                P(:,i) = [x1 y1];
                e2 = 2*err;
                if e2 > -dy
                    err = err - dy;
                    x1 = x1 + sx;
                end
                if e2 < dx
                    err = err + dx;
                    y1 = y1 + sy;
                end
                i = i+1;
            end
            P(:,i) = [x1 y1];
            
            if nargout < 2
                X = P;
            else
                X = P(1, 1:i);
                Y = P(2, 1:i);
            end
        end
     
    end
end
