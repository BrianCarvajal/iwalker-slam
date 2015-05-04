classdef MapMaker < hgsetget

    properties
        S
        fmap
        xlims
        ylims
        
        rMagnet
    end
    
    properties (Access = private)
        currentKey
        fig
        mapAxes
        hAxes

        hLine
        
        Points
        cp
        isCpNew
        xmouse
        ymouse
    end
    
    methods
        function this = MapMaker(varargin)
            % default properties values
            this.xlims = [-5 5];
            this.ylims = [-5 5];
            this.currentKey = '';
            this.S = [];
            this.fmap = FeatureMap();
            this.rMagnet = 0.25;
            this.cp = [];
            this.isCpNew = true;
            % user properties values
            set(this, varargin{:});
            
            
            this.edit();
        end
        
        function edit(this)
            
            
            
            
            f = figure('MenuBar', 'none','NumberTitle','off', 'Name', 'Segment Map Editor');
            whitebg(f,[0.2 0.2 0.2]);
            set(f, 'renderer', 'opengl');
            set(f,'DefaultLineLineSmoothing','on');
            set(f,'DefaultPatchLineSmoothing','on');
            set(f, 'WindowButtonDownFcn', @this.click);
            set(f, 'WindowButtonMotionFcn', @this.motion);
            set(f, 'WindowKeyPressFcn', @this.keyPress);
            set(f, 'WindowKeyReleaseFcn', @this.keyRelease);
            set(f, 'WindowScrollWheelFcn', @this.mouseScroll);
            set(f, 'CloseRequestFcn', @this.close);
            
            this.mapAxes = MapAxes('Parent', f);
            this.hAxes = this.mapAxes.hAxes;
            this.hAxes.XLim = this.xlims;
            this.hAxes.YLim = this.ylims;
            grid(this.hAxes, 'on');
            
            this.hLine = handle(patch(...
                     NaN, NaN, 0, ...
                    'LineStyle', '-', ...
                    'FaceColor', 'none', ...
                    'EdgeColor', [1 0 0], ...
                    'LineWidth', 1, ...
                    'LineStyle', '-', ...
                    'HitTest', 'off', ...
                    'Parent', this.hAxes));
                
            this.fig = f;
            
            for c = this.fmap.corners
                p = this.newPoint(c.x, c.y);
                p.c = c;
            end
            
            for s = this.fmap.segments
               p = this.getNearestPoint(s.sp(1), s.sp(2), 0.0000001);
               if isempty(p)
                   p = this.newPoint(s.sp(1), s.sp(2));
               end
               p.S = [p.S s];
               p = this.getNearestPoint(s.ep(1), s.ep(2), 0.0000001);
               if isempty(p)
                   p = this.newPoint(s.ep(1), s.ep(2));
               end
               p.S = [p.S s];
            end
            
            this.mapAxes.drawCornerFeatures('corners', this.fmap.corners, [0 0.5 0.5]);
            this.mapAxes.drawSegmentFeature('segments', this.fmap.segments, [0 0.5 0.5]);

        end
    end
    
    methods (Access = private)
        
        function constructMap(this)
           this.fmap = FeatureMap();
           
        end
        
        function close(this, ~, ~)
            delete(this.fig);
            delete(this.mapAxes);
            for p = this.Points
               delete(p); 
            end
            this.Points = [];
        end
            
        function [x, y] = getMousePoint(this)
            h = this.hAxes;
            p = get(h, 'currentpoint');
            x = round(p(1,1)*1000)/1000;
            y = round(p(1,2)*1000)/1000;
            if strcmp(get(gcf,'currentModifier'), 'shift')
                x = interp1(h.XTick, h.XTick, x, 'nearest');
                y = interp1(h.YTick, h.YTick, y, 'nearest');
            end
        end
        
        function p = getNearestPoint(this, x, y, rad)
            p = [];
            if ~isempty(this.Points)
                xx = [this.Points.x];
                yy = [this.Points.y];
                i = rangesearch([xx' yy'], [x y], rad);
                i = i{1};
                if ~isempty(i)
                    p = this.Points(i(1));
                end
            end
        end
        
        function p = newPoint(this, x, y) 
            p = Point(x,y);
            p.S = [];
            th = linspace(0, 2*pi, 10); 
            xc = cos(th)*0.1 + x;
            yc = sin(th)*0.1 + y;
            p.gh = handle(patch(xc, yc, [0 1 0], 'HitTest', 'on', 'EdgeColor', 'none')); 
            this.Points = [this.Points p];
        end
        
        function motion(this, ~, ~)
            [x, y] = this.getMousePoint();
            p = this.getNearestPoint(x, y, this.rMagnet);
            
            if isempty(p)
                %% Plot all points as unselected
                for pp = this.Points
                   pp.gh.FaceColor = [0 0.5 0.5];
                end
            else
                %% Highlight selected point
                x = p.x;
                y = p.y;
                if length(p.S) > 1
                    % Point connected to 2 segments: not clickable
                    p.gh.FaceColor = [1 0 0];
                else
                    % Point connected to <2 segments: clickable
                    p.gh.FaceColor = [0 1 0];
                end
            end
            
 
            if isempty(this.cp)
                this.hLine.XData = NaN;
                this.hLine.YData = NaN;
            else
                %% Plot current segment
                this.hLine.XData = [this.cp.x x];
                this.hLine.YData = [this.cp.y y];
            end

            %% Show current point coordinates
            txt = ['(' num2str(x,'%.2f') ', ' num2str(y,'%.2f') ')'];
            this.mapAxes.writeText('mouse', [x y], txt);
            
            drawnow;
        end
        
        function click(this, src, ~)
            [x, y] = this.getMousePoint();
            if isnan(x) || isnan(y)
               return; 
            end
            p = this.getNearestPoint(x, y, this.rMagnet);

            
            if strcmp(get(src, 'SelectionType'), 'alt')
                if ~isempty(this.cp)
                    %% Delete current point and current segment
                    delete(this.cp.gh);
                    delete(this.cp);
                    this.Points = this.Points(isvalid(this.Points));
                    this.cp = [];
                    this.hLine.XData = NaN;
                    this.hLine.YData = NaN;
                
                elseif ~isempty(p)
                    %% Delete selected point and related segments
                    % Delete segments related
                    for s = p.S
                        this.fmap.deleteFeature(s);
                    end
                    % Delete corner related
                    if ~isempty(p.c)
                        this.fmap.deleteFeature(p.c);
                    end
                    %this.fmap.deleteFeature(p.S)
                    %delete(p.S);
                    %this.S = this.S(isvalid(this.S));
                    % Check map consistency
                    for pp = this.Points
                       if ~isempty(pp.S)
                           % delete invalid references
                           pp.S = pp.S(isvalid(pp.S));
                       end
                       if ~isempty(pp.c)
                          if isvalid(pp.c)
                              if isempty(pp.S) || length(pp.S) == 1
                                  this.fmap.deleteFeature(pp.c);
                                  pp.c = []; 
                              end 
                          end
                       end
                       if isempty(pp.S)
                          delete(pp.gh);
                          delete(pp);                         
                       end
                      % delete invalid references
                      this.Points = this.Points(isvalid(this.Points));
                    end
                    this.mapAxes.drawCornerFeatures('corners', this.fmap.corners, [0 0.5 0.5]);
                    this.mapAxes.drawSegmentFeature('segments', this.fmap.segments, [0 0.5 0.5]);
                end 
            else
                %% Add point
                isNewPoint = false;
                if isempty(p)
                    p = this.newPoint(x, y);
                    isNewPoint = true;
                end
                if length(p.S) < 2
                    if isempty(this.cp)
                        % Set current point
                        this.cp = p;
                        this.isCpNew = isNewPoint;
                    elseif p.x ~= this.cp.x || p.y ~= this.cp.y
                        % Add segment
                        s = Segment([this.cp.x p.x; this.cp.y p.y]);
                        sf = SegmentFeature([s.rho, s.theta, s.sd s.ed], diag([0.01, 1*pi/180]));
                        this.fmap.addFeature(sf);
                        %this.S = [this.S s];
                        this.cp.S = [this.cp.S sf];
                        p.S = [p.S sf];
                        
                        if ~isNewPoint
                           cf = CornerFeature([p.x p.y], diag([0.01, 1*pi/180]));
                           p.c = cf;
                           this.fmap.addFeature(cf);
                        end
                        
                        if ~ this.isCpNew
                           cf = CornerFeature([this.cp.x this.cp.y], diag([0.01, 1*pi/180]));
                           this.cp.c = cf;
                           this.fmap.addFeature(cf);
                        end

                        this.cp = [];
                        this.hLine.XData = NaN;
                        this.hLine.YData = NaN;
                        this.mapAxes.drawCornerFeatures('corners', this.fmap.corners, [0 0.5 0.5]);
                        this.mapAxes.drawSegmentFeature('segments', this.fmap.segments, [0 0.5 0.5]);
                    end
                end
            end  
            drawnow;
        end
        
        function keyPress(this, src, event)
            this.currentKey = event.Key;
            %% Zoom and Pan of Map Plot
            switch event.Key
                case 'a' % pan left
                    this.mapAxes.pan('left', 10);
                case 'd' % pan right
                    this.mapAxes.pan('right', 10);
                case 'w' % pan up
                    this.mapAxes.pan('up', 10);
                case 's' % pan down
                    this.mapAxes.pan('down', 10);
            end
            this.motion();
        end
        
        function keyRelease(this, src, event)
            this.currentKey = '';
            this.motion();
        end
        
        function mouseScroll(this, src, event)
            if strcmp(this.currentKey, 'g')
                
            else
                if event.VerticalScrollCount < 0
                    %this.zoomInMap(1.5);
                    this.mapAxes.zoomIn(1.5);
                else
                    %this.zoomOutMap(1.5);
                    this.mapAxes.zoomOut(1.5);
                end
            end
        end
        
    end
    
end


