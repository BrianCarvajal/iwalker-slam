function [ X, Y ] = rasterize_line( a, b, c, d )
    if nargin == 4
            x1 = a;
            y1 = b;
            x2 = c;
            y2 = d;
    elseif nargin == 2
            x1 = a(1);
            y1 = a(2);
            x2 = b(1);
            y2 = b(2);
        else
            error('bad input');
    end
    P = [];
    dx = abs(x2 - x1);
    dy = abs(y2 - y1);
    if x1 < x2
        sx = 1;
    else
        sx = -1;
    end
    if y1 < y2
        sy = 1;
    else
        sy = -1;
    end
    err = dx - dy;
    
    while x1 ~= x2 || y1 ~= y2
        P = [P [x1; y1]];
        e2 = 2*err;
        if e2 > -dy
           err = err - dy;
           x1 = x1 + sx;
        end
        if e2 < dx
           err = err + dx;
           y1 = y1 + sy;
        end
    end
    P = [P [x2; y2]];
    
    if nargout < 2
        X = P;
    else
        X = P(1, :);
        Y = P(2, :);
    end
end

