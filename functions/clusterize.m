%Clusterize Summary of this function goes here
%   Detailed explanation goes here
function cp = clusterize( p, r, a, validRange, maxDist)
    if isempty(p)
        cp = {};
        return;
    end
    dist = pdist2next(p);
    n = size(p, 2);

    ci = 1; % current cluster index
    c.start = 1; % intialize the first cluster
    c.startOclusor = false;
    c.outOfRange = r(1) < validRange(1) | r(1) > validRange(2);
    c.end = -1;
    newCluster = false;
    for i = 2: n-1   
        if newCluster
           newCluster = false;
           c.start = i;
           c.end = -1;
           c.startOclusor = r(i-1) > r(i) && abs(angdiffd(a(i-1),a(i))) < 5;
           c.outOfRange = r(i) < validRange(1) | r(i) > validRange(2);
        else
            if dist(i) > maxDist 
                % we close the current cluster
                c.end = i;
                % if the range of the current point is near than the next one
                % and the angle betwen them is close
                % we mark the point as an oclusor (posible landmark)
                c.outOfRange = c.outOfRange | r(i) < validRange(1) | r(i) > validRange(2);
                c.endOclusor = r(i) < r(i+1) && abs(angdiffd(a(i),a(i+1))) < 5; 
                cp{ci} = c;
                ci = ci + 1;
                % we prepare for the next cluster
                newCluster = true;
            end
        end
         
    end
    
    
    if c.end == -1
        % if the last cluster is not closed, we have to close it
        c.end = n;
        c.endOclusor = false;
        cp{ci} = c;
    end
    
%     dist = pdist2next(p);   
%     n = size(p, 2);
%     
%     j = 1;
%     last = 1;
%     cp = {};
%     for i = 2 : n - 1
%         if dist(i) > maxDist
%             cp{j} = last:i;
%             last = i+1;
%             j = j+1;
%         end
%     end
%     cp{j} = p(:,last:end);
%     
%     % If the first and the last points are near, we fuse the first
%     % and the last cluster
%     if pdist2(p(:,1)', p(:,end)') < maxDist
%         cp{1} = [cp{1} cp{end}];
%         cp{end} = [];
%     end

end

