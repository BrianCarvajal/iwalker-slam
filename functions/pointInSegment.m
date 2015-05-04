function [q, w] = pointInSegment(p, q1, q2)
    % returns q the closest point to p on the line segment from q1 to q2
    % w = -1 : before q1
    % w = 0  : betwen q1 and q2
    % w = 1  : after q2
    
    % vector from A to B
    AB = (q2-q1);
    % squared distance from A to B
    AB_squared = dot(AB,AB);
    if AB_squared == 0
        % A and B are the same point
        q = q1;
        w = 0;
    else
        % vector from A to p
        Ap = (p-q1);
        % from http://stackoverflow.com/questions/849211/
        % Consider the line extending the segment, parameterized as A + t (B - A)
        % We find projection of point p onto the line.
        % It falls where t = [(p-A) . (B-A)] / |B-A|^2
        t = dot(Ap,AB)/AB_squared;
       
        w = t;
        q = q1 + t * AB;

    end
end