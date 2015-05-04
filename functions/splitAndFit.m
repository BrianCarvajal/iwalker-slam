function S = splitAndFit( p, threshold, minPoints, maxOutliers)
%splitAndMerge constructs segments from a set of consecutive points
%   [S] = splitAndMerge(P, TS, MO) returns a set of segments S. 
%
%   The threshold TH determines the max distance from a point A to the his
%   segment [Q, R]. If this distance is exceeded, the segment is splited in
%   segments [Q, A] and [A, R]

%%0 Initializations and parameters validation
    if threshold <= 0
        error('splitAndMerge::Threshold must be greater than zero')
    end 
    FL = []; 
     
    N = size(p, 2);
    if N < 2 
        S = [];
        return
    end
       
%%1 Initial: set s1 consists of N points. Put s1 in a list L
    
    L = [1; N]; % L = s1
      
%%2.1 Fit a segmetn Q1-Q2 to the next set si in L
    while ~isempty(L)
        s = L(:,1);
        L = L(:, 2:end);
        n = s(2) - s(1) + 1; % set size
        
%%2.2 If set's size is less than 3 we descart the set 
        if n < 3
           continue; 
        end
        q1 = p(:, s(1));
        q2 = p(:, s(2));
              
%%3 Detect point P with maximum distance dP to the line
        dp = zeros(1, n);
        for i = 1:n
            dp(i) = point2segment(p(:, s(1)+i-1), q1, q2);
        end
           
%%4 If max(dP) is less than a threshold, continue (go to 2)
        numOutliers = 0;
        do_split = true;
        [maxdP, indexMax] = max(dp);
        peak = indexMax;
        while numOutliers < maxOutliers
            if maxdP < threshold
                FL = [FL s];
                do_split = false;
                break;
            else
                dp(indexMax) = NaN;
                [maxdP, indexMax] = max(dp);
                numOutliers = numOutliers + 1;
            end
        end
%%5 Otherwise, split si at P into si1 and si2, replace si in L by si1 and si2, continue (go to 2)
        if do_split
            peak = s(1) + peak - 1;
            if peak == s(1) || peak == s(2)
                FL = [FL s];
            else
                s1 = [s(1); peak];
                s2 = [peak; s(2)];
                L = [s1 s2 L];
            end
        end
    end
    
%%6 No more splits. It's fitting time!

    % Preallocate Segments
    n = size(FL,2);
    S = [];
    si = 1;
    for i = 1:n
        if FL(2,i) - FL(1, i) >= minPoints
           S  = [S Segment(p(:, FL(1, i):FL(2,i)))]; 
        end
    end


 
%%6 When all sets (segments) in FL have been checked, merge collinear segments.
    

end

