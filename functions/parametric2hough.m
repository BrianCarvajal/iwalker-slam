function [ rho, theta ] = parametric2hough( m, c )
%parametric2hough - Transform a line from parametric to hough space.
%   [rho, theta] = parametric2hough(m,c)  
%   [y = m*x + c] -> [rho = x*cos(theta) + y*sin(theta)]
%
%   See also hough2parametric
    theta = atan((-1)/m);
    rho = c * sin(theta);
end

