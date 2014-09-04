function dist = point2segment( p, q1, q2 )
    %point2segment Distance from point to segment
    %   D = point2segment(P,Q1,Q2) is the distance D from point P to
    %   segment Q1-Q2
    dist = abs(det([q2-q1,p-q1]))/norm(q2-q1);    
end

