classdef SegmentedLine
    %SEGMENTEDLINE Segmented line representation class
    %
    %   This class represents a line composed by segments. It contains the
    %   parametric and the hough representation, the points that shapes the
    %   segment and other related information.
    
    properties
        m, c            % y = m*x + c
        rho, theta      % y*sin(theta) = rho - x*cos(theta)
        ori             % orientation: horizontal (1) or vertical (2)
        ep              % list of end points
        segs            % segments
    end
    
    methods
        
        function obj = SegmentedLine(segments)
            %SegmentedLine object constructor
            %
            %sl = SegmentedLine(S) creates a SegmentedLine object with the
            %collinear segments passed in S.
            if ~isa(segments, 'Segment') 
                error('SegmentedLine: bad constructor call');
            else
                
            % all the points of the segments
            p = [segments.p];
            
            % line parameteres estimation
            [m,c] = estimateLine(p(1,:), p(2,:));
            [rho, theta] = parametric2hough(m, c);
            
            MX = minmax(p(1,:));
            MY = minmax(p(2,:));
            if MX(2)-MX(1) > MY(2)-MY(1)
                ori = 1;
                a = [MX(1), m*MX(1) + c];
                b = [MX(2), m*MX(2) + c];
            else
                ori = 2;
                a = [(MY(1) - c)/m, MY(1)];
                b = [(MY(2) - c)/m, MY(2)];
            end
            
            % end points calculation
            ns = length(segment);
            obj.ep = zeros(2, 2*ns);
            i = 1;
            if ori == 1 % horizontal
                for s = segments
                    ep(i,1) = s.p(1,1);
                    ep(i,2) = m * s.p(1,2) + c;
                    ep(i+1,1) = s.p(end, 1);
                    ep(i+1,2) = m * s.p(end,2) + c;
                    i = i+2;
                end
            else % vertical
                for s = segments
                    ep(i,1) = (s.p(1,1) - c)/m;
                    ep(i,2) = s.p(1,2);
                    ep(i+1,1) = (s.p(end,1) - c)/m;
                    ep(i+1,2) = s.p(end,2);
                    i = i+2;
                end
            end
            
            obj.m = m;
            obj.c = c;
            obj.rho = rho;
            obj.theta = theta;
            obj.ori = ori;
            obj.segs = segments;   
        end
    
    end
    
end

