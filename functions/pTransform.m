function p = pTransform( p, T )
    %UNTITLED4 Summary of this function goes here
    %   Detailed explanation goes here
    %T = transl2(pose(1), pose(2)) * rotz(pose(3));
    p = [p; ones(1, size(p, 2))];
    p = T * p;
    p = p(1:2,:);
end

