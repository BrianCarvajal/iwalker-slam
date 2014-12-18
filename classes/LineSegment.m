classdef LineSegment < handle
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        X, Y            % points of the segment
        m, c            % y = m*x + c
        rho, theta      % y*sin(theta) = rho - x*cos(theta)
        a, b            % endpoints of the segment       
    end
    
    properties (Dependent = true)
        n               % number of points
        d               % distance from point a to b     
    end
    
    methods
        function obj = LineSegment(X, Y)
            [m,c] = estimateLine(X, Y);
            [rho, theta] = parametric2hough(m, c);
            
            MX = minmax(X);
            MY = minmax(Y);
            
            % We use the coordinate in the axis with major disparsity for
            % calculate the other one.
            if MX(2)-MX(1) > MY(2)-MY(1)
                a = [MX(1), m*MX(1) + c];
                b = [MX(2), m*MX(2) + c];
            else
                a = [(MY(1) - c)/m, MY(1)];
                b = [(MY(2) - c)/m, MY(2)];
            end
            
            obj.X = X;
            obj.Y = Y;
            obj.m = m;
            obj.c = c;
            obj.rho = rho;
            obj.theta = theta;
            obj.a = a;
            obj.b = b;
        end
        
        function n = get.n(obj)
           n = size(obj.X,2); 
        end
        
        function d = get.d(obj)
           d = sqrt(((obj.a(1)-obj.b(1))^2) + ((obj.a(2)-obj.b(2))^2));
        end
        
        function p = intersect(s1, s2)
           p(1) = (s2.c - s1.c)/(s1.m - s2.m);
           p(2) = s1.m * p(1) + s1.c;
        end
        
        function e = compare(s1, s2)
           e = sqrt((s1.rho - s2.rho)^2 + (s1.theta - s2.theta)^2);
        end
        
        function h = plot(obj)
            %points 
            scatter(obj.X, obj.Y, 5, 'r+');
            hold on;
            % Line estimated
            xx = [(obj.a(1) - 15) (obj.b(1) + 15)];
            yy = obj.m*xx + obj.c;
            line(xx, yy);
            
            % Segment estimated
            line([obj.a(1) obj.b(1)], [obj.a(2) obj.b(2)], 'Color', 'g', 'LineWidth', 4);
            
            % Naive segment: endpoints
            line([obj.X(1) obj.X(end)], [obj.Y(1) obj.Y(end)], 'Color', 'r', 'LineWidth', 1)
            
            % Hough parameters
            x = obj.rho * cos(obj.theta);
            y = obj.rho * sin(obj.theta);
            line([0 x], [0 y], 'Color', 'c');
            hold off;
            axis equal;
            grid on;
        end
    end
    
end

