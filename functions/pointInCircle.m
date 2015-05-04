function b = pointInCircle( p, c, r)
    d = sqrt((p(1)-c(1))^2 + (p(2)-c(2))^2);
    b = d < r;
end

