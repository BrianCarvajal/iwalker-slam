function [m, c] = hough2parametric( rho, theta )
%hough2parametric - Transform a line from hough to parametric space.
%   [m,c] = hough2parametric(rho, theta)  
%   [rho = x*cos(theta) + y*sin(theta)] -> [y = m*x + c]
%
%   See also parametric2hough
    m = (-1)/tan(theta);
    c = rho/sin(theta);

end

