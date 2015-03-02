classdef RadarAxes < hgsetget
    
    properties
        Parent
        hAxes
        radius

        %colors
        backColor
        borderColor
        axisColor
    end
    
    properties (Access = private)
%         updateScan
         gh         % graphic handles
    end
    
    methods
        function this = RadarAxes(varargin)
            % Set default property values
            this.Parent = [];
            this.radius = 6;
            this.backColor = [0 0 0];
            this.borderColor = [0.4 0.4 0.4];
            this.axisColor = [0.6 0.6 0.6];
            % Set user-supplied property values
            if nargin > 0
                set( this, varargin{:} );
            end
            if isempty(this.Parent)
                this.Parent = figure;
            end
            this.init();
        end
        
        
        function init(this)
            if (isempty(this.hAxes) || ~ishandle(this.hAxes))
                this.hAxes = handle(axes('Parent', this.Parent));
                this.hAxes.LooseInset = this.hAxes.TightInset;
                this.hAxes.ActivePositionProperty =  'OuterPosition';
            else
                delete(this.hAxes.Children);
            end
%             if (~isempty(this.hAxes) && ishandle(this.hAxes))
%                 delete(findall(this.hAxes));
%             end
%             this.hAxes = handle(axes('Parent', this.Parent));
%             this.hAxes.LooseInset = this.hAxes.TightInset;
%             this.hAxes.ActivePositionProperty =  'OuterPosition';
            
            r = ceil(this.radius);
            
            xlim([-r-0.1 r+0.1]); ylim([-r-0.1 r+0.1]);
            hold(this.hAxes, 'on');
            axis(this.hAxes, 'off');
            axis(this.hAxes, 'square');
            view(this.hAxes, -90,90);
            
            
            th = 0:pi/40:2*pi;
            x = r * cos(th);
            y = r * sin(th);
            patch('parent', this.hAxes, ...
                'XData', [x x(1)], ...
                'YData', [y y(1)], ...
                'FaceColor', this.backColor, ...
                'EdgeColor', this.borderColor, ...
                'LineWidth', 3, ...
                'HitTest', 'off');
            
            % draw axis radius
            for i = 1:r-1
                th = 0:pi/50:2*pi;
                x = i * cos(th);
                y = i * sin(th);
                line(x, y, ...
                    'LineStyle', '-.', ...
                    'LineWidth', 0.1, ...
                    'Color', this.axisColor, ...
                    'parent', this.hAxes);
            end
            
            % draw orientation mark
            this.gh.ring = hgtransform();
            set(this.gh.ring, 'Parent', this.hAxes);
            th = 0:pi/5:2*pi;
            x = 0.05 * cos(th) + r;
            y = 0.05 * sin(th);
            patch('parent', this.gh.ring, ...
                'XData', x, ...
                'YData', y, ...
                'FaceColor', this.axisColor, ...
                'EdgeColor', this.axisColor, ...
                'LineWidth', 3, ...
                'HitTest', 'off');
            
            % draw axis lines
            for th = 0: pi/4: 2*pi
                x = r * cos(th);
                y = r * sin(th);
                line([0 x],[0 y], ...
                    'LineStyle', '-.', ...
                    'LineWidth', 0.1, ...
                    'Color', this.axisColor, ...
                    'parent', this.hAxes);
            end
            
            
        end
        
        function erase(this, tag)
            if (~isempty(this.hAxes) && ishandle(this.hAxes))
                delete(findall(this.hAxes, 'Tag', tag));
            end
        end
        
        function drawPoints(this, tag, p, s, color, marker)
            if (isempty(this.hAxes) && ~ishandle(this.hAxes))
                this.init();
            end
            if isempty(p) || numel(p) == 0
               p = [NaN; NaN]; 
            end
            h = handle(findobj(this.hAxes, 'Tag', tag));
            if isempty(h)
               h = handle(scatter( p(1,:), p(2,:),s,color,marker));
               h.Tag = tag;
               h.Parent = this.hAxes;
            else
                h.XData = p(1,:);
                h.YData = p(2,:);
                h.CData = color;
                h.SizeData = s;
                h.marker = marker;
            end
        end
        
        function drawRays(this, tag, p, color, width, style)
            if (isempty(this.hAxes) && ~ishandle(this.hAxes))
                this.init();
            end
            if isempty(p) || numel(p) == 0
               p = [NaN; NaN]; 
            end
            X = repmat([0 0 NaN], 1, size(p,2));
            Y = repmat([0 0 NaN], 1, size(p,2));
            X(2:3:end) = p(1,1:end);
            Y(2:3:end) = p(2,1:end);
            h = findobj(this.hAxes, 'Tag', tag);
            if isempty(h)
                h = line(X, Y, 'Color', color, 'LineStyle', style, 'LineWidth', width);
                set(h, 'Tag', tag);
                set(h, 'Parent', this.hAxes);
            else
                set(h, 'XData', X, 'YData', Y, 'Color', color, 'LineStyle', style, 'LineWidth', width);
            end
        end
        
%         function update(obj)
% %             lid = obj.sim.lid;
% %             rob = obj.sim.rob;
% %             res = obj.sim.ext.output;
% %             ptr = obj.plotter;
% %             if  obj.updateScan
% %                 %obj.updateScan = false;
% %                 if ~isempty(res)
% %                     ptr.plotPoints(res.p(1,:), res.p(2,:), 'points.inRange', [0 1 1], 10, '.');
% %                     ptr.plotPoints(res.pOutRange(1,:), res.pOutRange(2,:), 'points.outRange', [1 0 1], 10, '.');
% %                     ptr.plotRays([0 0], res.p(1,:), res.p(2,:), 'rays.inRange', [0 1 1]./2, 0.1, '-');
% %                     ptr.plotRays([0 0], res.pOutRange(1,:), res.pOutRange(2,:), 'rays.outRange', [1 0 0]./2, 0.1, '-');
% %                     ptr.plotRays([0 0], res.pDeadZone(1,:), res.pDeadZone(2,:), 'rays.deadZone', [0.2 0.2 0.2]./2, 0.1, '-');
% %                 end
% %                 %p = lid.p(:, lid.range > 0 & lid.range < 6);
% %                 %obj.plotter.plotPoints(p(1,:), p(2,:), 'points', [1 0 0], 3, '.');
% %                 %obj.plotter.plotScanArea(p(1,:), p(2,:), 'scan', [0 0.2 0.8], 0.5);
% %             end
% %             set(obj.gh.ring, 'Matrix', trotz (rob.x(3)-pi/2));
%         end
        
%         function newScan(obj)
%             obj.updateScan = true;
%         end
        
        
        
    end
    
end

