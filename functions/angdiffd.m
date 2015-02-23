%ANGDIFFD - Difference of two angles in degrees
%
%   D = ANGDIFF(TH1, TH2) returns the difference between angles TH1 
%   and TH2 on the circle.  The result is in the interval [-180 180).  

function d = angdiffd( th1, th2 ) 
    d = mod(th1-th2+180, 360) - 180;
end

