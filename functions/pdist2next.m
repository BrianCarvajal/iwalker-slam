function dist = pdist2next( p )
    n = size(p,2);
    dist = zeros(n, 1);   
    for i = 1: n - 1
        dist(i) = sqrt( (p(1,i)-p(1,i+1))^2 + (p(2,i)-p(2,i+1))^2 );
    end
    %dist(1:n-1) = sqrt( (p(1,1:n-1)-p(1,2:n)).^2 + (p(2,1:n-1)-p(2,n)).^2 );
end

