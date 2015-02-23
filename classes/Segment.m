classdef Segment
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        p               % points of the segment
        m, c            % y = m*x + c if horizontal, x = m*y + c if vertical
        rho, theta      % y*sin(theta) = rho - x*cos(theta)
        orientation             % orientation: horizontal (1) or vertical (2)
        a, b            % endpoints of the segment
        

    end
    
    properties 
        aOclusor  
        bOclusor
    end
    
    properties (Dependent = true)
        n               % number of points
        d               % distance from point a to b     
    end
    
    methods
        
        function obj = Segment(p)
            
            MX = [p(1,1) p(1,end)];%minmax(p(1,:));
            MY = [p(2,1) p(2,end)];%(minmax(p(2,:));
            if abs(MX(2)-MX(1)) > abs(MY(2)-MY(1)) 
                orientation = 'horizontal'; % horizontal
                [m, c] = estimateLine(p(1,:), p(2,:));
                [rho, theta] = parametric2hough(m, c, true);
                a = [MX(1), m*MX(1) + c];
                b = [MX(2), m*MX(2) + c];
            else
                orientation = 'vertical'; % vertical
                [m, c] = estimateLine(p(2,:), p(1,:));
                [rho, theta] = parametric2hough(m, c, false);
                
                a = [MY(1)*m + c, MY(1)];
                b = [MY(2)*m + c, MY(2)];
            end
            obj.a = a;
            obj.b = b;
            obj.aOclusor = false;
            obj.bOclusor = false;
            obj.orientation = orientation;
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
        
        function c = collinearity(s, z)
            dr = abs(s.rho-z.rho)/5;
            dt = s.perpendicularity(z);
            c = dr + dt;
            %c = sqrt( (s.rho-z.rho)^2 + (s.theta-z.theta)^2);
        end
        
        function b = isCollinear(s, z)
            b = false;
        end
        
        function c = perpendicularity(s, z)
           c = abs((angdiffd(mod(s.theta,180),mod(z.theta,180))))/90;
%            u = [s.a - s.b];
%            v = [z.a - z.b];
%            c = 1 - dot(u,v);
        end
        
        function [p, f] = interesection(s, z)
            A = [cosd(s.theta) sind(s.theta); cosd(z.theta) sind(z.theta)];
            b = [s.rho; z.rho];
            %p = linsolve(A,b);
            p = A\b;
            f = 1;
            
            m = 0.1;
            
            if strcmp(s.orientation, 'horizontal')
               c = 1; 
            else
               c = 2;
            end
           if p(c) >= s.a(c)-m && p(c) <= s.b(c)+m || ...
              p(c) >= s.b(c)-m && p(c) <= s.a(c)+m
                f = f+1;
           end
            if strcmp(z.orientation, 'horizontal')
               c = 1; 
            else
               c = 2;
            end
            if p(c) >= z.a(c)-m && p(c) <= z.b(c)+m || ...
               p(c) >= z.b(c)-m && p(c) <= z.a(c)+m
                f = f+1;
           end
        end
        
        function plot(segments)
            for obj = segments
                
                % Line estimated
                if strcmp(obj.orientation, 'horizontal');
                    xx = [(obj.a(1) - 15) (obj.b(1) + 15)];
                    yy = obj.m*xx + obj.c;
                else
                    yy = [(obj.a(2) - 15) (obj.b(2) + 15)];
                    xx = obj.m*yy + obj.c;
                end
                line(xx, yy, 'Color', 'c', 'LineStyle', '--');
                % Segment estimated
                line([obj.a(1) obj.b(1)], [obj.a(2) obj.b(2)], 'Color', 'g', 'LineWidth', 4);
                % Naive segment: endpoints
                line([obj.p(1,1) obj.p(1,end)], [obj.p(2,1) obj.p(2,end)], 'Color', 'r', 'LineWidth', 1);
                % Hough
                x = obj.rho * cosd(obj.theta);
                y = obj.rho * sind(obj.theta);
                line([0 x], [0 y], 'Color', 'b', 'LineStyle', '-.');
                
                % Points
                plot(obj.p(1,:), obj.p(2,:), 'r*');
            end 
        end
    end
    
end

