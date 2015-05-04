function [ p, q ] = segmentCircleIntersect(s, c, r )
    
    [x,y] = linecirc(s.m, s.c, c(1), c(2), r);

    if isnan(x(1)) || isnan(x(2))
        p = [NaN NaN];
        q = [NaN NaN];
        return
    end

    if s.isVertical
       i = 1;
       p = [-y(1) x(1)];
       q = [-y(2) x(2)];
    else
       i = 2;
       p = [x(1) y(1)];
       q = [x(2) y(2)];
    end
    
    if pointInCircle(s.a, c, r)
       if  s.a(i) < s.b(i)
           if p(i) < q(i)
               p = s.a;
           else
               q = s.a;
           end
       else
           if p(i) < q(i)
               q = s.a;
           else
               p = s.a;
           end
       end 
    end
    

    if pointInCircle(s.b, c, r)
       if  s.b(i) < s.a(i)
           if p(i) < q(i)
               p = s.b;
           else
               q = s.b;
           end
       else
           if p(i) < q(i)
               q = s.b;
           else
               p = s.b;
           end
       end 
    end
end

