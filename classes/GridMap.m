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



classdef GridMap < handle
    
    properties
       keepHist 
    end
    
    properties (SetAccess = private)
        resMap      % size of each cell, in m
        sizeMap     % size (N,M) of the map, in m
        map         % a NxM matrix
        R           % imref2d instance, type help for more information
        origin
        pfree
        pocc
        lfree
        locc       
    end
    
    properties (Access = private)
        map_hist       
    end
    
    
    methods
        function this = GridMap(res, xlim, ylim)
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
            
            this.R = imref2d([m,n], xlim, ylim);
            [oi, oj] = this.R.worldToSubscript(0, 0);
            this.origin = [oi oj];
            this.sizeMap = [m n];
            this.resMap = res;
            this.setPlfree(0.75);
            this.keepHist = false;
            this.init();
        end
        
        function init(this)
            this.map = ones(this.sizeMap, 'single')*0.5;
            this.map_hist = {};
            if this.keepHist
              this.map_hist{length(this.map_hist)+1} = GridMap.compressMap(this.map);             
            end
        end
        
        function setPlfree(this, p)
            if p >= 0 && p <= 1
                this.pfree = p;
                this.pocc = 1 - this.pfree;
                this.lfree = logit(this.pfree);
                this.locc = logit(this.pocc);
            end
        end
        
        function [i, j] = getIndex(this, p)
%             if ~ this.isInsideMap(p)
%                 error('Point outside the map');
%             end            
            x = round(p./this.resMap);       
            i =  x(2) + this.origin(1);
            j =  x(1) + this.origin(2);

            % Slower version
%           [i, j] = this.R.worldToSubscript(p(1), p(2));
        end
        
        function b = isInsideMap(this, p)
            b = p(1) > -this.sizeMap(1)/2 && ...
                p(1) <  this.sizeMap(1)/2 && ...
                p(2) > -this.sizeMap(2)/2 && ...
                p(2) <  this.sizeMap(2)/2;
        end
               
        
        function setBeam(this, s, p, intercept)
        %GridMap.setBeam Update the map with a beam
        %
        % setBeam(ij, p, intercept) updates the grid map with a beam
        % from point at index s and point at index p.
        %   ind - [i, j] 
        %   p - [i, j]
        %   intercept - true if the beam intercepts an obstacle
             
            [I,J] = GridMap.bresenham(s(1),s(2),p(1),p(2));
            ind = sub2ind(size(this.map), I, J);

            this.map(ind(1:end-1)) = GridMap.updateCell(this.map(ind(1:end-1)), this.lfree);
            llast = intercept * this.locc + ~intercept * this.lfree;
            this.map(ind(end)) = GridMap.updateCell(this.map(ind(end)), llast);

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
        
        
        
        function update(this, s, p, range, rlim)
            %GridMap.update Update the gridmap with the new sensor data
            %
            % M = GM.update(XS, P, R, RLIM) updates the grid map GM with the
            % laser data from sensor pose.
            % S is the position of the sensor.
            % P are the cartesians points.
            % R are the range of those points.
            % RLIM = [min, max], where min sets the minimal range for trace
            % a beam and max sets where we consider the beam intersects an
            % obstacle or not.
            if this.isInsideMap(s)
                [si, sj] = this.getIndex(s);
                valid = find(range < rlim(2));
                for i = valid
                    if this.isInsideMap(p(:,i))
                        [pi, pj] = this.getIndex(p(:,i));
                        this.setBeam([si, sj], [pi, pj], range(i) < rlim(2));
                    end
                end

            end
            if this.keepHist
                this.map_hist{length(this.map_hist)+1} = GridMap.compressMap(this.map);
            end
        end
        
        function img = image(this, index)
            if nargin == 2 && index > 1 && index <= length(this.map_hist)
                img = GridMap.uncompressMap(this.map_hist{index});
            else
                img = this.map;
            end
        end
    end
    
    
    
    methods (Static)
        function P = updateCell(Pprev, lsensor)
            lprev = logit(Pprev);
            lcurr = lprev + lsensor;
            P = 1 - (1 ./ (1 + exp(lcurr)));
        end

        function [ X, Y ] = rasterizeLine( x1, y1, x2, y2 )
        %Matlab slow version of Bresenham line algorithm.
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
        
        function [x, y] = bresenham(x1, y1, x2, y2)            
        %Matlab optmized version of Bresenham line algorithm. No loops.
            x1 = round(x1);
            x2= round(x2);
            y1 = round(y1);
            y2 = round(y2);
            dx = abs(x2-x1);
            dy = abs(y2-y1);
            steep = abs(dy) > abs(dx);
            if steep
                t = dx;
                dx = dy;
                dy = t;
            end
            
            %The main algorithm goes here.
            if dy == 0
                q = zeros(1,dx+1);
            else
                q = [0, diff(mod(floor(dx/2):-dy:-dy*dx+floor(dx/2),dx))>=0];
            end
            
            %and ends here. 
            sx = sign(x2-x1+eps);
            sy = sign(y2-y1+eps);
            if steep
                y = y1:sy:y2;
                x = x1 + sx*cumsum(q);
            else
                x = x1:sx:x2;
                y = y1 + sy*cumsum(q);
            end
            
%             if steep
%                 if y1<=y2
%                     y = [y1:y2]';
%                 else
%                     y = [y1:-1:y2]';
%                 end
%                 if x1 <= x2
%                     x = x1 + cumsum(q);
%                 else
%                     x = x1 - cumsum(q);
%                 end
%             else
%                 if x1 <= x2
%                     x = [x1:x2]';
%                 else
%                     x = [x1:-1:x2]';
%                 end
%                 if y1<=y2
%                     y=y1+cumsum(q);
%                 else
%                     y=y1-cumsum(q);
%                 end
%             end
        end
        
        function cimg = compressMap(img)
            cimg = sparse(double(img)-0.5);
        end
        
        function cimg = uncompressMap(img)
            cimg = full(double(img)+0.5);
        end
     
    end
end
