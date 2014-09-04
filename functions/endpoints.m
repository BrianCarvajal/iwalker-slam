function EP = endpoints( p, maxDist, maxRel )
    if isempty(p)
        EP = [];
        return;
    end
    dist = pdist2next(p);   
    n = size(p, 2);
    EP = zeros(n);
    EP(1) = 1;
    j = 2;
    for i = 2 : n - 1
        if dist(i) > maxDist
            EP(j) = i;
            EP(j+1) = i+1;
            j = j+2;
%         else
%             if dist(i-1) < dist(i)
%                 rel = dist(i-1) / dist(i);
%             else
%                 rel = dist(i) / dist(i-1);
%             end
%             if rel < maxRel
%                 EP(j) = i;
%                 EP(j+1) = i+1;
%                 j = j+2;
%             end
        end
    end
    EP(j) = n;
    EP =  reshape(EP(1:j),2,j/2);
end

