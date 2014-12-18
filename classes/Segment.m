classdef Segment
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        p               % points of the segment
        m, c            % y = m*x + c if horizontal, x = m*y + c if vertical
        rho, theta      % y*sin(theta) = rho - x*cos(theta)
        ori             % orientation: horizontal (1) or vertical (2)
        a, b            % endpoints of the segment
    end
    
    properties (Dependent = true)
        n               % number of points
        d               % distance from point a to b     
    end
    
    methods
        
        function obj = Segment(p)
            
            MX = minmax(p(1,:));
            MY = minmax(p(2,:));
            if MX(2)-MX(1) > MY(2)-MY(1) 
                ori = 1; % horizontal
                [m, c] = estimateLine(p(1,:), p(2,:));
                [rho, theta] = parametric2hough(m, c);
                a = [MX(1), m*MX(1) + c];
                b = [MX(2), m*MX(2) + c];
            else
                ori = 2; % vertical
                [m, c] = estimateLine(p(2,:), p(1,:));
                [rho, theta] = parametric2hough(m, c, false);
                
                a = [MY(1)*m + c, MY(1)];
                b = [MY(2)*m + c, MY(2)];
            end
            obj.a = a;
            obj.b = b;
            obj.ori = ori;
            obj.p = p;
            obj.m = m;
            obj.c = c;
            obj.rho = rho;
            obj.theta = theta;
        end
        
        function n = get.n(obj)
           n = size(obj.p, 2); 
        end
        
        function d = get.d(obj)
           d = sqrt(((obj.a(1)-obj.b(1))^2) + ((obj.a(2)-obj.b(2))^2));
        end
        
        function plot(segments)
            for obj = segments
                % Line estimated
                if obj.ori == 1
                    xx = [(obj.a(1) - 15) (obj.b(1) + 15)];
                    yy = obj.m*xx + obj.c;
                else
                    yy = [(obj.a(2) - 15) (obj.b(2) + 15)];
                    xx = obj.m*yy + obj.c;
                end
                line(xx, yy);
                % Segment estimated
                line([obj.a(1) obj.b(1)], [obj.a(2) obj.b(2)], 'Color', 'g', 'LineWidth', 4);
                % Naive segment: endpoints
                line([obj.p(1,1) obj.p(1,end)], [obj.p(2,1) obj.p(2,end)], 'Color', 'r', 'LineWidth', 1);
                % Hough
                x = obj.rho * cos(obj.theta);
                y = obj.rho * sin(obj.theta);
                line([0 x], [0 y], 'Color', 'c');
            end 
        end
    end
    
end

