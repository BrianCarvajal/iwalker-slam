function side = lineSide( p, q1, q2 )
    side = sign((q2(1)-q1(1))*(p(2)-q1(2)) - (q2(2)-q1(2))*(p(1)-q1(1)));
end

