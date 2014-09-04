classdef QuadTree < handle
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        x
        y
        dim
        countPoints
        maxPoints
        points
        data
        children
    end
    
    
    
    properties (Dependent = true)
        x_min
        x_max
        y_min
        y_max
    end
    
    methods
        
        function obj = QuadTree(x, y, dim, maxPoints)
            obj.x = x;
            obj.y = y;
            obj.dim = dim;
            obj.maxPoints = maxPoints;
            obj.countPoints = 0;
            obj.points = zeros(floor(2), floor(maxPoints+1));
            obj.data = cell(floor(1), floor(maxPoints+1));
            obj.children = [];
        end
        
        
        function x_min = get.x_min(obj)
            x_min = obj.x - obj.dim/2;
        end
        
        function x_max = get.x_max(obj)
            x_max = obj.x + obj.dim/2;
        end
        
        function y_min = get.y_min(obj)
            y_min = obj.y - obj.dim/2;
        end
        
        function y_max = get.y_max(obj)
            y_max = obj.y + obj.dim/2;
        end
        
        function b = isLeaf(obj)
            b = isempty(obj.children);
        end
        
        function addPoint(obj, p, data)
            if nargin < 3
                data = [];
            end
            
            obj.countPoints = obj.countPoints + 1;
            
            if obj.isLeaf()
                obj.points(:,obj.countPoints) = p;
                obj.data{obj.countPoints} = data;
                if obj.countPoints > obj.maxPoints
                    obj.split();
                end
            else
                i = obj.getIndex(p);
                obj.children(i).addPoint(p, data);
            end
        end
        
        function index = getIndex(obj, p)
            if p(1) > obj.x
                if p(2) > obj.y
                    index = 2;
                else
                    index = 1;
                end
            else
                if p(2) > obj.y
                    index = 3;
                else
                    index = 4;
                end
            end
        end
        
        function split(obj)
            offset = obj.dim/4;
            childSize = obj.dim/2;
            obj.children = [QuadTree(obj.x + offset, obj.y - offset, childSize, obj.maxPoints), ...
                QuadTree(obj.x + offset, obj.y + offset, childSize, obj.maxPoints), ...
                QuadTree(obj.x - offset, obj.y + offset, childSize, obj.maxPoints), ...
                QuadTree(obj.x - offset, obj.y - offset, childSize, obj.maxPoints)];
            
            for i = 1:obj.countPoints
                p = obj.points(:,i);
                d = obj.data(i);
                ind = obj.getIndex(obj.points(:,i));
                obj.children(ind).addPoint(p, d);
            end
            
            obj.points = [];
            obj.data = [];
        end
        
        function plot(obj)
            X = [obj.x_min, obj.x_min, obj.x_max, obj.x_max, obj.x_min];
            Y = [obj.y_min, obj.y_max, obj.y_max, obj.y_min, obj.y_min];
            
            edgeColor = 'r';
            
            if obj.countPoints == 0
                faceColor = 'g';
            else
                faceColor = 'b';
            end
            %patch(X, Y, faceColor, 'EdgeColor', edgeColor, 'FaceAlpha', 0.1);
            
            line(X, Y);
            hold on;
            
            n = obj.countPoints;
            if isLeaf(obj)
                scatter(obj.points(1,1:n), obj.points(2,1:n), 5);
                patch(X, Y, faceColor, 'EdgeColor', edgeColor, 'FaceAlpha', 0.5);
            else
                for c = obj.children
                    c.plot();
                end
            end
            
        end
    end
    
end

