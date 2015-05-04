%CLUSTERIZE Clusterize the given points
%   C = CLUSTERIZE(p, r, a, validRange, maxDist)
%       p:              cartesian points
%       r:              ranges of the points, in m
%       a:              angles of the points, in degrees
%       validRange:     [min, max] outside this range, a point is not valid
%       maxDist:        distance to start a new cluster
%       maxOclAngle:    max angle to consider a breakpoing as an oclusor
%   C: cell array of struct
%       p:              cartesian points of the cluster             
%       firstOcl:       true if the first point is an oclusor
%       lastOcl:        true if the last point is an oclusor
%       valid:          true if all the points are in validRange

function cp = clusterize( p, r, a, validRange, maxDist, maxOclAngle)
    if isempty(p)
        cp = {};
        return;
    end
    % Find breakpoints in sequential order. 
    % Compute all the distances from p(i) to p(i+1)
    dist = pdist2next(p);
    n = size(p, 2);

    cp = repmat(struct('firstOcl', false, ...
                       'lastOcl', false, ...
                       'p', [], ...
                       'valid', false), 1, n );
    
    ci = 1; % current cluster index
    % intialize the first cluster
    first = 1; 
    cp(ci).firstOcl = false;
    outOfRange = r(1) < validRange(1) | r(1) > validRange(2);
    last = -1;
    newCluster = false;
    for i = 2: n-1   
        if newCluster
           newCluster = false;
           first = i;
           last = -1;
           
           % if the range of the current point is near than the last one
           % and the angle betwen them is close
           % we mark the point as an oclusor (posible feature)
           cp(ci).firstOcl = r(i-1) > r(i) && abs(angdiffd(a(i-1),a(i))) < maxOclAngle;
           outOfRange = r(i) < validRange(1) | r(i) > validRange(2);
        else
            
            outOfRange = outOfRange | r(i) < validRange(1) | r(i) > validRange(2);
            if dist(i) > maxDist
                % we close the current cluster
                last = i;
                % if the range of the current point is near than the next one
                % and the angle betwen them is close
                % we mark the point as an oclusor (posible feature)                
                cp(ci).lastOcl = r(i) < r(i+1) && abs(angdiffd(a(i),a(i+1))) < maxOclAngle;
                cp(ci).p = p(:,first:last);
                cp(ci).valid = ~outOfRange;
                %cp(ci) = c;
                ci = ci + 1;
                % we prepare for the next cluster
                newCluster = true;
            end
        end
         
    end
      
    if last == -1
        % if the last cluster is not closed, we have to close it
        last = n;
        cp(ci).lastOcl = false;
        cp(ci).valid = ~outOfRange;
        cp(ci).p = p(:,first:last);
        %cp(ci) = c;
    end
    cp = cp(1:ci);
end

