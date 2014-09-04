function [FL, V] = splitAndMerge( p, threshold)
%splitAndMerge construct segments in a set of consecutive points
%   [FL, V] = splitAndMerge(P, TS) return a pair vector FL and a vector V. 
%   Each pair of the vector FL contains the first and the last index of the 
%   points of each segment. Each element in V is an index of vertices in P.
%   One point is a vertice if belongs to two consecutive segments.
%   The threshold TH determines the max distance from a point A to the his
%   segment [Q, R]. If this distance is exceeded, the segment is splited in
%   segments [Q, A] and [A, R]



%%0 Initializations and parameters validation
    if nargout == 2
       V = []; 
    end
    N = size(p, 2);
    FL = [];
    if N < 2 
        return
    end
    
%%1 Initial: set s1 consists of N points. Put s1 in a list L
    
    L = [1; N]; % L = s1
      
%%2 Fit a segmetn Q1-Q2 to the next set si in L
    while ~isempty(L)
        s = L(:,1);
        L = L(:, 2:end);
        n = s(2) - s(1) + 1; % set size
        
%%2.5 If set's size is less than 3 we descart the set 
%         if n < 3
%            continue; 
%         end
        q1 = p(:, s(1));
        q2 = p(:, s(2));
%%3 Detect point P with maximum distance dP to the line
        dp = zeros(1, n);
        for i = 1:n
            dp(i) = point2segment(p(:, s(1)+i-1), q1, q2);
        end
           
%%4 If dP is less than a threshold, continue (go to 2)
        [maxdP, peak] = max(dp);
        if maxdP < threshold
           FL = [FL s];
    
%%5 Otherwise, split si at P into si1 and si2, replace si in L by si1 and si2, continue (go to 2)
        else
            peak = s(1) + peak - 1;
            s1 = [s(1); peak];
            s2 = [peak; s(2)];
            L = [s1 s2 L];
            if nargout == 2
               V = [V peak]; 
            end
        end
    end
    
%%6 When all sets (segments) in FL have been checked,merge collinear segments.
    

end

