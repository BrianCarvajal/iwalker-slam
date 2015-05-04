classdef SignalScopeAxes < hgsetget
    
    properties
        Parent
        hAxes
        maxTime
        timeWindow
    end
    
    properties (SetAccess = private)
        minTime
    end
    
    
    methods
        function this = SignalScopeAxes(varargin)
            % Set default property values
            this.Parent = [];
            % Set user-supplied property values
            if nargin > 0
                set( this, varargin{:} );
            end
            
            if ~isempty(this.hAxes)
                this.hAxes = handle(this.hAxes);
                this.Parent = this.hAxes.Parent;
            end
            
            if isempty(this.Parent)
                this.Parent = figure;
                set(this.Parent, 'renderer', 'opengl');
                set(this.Parent,'DefaultLineLineSmoothing','on');
                set(this.Parent,'DefaultPatchLineSmoothing','on');
                %whitebg(this.Parent,[0.2 0.2 0.2]);
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
            axis(this.hAxes, 'xy');
            axis(this.hAxes, 'on');
            hold(this.hAxes, 'on');
            
            this.hAxes.Color = [0.2 0.2 0.2];
            this.hAxes.XColor = [1 1 1]*0.5;
            this.hAxes.YColor = [1 1 1]*0.5;
            
            this.maxTime = 10;
            this.timeWindow = 10;
            this.updateTimeAxis(this.maxTime);
            
            this.hAxes.YGrid = 'on';
            this.hAxes.XGrid = 'on';
            this.hAxes.XTickLabelMode = 'manual';
            
            %this.hAxes.YLimMode = 'manual';
            
        end
        
        function updateTimeAxis(this, newMaxTime)
            
            this.maxTime = max(this.maxTime, newMaxTime);
            this.minTime = max(0, this.maxTime - this.timeWindow);
            ts = (this.maxTime - this.minTime) / 10;
            t = this.minTime: ts: this.maxTime;
            this.hAxes.XTick = floor(t);
            this.hAxes.XTickLabel = floor(t);
            this.hAxes.XLim = [t(1) t(end)];
        end
        
        
        function erase(this, tag)
            %ERASE - Removes all objects with a given tag
            %   ERASE(tag)
            if (~isempty(this.hAxes) && ishandle(this.hAxes))
                delete(findall(this.hAxes, 'Tag', tag));
            end
        end
        
        function eraseText(this)
            if (isempty(this.hAxes) && ~ishandle(this.hAxes))
                return;
            end
            delete(handle(findall(this.hAxes, 'Type', 'text')));
        end
        
        function writeText(this, tag, p, str)
            if (isempty(this.hAxes) && ~ishandle(this.hAxes))
                this.init();
            end
            
            h = handle(findobj(this.hAxes, 'Tag', tag));
            if isempty(h)
                text('Position', p, ...
                    'String', str, ...
                    'Parent', this.hAxes, ...
                    'Tag', tag);
            else
                h.Position = p;
                h.String = str;
                %                 set(h, ...
                %                     'Position', p, ...
                %                     'String', str);
            end
        end
        
        %         function addSignal(this, tag, color)
        %
        %         end
        %
        function addScalarSignal(this, tag, value, timestamp, color)
            if (isempty(this.hAxes) && ~ishandle(this.hAxes))
                this.init();
            end
            
            this.updateTimeAxis(timestamp);
            
            lineWidth = 1;
            style = '-';
            h = handle(findobj(this.hAxes, 'Tag', tag));
            if isempty(h)
                patch([NaN; timestamp],[NaN; value],0, ...
                    'LineStyle', '-', ...
                    'FaceColor', 'none', ...
                    'EdgeColor', color, ...
                    'LineWidth', lineWidth, ...
                    'LineStyle', style, ...
                    'HitTest', 'off', ...
                    'Tag', tag, ...
                    'Parent', this.hAxes);
            else
                tvalid = find(h.XData >= this.minTime);
                h.XData = [h.XData(tvalid); timestamp];
                h.YData = [h.YData(tvalid); value];
                h.EdgeColor= color;
                h.LineWidth = lineWidth;
                h.LineStyle = style;
            end
        end
        
        function addGausianSignal(this, tag, value, var,  timestamp, color, alpha)
            if (isempty(this.hAxes) && ~ishandle(this.hAxes))
                this.init();
            end
            
            this.updateTimeAxis(timestamp);
            
            h = handle(findobj(this.hAxes, 'Tag', tag));
            if isempty(h)
                patch([timestamp timestamp timestamp],[value-var value+var value-var],color, ...
                    'LineStyle', '-', ...
                    'FaceColor', color, ...
                    'FaceAlpha', alpha, ...
                    'EdgeColor', 'none', ...
                    'HitTest', 'off', ...
                    'Tag', tag, ...
                    'Parent', this.hAxes);
            else
                n = floor(length(h.XData)/2);
                X = [h.XData(1:n); timestamp; timestamp; h.XData(n+1:end-1)];
                Y = [h.YData(1:n); value-var; value+var; h.YData(n+1:end-1)];
                tvalid = find(X >= this.minTime);
                X = X(tvalid);
                Y = Y(tvalid);
                
                h.XData = [X; X(1)];
                h.YData = [Y; Y(1)];
                h.FaceAlpha = alpha;
            end
        end
        
        
        
        
    end
    
end

