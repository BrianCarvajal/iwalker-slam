classdef MapAxes < hgsetget
    
    properties
        Parent
        hAxes
        hImg
        RI      % imref2d instance, type help for more information
    end
    
    
    methods
        function this = MapAxes(varargin)
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
            %axis(this.hAxes, 'square');
            axis(this.hAxes, 'equal');
            hold(this.hAxes, 'on');
        end
        
        function pan(this, direction, distsance)
           ax = this.hAxes;
           XLon = ax.XLim(2) - ax.XLim(1);
           YLon = ax.YLim(2) - ax.YLim(1);
           d = min(XLon, YLon) / distsance;
           switch direction
               case 'left'
                   ax.XLim = ax.XLim - d;
               case 'right'
                   ax.XLim = ax.XLim + d;
               case 'up'
                   ax.YLim = ax.YLim + d;
               case 'down'
                   ax.YLim = ax.YLim - d;  
           end
        end
        
        function zoomIn(this, factor)
           ax = this.hAxes;
           XLon = ax.XLim(2) - ax.XLim(1);
           YLon = ax.YLim(2) - ax.YLim(1);
           fx = XLon - ((XLon/2)*factor);
           fy = YLon - ((YLon/2)*factor);
           XLim = ax.XLim - [-fx +fx];
           YLim = ax.YLim - [-fy +fy];
           if XLim(2) - XLim(1) > 1 && ...
              YLim(2) - YLim(1) > 1    
               ax.XLim = XLim;
               ax.YLim = YLim;
           end
        end
        
        function zoomOut(this, factor)
           ax = this.hAxes;
           XLon = ax.XLim(2) - ax.XLim(1);
           YLon = ax.YLim(2) - ax.YLim(1);
           fx = XLon - ((XLon/2)/factor);
           fy = YLon - ((YLon/2)/factor);
           XLim = ax.XLim + [-fx +fx];
           YLim = ax.YLim + [-fy +fy];
           if XLim(2) - XLim(1) < 200 && ...
              YLim(2) - YLim(1) < 200    
               ax.XLim = XLim;
               ax.YLim = YLim;
           end
        end
        
        function setImage(this, img, RI)
            if (isempty(this.hImg) || ~ishandle(this.hImg))
                hold(this.hAxes, 'off');
                this.hImg =  handle(imshow(img, RI));
                this.hImg.Parent = this.hAxes;
                axis(this.hAxes, 'xy');
                axis(this.hAxes, 'square');
                axis(this.hAxes, 'equal');
                axis(this.hAxes, 'on');
                hold(this.hAxes, 'on');
            else
                this.hImg.CData = img;
            end
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
        
        function writeText(this, tag, p, str, backColor)
            if (isempty(this.hAxes) && ~ishandle(this.hAxes))
                this.init();
            end
            
            h = handle(findobj(this.hAxes, 'Tag', tag));
            if isempty(h)
                h = handle(text('Position', p, ...
                    'String', str, ...
                    'BackgroundColor', backColor, ...
                    'Parent', this.hAxes, ...
                    'Tag', tag));
            else
                h.Position = p;
                h.String = str;
                %                 set(h, ...
                %                     'Position', p, ...
                %                     'String', str);
            end
        end
        
        
        function drawRobot(this, tag, xr, S, color)
            if (isempty(this.hAxes) && ~ishandle(this.hAxes))
                this.init();
            end
            hgt = handle(findobj(this.hAxes, 'Tag', tag));
            if isempty(hgt)
                hgt = handle(hgtransform());
                hgt.Tag = tag;
                hgt.Parent = this.hAxes;
                xx = [0 0.6  0 0];
                yy = [S/2 0 -S/2 S/2];
                hp = handle(patch( xx, yy, color, 'EdgeColor', color./2,...
                    'HitTest', 'off'));
                hp.Parent = hgt;
            end
            hgt.Matrix = transl([xr(1:2)' 0]) * trotz (xr(3));
        end
        
        function drawTrace(this, tag, p, color, lineWidth, style)
            if (isempty(this.hAxes) && ~ishandle(this.hAxes))
                this.init();
            end
            if isempty(p)
                return;
            end
            h = handle(findobj(this.hAxes, 'Tag', tag));
            if isempty(h)
                %h = handle(line(p(:,1), p(:,2), 'Color', color, 'LineWidth', lineWidth, 'LineStyle', style));
                patch([p(:,1); NaN],[p(:,2); NaN],0, ...
                    'LineStyle', '-', ...
                    'FaceColor', 'none', ...
                    'EdgeColor', color, ...
                    'LineWidth', lineWidth, ...
                    'LineStyle', style, ...
                    'HitTest', 'off', ...
                    'Tag', tag, ...
                    'Parent', this.hAxes);
            else
                h.XData = [p(:,1); NaN];
                h.YData = [p(:,2); NaN];
                h.EdgeColor= color;
                h.LineWidth = lineWidth;
                h.LineStyle = style;
            end
        end
        
        function h = drawErrorXY(this, tag, centre, Pxy, color, alpha)
            if (isempty(this.hAxes) && ~ishandle(this.hAxes))
                this.init();
            end
            % define points on a unit circle
            th = linspace(0, 2*pi, 50);
            pc = [cos(th);sin(th)];
            
            % warp it into the ellipse
            pe = sqrtm(Pxy)*pc;
            
            % offset it to optional non-zero centre point
            centre = centre(1:2);
            pe = bsxfun(@plus, centre(1:2), pe);
            X = pe(1,:);
            Y = pe(2,:);
            
            h = findobj(this.hAxes, 'Tag', tag);
            if isempty(h)
                h=handle(patch(X, Y, color, ...
                    'FaceAlpha', alpha, ...
                    'EdgeColor', 'none', ...
                    'HitTest', 'off', ...
                    'Tag', tag, ...
                    'Parent', this.hAxes));
            else
                set(h, 'XData', X, ...
                    'YData', Y, ...
                    'FaceColor', color, ...
                    'FaceAlpha', alpha);
            end
            
        end
        
        function drawErrorAngle(this, tag, xr, Pa, color, alpha)
            if (isempty(this.hAxes) && ~ishandle(this.hAxes))
                this.init();
            end
            
            ea = sqrt(Pa);
            angle = xr(3);
            th = linspace(angle + ea/2, angle - ea/2, ceil(ea*180/pi));
            pe = [cos(th);sin(th)];
            
            pe = bsxfun(@plus, xr(1:2), pe);
            x = [xr(1) pe(1,:) xr(1)];
            y = [xr(2) pe(2,:) xr(2)];
            h = findobj(this.hAxes, 'Tag', tag);
            if isempty(h)
                patch(x, y, color,...
                    'FaceAlpha', alpha,...
                    'EdgeColor', 'none', ...
                    'HitTest', 'off', ...
                    'Tag', tag, ...
                    'Parent', this.hAxes);
            else
                set(h, 'XData', x, 'YData', y, 'FaceColor', color, 'FaceAlpha', alpha);
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
                h = handle(scatter( p(1,:), p(2,:),s,color,marker, 'HitTest', 'off'));
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
        
        function drawRays(this, tag, p, xl, color, width, style)
            if (isempty(this.hAxes) && ~ishandle(this.hAxes))
                this.init();
            end
            if isempty(p) || numel(p) == 0
                p = [NaN; NaN];
            end
            X = repmat([xl(1) xl(1) NaN], 1, size(p,2));
            Y = repmat([xl(2) xl(2) NaN], 1, size(p,2));
            X(2:3:end) = p(1,1:end);
            Y(2:3:end) = p(2,1:end);
            h = findobj(this.hAxes, 'Tag', tag);
            if isempty(h)
                line(X, Y, 'Color', color, ...
                    'LineStyle', style, ...
                    'LineWidth', width, ...
                    'HitTest', 'off', ...
                    'Tag', tag, ...
                    'Parent', this.hAxes);
            else
                set(h, 'XData', X, 'YData', Y, 'Color', color, 'LineStyle', style, 'LineWidth', width);
            end
        end
        
        function drawScannedArea(this, tag, p, color, transp)
            if (isempty(this.hAxes) && ~ishandle(this.hAxes))
                this.init();
            end
            if isempty(p) || numel(p) == 0
                p = [0 0];
            end
            h = handle(findobj(this.hAxes, 'Tag', tag));
            if isempty(h)
                patch(p(1,:), p(2,:), color, ...
                    'EdgeColor', 'none', ...
                    'HitTest', 'off', ...
                    'FaceAlpha', transp, ...
                    'Tag', tag, ...
                    'Parent', this.hAxes);
            else
                h.XData = p(1,:);
                h.YData = p(2,:);
                h.FaceColor = color;
                h.FaceAlpha = transp;
            end
        end
        
        
        function drawCornerFeatures(this, tag, corners, color)
            if (isempty(this.hAxes) && ~ishandle(this.hAxes))
                this.init();
            end
            size = 0.05;
            c1 = color;
            c2 = color ./ 1.2;
            xx = [];
            yy = [];
            this.erase([tag 'V']);
            i = 1;
            for corner = corners
                xx = [xx [0 size 0 -size 0 NaN] + corner.x];
                yy = [yy [size 0 -size 0 size NaN] + corner.y];
                h = this.drawErrorXY([tag 'V' num2str(i)], [corner.x; corner.y], corner.Vf, [0.9 0 0.2], 0.3);
                h.tag = [tag 'V'];
                i = i + 1;
            end
            h = handle(findobj(this.hAxes, 'Tag', tag));
            if isempty(h)
                patch( xx, yy, c1, ...
                        'EdgeColor', c2, ...
                        'Tag', tag, ...
                        'Parent', this.hAxes);
            else
                set(h, 'XData', xx, 'YData', yy);
            end
%                 if corner.isAnonymous()
%                     patch( xx, yy, c1, ...
%                         'EdgeColor', c2, ...
%                         'Tag', tagAnon, ...
%                         'Parent', this.hAxes);
%                 else
%                     tagCorner = [tag '#' num2str(corner.id)];
%                     h = handle(findobj(this.hAxes, 'Tag', tagCorner));
%                     if isempty(h)
%                         patch( xx, yy, c1, ...
%                             'EdgeColor', c2, ...
%                             'Tag', tagAnon, ...
%                             'Parent', this.hAxes)
%                     else
%                         set(h, 'XData', xx, 'YData', yy);
%                     end
%                     this.drawErrorXY([tagCorner 'V'], [corner.x; corner.y], corner.Vf, [0.9 0 0.2], 0.3);
%                 end
%             end
        end
        
        function drawSegmentFeature(this, tag, segments, color)
            if (isempty(this.hAxes) && ~ishandle(this.hAxes))
                this.init();
            end
            lineWidth = 4;
            style = '-';
            
            
            
            xx = [];
            yy = [];
            for seg = segments
                if isvalid(seg)
                    xx = [xx NaN seg.sp(1) seg.ep(1)];
                    yy = [yy NaN seg.sp(2) seg.ep(2)];

                    x =  (seg.sp(1) + seg.ep(1)) / 2;
                    y =  (seg.sp(2) + seg.ep(2)) / 2;
                    this.writeText(['id' num2str(seg.id)], [x y], num2str(seg.id), color);
                end
            end
            
            h = handle(findobj(this.hAxes, 'Tag', tag));
            if isempty(h)
                patch(xx, yy, 0, ...
                    'LineStyle', '-', ...
                    'FaceColor', 'none', ...
                    'EdgeColor', color, ...
                    'LineWidth', lineWidth, ...
                    'LineStyle', style, ...
                    'HitTest', 'off', ...
                    'Tag', tag, ...
                    'Parent', this.hAxes);
            else
                set(h, ...
                    'XData', xx, ...
                    'YData', yy, ...
                    'EdgeColor', color, ...
                    'LineWidth', lineWidth, ...
                    'LineStyle', style);
            end
            
%             tagAnon = [tag '.Anonymous'];
%             this.erase(tagAnon);
%             for seg = segments
%                 xx = [seg.sp(1) seg.ep(1)];
%                 yy = [seg.sp(2) seg.ep(2)];
%                 if seg.isAnonymous()
%                     patch(xx, yy, 0, ...
%                         'LineStyle', '-', ...
%                         'FaceColor', 'none', ...
%                         'EdgeColor', color, ...
%                         'LineWidth', lineWidth, ...
%                         'LineStyle', style, ...
%                         'HitTest', 'off', ...
%                         'Tag', tagAnon, ...
%                         'Parent', this.hAxes);
%                 else
%                     tagSegment = [tag '#' num2str(seg.id)];
%                     h = handle(findobj(this.hAxes, 'Tag', tagSegment));
%                     if isempty(h)
%                         patch(xx, yy, 0, ...
%                             'LineStyle', '-', ...
%                             'FaceColor', 'none', ...
%                             'EdgeColor', color, ...
%                             'LineWidth', lineWidth, ...
%                             'LineStyle', style, ...
%                             'HitTest', 'off', ...
%                             'Tag', tagSegment, ...
%                             'Parent', this.hAxes);
%                     else
%                         set(h, ...
%                             'XData', xx, ...
%                             'YData', yy, ...
%                             'EdgeColor', color, ...
%                             'LineWidth', lineWidth, ...
%                             'LineStyle', style);
%                     end
%                     %this.drawErrorXY([tagCorner 'V'], [corner.x; corner.y], corner.Vf, [0.9 0 0.2], 0.3);
%                 end
%             end
        end
        
        
        
        function drawLandmark(this, tag, lans, color)
            if (isempty(this.hAxes) && ~ishandle(this.hAxes))
                this.init();
            end
            tagAnon = [tag '.Anonymous'];
            this.erase(tagAnon);
            for lan = lans
                c1 = color;
                c2 = color ./ 1.2;
                lx = lan.x;
                ly = lan.y;
                
                if lan.id == -1
                    scatter(lx,ly, 20, ...
                        'Marker','o', ...
                        'MarkerEdgeColor',c1, ...
                        'MarkerFaceColor',c2, ...
                        'HitTest', 'off', ...
                        'tag', tagAnon, ...
                        'Parent', this.hAxes);
                    
                else
                    tagLan = [tag '#' num2str(lan.id)];
                    this.drawErrorXY([tagLan 'V'], [lx ly]', lan.Vf, [0.9 0 0.2], 0.3);
                    
                    h = handle(findobj(this.hAxes, 'Tag', tagLan));
                    if isempty(h)
                        scatter(lx,ly, 20, ...
                            'Marker','o', ...
                            'MarkerEdgeColor',c1, ...
                            'MarkerFaceColor',c2, ...
                            'HitTest', 'off', ...
                            'tag', tagLan, ...
                            'Parent', this.hAxes);
                    else
                        set(h, 'XData', lx, 'YData', ly);
                    end
                end
            end
        end
        
        function drawSegments(this, tag, segments, color, lineWidth, style)
            if (isempty(this.hAxes) && ~ishandle(this.hAxes))
                this.init();
            end
            
            if isempty(segments)
                X = NaN;
                Y = NaN;
            else
                X = NaN(1,length(segments)*3);
                Y = NaN(1,length(segments)*3);
                i = 1;
                for s = segments
                    X(i:i+1) = [s.a(1) s.b(1)];
                    Y(i:i+1) = [s.a(2) s.b(2)];
                    i = i + 3;
                end
            end
            
            h = handle(findobj(this.hAxes, 'Tag', tag));
            if isempty(h)
                patch(X, Y, 0, ...
                    'LineStyle', '-', ...
                    'FaceColor', 'none', ...
                    'EdgeColor', color, ...
                    'LineWidth', lineWidth, ...
                    'LineStyle', style, ...
                    'HitTest', 'off', ...
                    'Tag', tag, ...
                    'Parent', this.hAxes);
            else
                set(h, ...
                    'XData', X, ...
                    'YData', Y, ...
                    'EdgeColor', color, ...
                    'LineWidth', lineWidth, ...
                    'LineStyle', style);
            end
        end
        
        function drawSegmentedLines(this, tag, lines)
            if (isempty(this.hAxes) && ~ishandle(this.hAxes))
                this.init();
            end
            h = handle(findobj(this.hAxes, 'Tag', tag));
            if ~isempty(h)
                delete(h);
            end
            for obj = lines
                X = [];
                Y = [];
                for i = 1:2:length(obj.ep)
                    X = [X obj.ep(1,i), obj.ep(1,i+1), NaN];
                    Y = [Y obj.ep(2,i), obj.ep(2,i+1), NaN];
                end
                line(X, Y, 'Color', 'r', 'LineWidth', 2, ...
                    'HitTest', 'off', ...
                    'Tag', tag, ...
                    'Parent', this.hAxes);
                % Line estimated
                if strcmp(obj.orientation, 'horizontal');
                    xx = [(X(1) - 15) (X(end-1) + 15)];
                    yy = obj.m*xx + obj.c;
                else
                    yy = [(Y(1) - 15) (Y(end-1) + 15)];
                    xx = obj.m*yy + obj.c;
                end
                h = line(xx, yy, 'Color', 'y', 'LineStyle', '--',  'LineWidth', 0.05);
                set(h, 'Parent', this.hAxes, 'tag', tag);
            end
        end
        
        function drawHough(this, tag, segments, xr, color, lineWidth, style)
            if (isempty(this.hAxes) && ~ishandle(this.hAxes))
                this.init();
            end
            if isempty(segments)
                X = NaN;
                Y = NaN;
            else
                X = NaN(1,length(segments)*3);
                Y = NaN(1,length(segments)*3);
                i = 1;
                for s = segments
                    X(i:i+1) = [xr(1) xr(1)+s.rho*cos(s.theta+xr(3))];
                    Y(i:i+1) = [xr(2) xr(2)+s.rho*sin(s.theta+xr(3))];
                    i = i + 3;
                end
            end
            
            h = handle(findobj(this.hAxes, 'Tag', tag));
            if isempty(h)
                patch(X, Y, 0, ...
                    'LineStyle', '-', ...
                    'FaceColor', 'none', ...
                    'EdgeColor', color, ...
                    'LineWidth', lineWidth, ...
                    'LineStyle', style, ...
                    'HitTest', 'off', ...
                    'Tag', tag, ...
                    'Parent', this.hAxes);
            else
                set(h, ...
                    'XData', X, ...
                    'YData', Y, ...
                    'EdgeColor', color, ...
                    'LineWidth', lineWidth, ...
                    'LineStyle', style);
            end
        end
        
        function drawGoal(this, tag, goal, size, color, alpha, rot)
            if (isempty(this.hAxes) && ~ishandle(this.hAxes))
                this.init();
            end
            tagPatch =  [tag '.patch'];
            hgt = handle(findobj(this.hAxes, 'Tag', tag));
            if isempty(hgt)
                hgt = handle(hgtransform());
                hgt.Tag = tag;
                hgt.UserData = 1;
                hgt.Parent = this.hAxes;
                xx = [0 size 0 -size 0];
                yy = [size 0 -size 0 size];
                hp = handle(patch( xx, yy, color, 'EdgeColor', color./2, 'FaceAlpha', alpha));
                hp.Parent = hgt;
                hp.Tag = tagPatch;
            end
            hp = handle(findobj(this.hAxes, 'Tag', tagPatch));
            if ~isempty(hp)
                hp.EdgeColor = color./2;
                hp.FaceColor = color;
                hp.FaceAlpha = alpha;
            end
            
            hgt.Matrix =  transl([goal 0]) * trotz (hgt.UserData, 'deg');
            hgt.UserData = hgt.UserData + rot;
        end
    end
    
end

