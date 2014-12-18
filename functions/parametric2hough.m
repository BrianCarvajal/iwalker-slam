function [ rho, theta ] = parametric2hough( m, c, isHorizontal)
%parametric2hough - Transform a line from parametric to hough space.
%   [rho, theta] = parametric2hough(m,c)  
%   [y = m*x + c] (horizontal) -> [rho = x*cos(theta) + y*sin(theta)]
%   [x = m*y + c] (vertical)   -> [rho = x*cos(theta) + y*sin(theta)]
%   See also hough2parametric
    if nargin < 3
        isHorizontal = true;
    end
    if isHorizontal
        theta =atan2(-c, c*m)+2*pi; %atan((-1)/m);
        rho = c * sin(theta);
    else
        theta = atan2(c*m, -c)+2*pi;%atan(-m);
        rho = c * cos(theta);
    end
    %theta = wrapTo2Pi(theta);
end



