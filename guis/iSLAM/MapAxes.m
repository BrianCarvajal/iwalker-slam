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
            
            if isempty(this.Parent)
                this.Parent = figure;                
            end
            
            this.init();
            
%             this.hAxes = handle(axes('Parent', this.Parent));          
%             set(this.hAxes, 'LooseInset', get(this.hAxes,'TightInset'), ...
%                            'ActivePositionProperty', 'OuterPosition', ...
%                            'Xcolor',[0 0 0], 'Ycolor',[0 0 0]);
                        
            %%this.hImg = imshow(this.sim.gmp.image, this.sim.gmp.R);
            %set(this.hImg, 'Parent', this.hAxes); 
%             axis xy;
%             axis on;
%             hold on;
            
            %this.plotter = Plotter(this.hAxes);
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
            axis(this.hAxes, 'xy');
            axis(this.hAxes, 'on');
            hold(this.hAxes, 'on');
        end
        
        function setImage(this, img, RI)
           if (isempty(this.hImg) || ~ishandle(this.hImg)) 
              hold(this.hAxes, 'off');
              this.hImg =  handle(imshow(img, RI));
              this.hImg.Parent = this.hAxes;
              axis(this.hAxes, 'xy');
              axis(this.hAxes, 'on');
              hold(this.hAxes, 'on');
           else
              this.hImg.CData = img;
           end
        end
        
        function update(obj)
%             lid = obj.sim.lid;
%             ext = obj.sim.ext;
%             res = ext.output;
%             ptr = obj.plotter;
%             if obj.updateMap
%                 obj.updateMap = false;
%                 set(obj.hImg, 'CData', obj.sim.gmp.image);
%                 pcolor = [0 1 0.2];
%                 p = lid.pw(:,lid.range < 5);
%                 ptr.plotPoints(lid.pw(1,lid.valid), lid.pw(2,lid.valid), 'points', pcolor, 3, '.');
%                 ptr.plotRays(lid.x, lid.pw(1,lid.valid), lid.pw(2,lid.valid), 'rays.inRange', [0 1 1]./2, 0.1, '-');
%                 %ptr.plotScanArea(lid.pw(1,lid.valid), lid.pw(2,lid.valid), 'scanArea', [1 0 0], 0.5)
%                 %obj.plotter.plotSegments(ext.segments, 'segments');
%                 obj.plotter.plotSegmentedLines(ext.output.lines, 'segments');
%             end
%             
%             rob = obj.sim.rob;
%             obj.plotter.plotRobot(rob.x, 'iWalker', [1 0 0]);
%             if ~isempty(rob.x_hist)
%                 obj.plotter.plotTrace(rob.x_hist, 'trace.iWalker', [1 0 0]);
%             end
            
        end
        
        function erase(this, tag)
            if (~isempty(this.hAxes) && ishandle(this.hAxes))
                delete(findall(this.hAxes, 'Tag', tag));
            end
        end
        
        function drawRobot(this, tag, x, S, color)
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
                hp = handle(patch( xx, yy, color, 'EdgeColor', color./2));
                hp.Parent = hgt;                
            end 
            hgt.Matrix = transl([x(1:2)' 0]) * trotz (x(3));
        end
        
        function drawTrace(this, tag, p, color, lineWidth)
            if (isempty(this.hAxes) && ~ishandle(this.hAxes))
                this.init();
            end
            if isempty(p)
                return;
            end
            h = handle(findobj(this.hAxes, 'Tag', tag));
            if isempty(h)
                 h = handle(line(p(:,1), p(:,2), 'Color', color, 'LineWidth', lineWidth));
                 h.Tag = tag;
                 h.Parent = this.hAxes;
            else
                h.XData = p(:,1);
                h.YData = p(:,2);
                h.Color = color;
                h.LineWidth = lineWidth;
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
                h = handle(patch(p(1,:), p(2,:), color, 'EdgeColor', 'none', 'HitTest', 'off', 'FaceAlpha', transp));
                h.Tag = tag;
                h.Parent = this.hAxes;
            else
                h.XData = p(1,:);
                h.YData = p(2,:);
                h.FaceColor = color;
                h.FaceAlpha = transp;
            end
        end
        
        function newScan(obj)
%            obj.updateMap = true; 
        end
    end
    
end

