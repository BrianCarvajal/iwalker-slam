classdef VirtualLidar < hgsetget
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
       validRange       % [min, max], valid range
       validAngle       % [min, max], field of view, in degrees
       horizon 
       angularResolution 
       segments              
    end
    
   
    methods
        function this = VirtualLidar(segments)
           this.validRange = [0.1 4];
           this.horizon = 6;
           this.validAngle = [-90 90];
           this.angularResolution = 1;
           this.segments = segments;           
        end
        
        function [r, a] = getScan(this, xr, yr, ar)         
            % compute rays endpoints
            rMax = this.validRange(2);
            a = this.validAngle(1):this.angularResolution:this.validAngle(2);
            
                       
            if isempty(this.segments)
                r =zeros(size(a));
            else
                
                r = ones(size(a)) * this.horizon;
                xx = xr + cosd(a + ar)*rMax;
                yy = yr + sind(a + ar)*rMax;
                % form rays
                xxr = repmat(xr, size(xx));
                yyr = repmat(yr, size(yy));
                xyr = [xxr; yyr; xx; yy]';
                
                % adecuate map segments
                aa = [this.segments.a];
                aa = reshape(aa, 2, length(this.segments));
                bb = [this.segments.b];
                bb = reshape(bb, 2, length(this.segments));
                xys = [aa; bb]';

                % find ray-segments interesecctions
                out = lineSegmentIntersect(xyr, xys);
                for i = 1:length(a)
                    jj = find(out.intAdjacencyMatrix(i,:));
                    if ~isempty(jj)
                        [~, j] = min(out.intNormalizedDistance1To2(i, jj));
                        j = jj(j);
                        x = out.intMatrixX(i,j);
                        y = out.intMatrixY(i,j);
                        r(i) = sqrt((xr-x)^2 + (yr-y)^2);
                    else
                        r(i) = 0;
                    end
                end
            end
        end
    end
    
end

