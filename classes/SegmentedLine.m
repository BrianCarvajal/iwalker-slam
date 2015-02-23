classdef SegmentedLine
    %SEGMENTEDLINE Segmented line representation class
    %
    %   This class represents a line composed by segments. It contains the
    %   parametric and the hough representation, the points that shapes the
    %   segment and other related information.
    
    properties
        m, c            % y = m*x + c if horizontal, x = m*y + c if vertical
        rho, theta      % y*sin(theta) = rho - x*cos(theta)
        orientation     % orientation: horizontal (1) or vertical (2)
        ep              % list of end points
        segs            % segments
    end
    
    methods
        
        function obj = SegmentedLine(segments)
            %SegmentedLine object constructor
            %
            %sl = SegmentedLine(S) creates a SegmentedLine object with the
            %collinear segments passed in S.
            if isempty(segments) || ~isa(segments, 'Segment') 
                error('SegmentedLine: bad constructor call');
            end
                
            orientation = segments(1).orientation;
                
            % all the points of the segments
            p = [segments.p];
            
            % line parameteres estimation
            switch orientation
                case 'horizontal'
                    [m, c] = estimateLine(p(1,:), p(2,:));
                    [rho, theta] = parametric2hough(m, c, true);
                    ns = length(segments);
                    ep = zeros(2, 2*ns);
                    i = 1;
                    for s = segments
                        ep(1,i) =   s.p(1,1);
                        ep(2,i) =   s.p(1,1) * m + c;
                        ep(1,i+1) = s.p(1,end);
                        ep(2,i+1) = s.p(1,end) * m + c;
                        i = i + 2;
                    end
                case 'vertical'
                    [m, c] = estimateLine(p(2,:), p(1,:));
                    [rho, theta] = parametric2hough(m, c, false);
                    ns = length(segments);
                    ep = zeros(2, 2*ns);
                    i = 1;
                    for s = segments
                        ep(1,i) =   s.p(2,1) * m + c;
                        ep(2,i) =   s.p(2,1);
                        ep(1,i+1) = s.p(2,end) * m + c;
                        ep(2,i+1) = s.p(2,end);
                        i = i + 2;
                    end
            end
            
            
            

            
%             MX = minmax(p(1,:));
%             MY = minmax(p(2,:));
%             if MX(2)-MX(1) > MY(2)-MY(1)
%                 ori = 1;
%                 a = [MX(1), m*MX(1) + c];
%                 b = [MX(2), m*MX(2) + c];
%             else
%                 ori = 2;
%                 a = [(MY(1) - c)/m, MY(1)];
%                 b = [(MY(2) - c)/m, MY(2)];
%             end
            
            % end points calculation
%             ns = length(segment);
%             obj.ep = zeros(2, 2*ns);
%             i = 1;
%             if ori == 1 % horizontal
%                 for s = segments
%                     ep(i,1) = s.p(1,1);
%                     ep(i,2) = m * s.p(1,2) + c;
%                     ep(i+1,1) = s.p(end, 1);
%                     ep(i+1,2) = m * s.p(end,2) + c;
%                     i = i+2;
%                 end
%             else % vertical
%                 for s = segments
%                     ep(i,1) = (s.p(1,1) - c)/m;
%                     ep(i,2) = s.p(1,2);
%                     ep(i+1,1) = (s.p(end,1) - c)/m;
%                     ep(i+1,2) = s.p(end,2);
%                     i = i+2;
%                 end
%             end
            
            obj.m = m;
            obj.c = c;
            obj.rho = rho;
            obj.theta = theta;
            obj.orientation = orientation;
            obj.ep = ep;
            obj.segs = segments;   
        end
        
        function c = collinearity(s, z)
                c = sqrt( (s.rho-z.rho)^2 + (s.theta-z.theta)^2);
        end
            
        function c = perpendicularity(s, z)
           %c = mod(abs(s.theta - z.theta), 90)/90;
           u = [s.ep(:,1) - s.ep(:,2)];
           v = [z.ep(:,1) - z.ep(:,2)];
           c = 1 - dot(u,v);
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
            for i = 1:2:length(s.ep)
               if p(c) >= s.ep(c,i)-m && p(c) <= s.ep(c,i+1)+m || ...
                  p(c) >= s.ep(c,i+1)-m && p(c) <= s.ep(c,i)+m
                    f = f+1;
                    break;
               end
            end
            if strcmp(z.orientation, 'horizontal')
               c = 1; 
            else
               c = 2;
            end
            for i = 1:2:length(z.ep)
               if p(c) >= z.ep(c,i)-m && p(c) <= z.ep(c,i+1)+m || ...
                  p(c) >= z.ep(c,i+1)-m && p(c) <= z.ep(c,i)+m
                    f = f+1;
                    break;
               end
            end
        end
        
        function plot(segments)
            for obj = segments
               X = [];
                Y = [];
                for i = 1:2:length(obj.ep)
                    X = [X obj.ep(1,i), obj.ep(1,i+1), NaN];
                    Y = [Y obj.ep(2,i), obj.ep(2,i+1), NaN];
                end
                line(X, Y, 'Color', 'r');

                scatter(obj.ep(1,:), obj.ep(2,:)); 
            end
            
%             for obj = segments
%                 
%                 
%                 
% %                 % Line estimated
% %                 if strcmp(obj.orientation, 'horizontal');
% %                     xx = [(obj.a(1) - 15) (obj.b(1) + 15)];
% %                     yy = obj.m*xx + obj.c;
% %                 else
% %                     yy = [(obj.a(2) - 15) (obj.b(2) + 15)];
% %                     xx = obj.m*yy + obj.c;
% %                 end
% %                 line(xx, yy, 'Color', 'c', 'LineStyle', '--');
% %                 % Segment estimated
% %                 line([obj.a(1) obj.b(1)], [obj.a(2) obj.b(2)], 'Color', 'g', 'LineWidth', 4);
% %                 % Naive segment: endpoints
% %                 line([obj.p(1,1) obj.p(1,end)], [obj.p(2,1) obj.p(2,end)], 'Color', 'r', 'LineWidth', 1);
% %                 % Hough
% %                 x = obj.rho * cosd(obj.theta);
% %                 y = obj.rho * sind(obj.theta);
% %                 line([0 x], [0 y], 'Color', 'b', 'LineStyle', '-.');
% %                 
% %                 % Points
% %                 plot(obj.p(1,:), obj.p(2,:), 'r*');
%             end 
        end
    
    end
    
end

