%pdist2next - Distance of each point to his next point
%
%   This function computes the Euclidean distance betwen each point to his
%   next point in a 2 x n matrix P
%  
%   D = pdist2next(P)
function dist = pdist2next( p )  
    dist = [sqrt( sum((p(:,1:end-1)-p(:,2:end)).^2)) 0];
%     n = size(p,2);
%     dist = zeros(n, 1);  
%     for i = 1: n - 1
%         dist(i) = sqrt( (p(1,i)-p(1,i+1))^2 + (p(2,i)-p(2,i+1))^2 );
%     end
end

