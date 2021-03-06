classdef Plotter < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %% General properties
        ha              %axes handler
        
        %% Robot properties
        wRad = 0.100    % wheels radius
        wSep = 0.520    % wheels separation
    end
    
    methods (Static)
        
        function ha= newAxes()
            ha = gca;
            hold on;
            %axis equal;
            grid on;
        end
        
    end
    
    methods
        function pl = Plotter(ha)
            if nargin < 1
                ha = Plotter.newAxes();
            end
            pl.ha = ha;
        end
        
        
        function plotRobot(pl, x, tag, color)
            if ~ishghandle(pl.ha)
                pl.ha = Plotter.newAxes();
            end
            if nargin < 4
               color = 'r'; 
            end
            h = findobj(pl.ha, 'Tag', tag);
            
            if isempty(h)
                
                h = hgtransform();
                set(h, 'Tag', tag);  % tag it
                set(h, 'Parent', pl.ha);
                
                rx = pl.wRad;
                ry = pl.wRad/4;
                S = pl.wSep;
                
                hp = [];
                %% center of robot
                %hp = [hp scatter(0, 0, 50, 'ro')];
                
                
                %% frame
                %triangle
                xx = [0 0.6  0 0];
                yy = [S/2 0 -S/2 S/2];
                hp = [hp patch( xx, yy, color, 'EdgeColor', color./2)];
                % walker
%                 xx = [0.2 0.58 0.58 0.2 0.2];
%                 yy = [S/2 S/2.1 -S/2.1 -S/2 S/2];
%                 hp = [hp patch( xx, yy, color, 'EdgeColor', 'none')];
%                 xx = [0 0.2 0.2 0 0];
%                 yy = [S/2 S/2 S/2-0.05 S/2-0.05 S/2];
%                 hp = [hp patch( xx, yy, color, 'EdgeColor', 'none')];
%                 xx = [0 0.2 0.2 0 0];
%                 yy = [-S/2 -S/2 -S/2+0.05 -S/2+0.05 -S/2];
%                 hp = [hp patch( xx, yy, color, 'EdgeColor', 'none')];
                
                %% wheels
%                 xx = [-rx -rx rx  rx -rx];
%                 yy = [-ry  ry ry -ry -ry];
%                 hp = [hp patch( xx, yy + S/2, [0.2 0.2 0.2], 'EdgeColor', [0 0 0])];
%                 hp = [hp patch( xx, yy - S/2, [0.2 0.2 0.2], 'EdgeColor', [0 0 0])];
                
                %% laser
%                 theta=linspace(0,2*pi,10); %100 evenly spaced points between 0 and 2pi
%                 rho=ones(1,10)*0.03; %Radius should be 1 for all 100 points
%                 [xx,yy] = pol2cart(theta,rho);
%                 xx = xx + 0.56;
%                 hp = [hp patch( xx, yy, 'y', 'EdgeColor', 'none')];
                
                
                
                for hh=hp
                    set(hh, 'Parent', h);
                    set(hh, 'Tag', [tag '.chunk']);
                    
                end
                
            end
            
            set(h, 'Matrix', transl([x(1:2)' 0]) * trotz (x(3)));
        end
        
        function plotTrace(pl, x, tag, color)
            if isempty(x)
                return;
            end
            if ~ishghandle(pl.ha)
                pl.ha = Plotter.newAxes();
            end
            h = findobj(pl.ha, 'Tag', tag);
            if isempty(h)
                h = line(x(:,1), x(:,2), 'Color', color, 'LineWidth', 1);
                set(h, 'Parent', pl.ha);
                set(h, 'Tag', tag);
            else
                set(h, 'XData', x(:,1), 'YData', x(:,2), 'Color', color);
            end
        end
        
        function plotSegmentedLines(pl, lines, tag)
            if ~ishghandle(pl.ha)
                pl.ha = Plotter.newAxes();
            end
            h = findobj(pl.ha, 'Tag', tag);
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
                h = line(X, Y, 'Color', 'r', 'LineWidth', 2);
                set(h, 'Parent', pl.ha, 'tag', tag);
%                 h = scatter(obj.ep(1,:), obj.ep(2,:), 'r');
%                 set(h, 'Parent', pl.ha, 'tag', tag);
%                 h = scatter(obj.ep(1,1), obj.ep(2,1), 'r^');
%                 set(h, 'Parent', pl.ha, 'tag', tag);
%                 h = scatter(obj.ep(1,end), obj.ep(2,end), 'b^');
%                 set(h, 'Parent', pl.ha, 'tag', tag);
                
                % Line estimated
                if strcmp(obj.orientation, 'horizontal');
                    xx = [(X(1) - 15) (X(end-1) + 15)];
                    yy = obj.m*xx + obj.c;
                else
                    yy = [(Y(1) - 15) (Y(end-1) + 15)];
                    xx = obj.m*yy + obj.c;
                end
                 h = line(xx, yy, 'Color', 'y', 'LineStyle', '--',  'LineWidth', 0.05);
                 set(h, 'Parent', pl.ha, 'tag', tag);
            end
        end

        function plotSegments(pl, segments, tag)
            if ~ishghandle(pl.ha)
                pl.ha = Plotter.newAxes();
            end
            h = findobj(pl.ha, 'Tag', tag);
            if ~isempty(h)
                delete(h);
            end
            for obj = segments
                % Line estimated
                if strcmp(obj.orientation, 'horizontal');
                    xx = [(obj.a(1) - 15) (obj.b(1) + 15)];
                    yy = obj.m*xx + obj.c;
                else
                    yy = [(obj.a(2) - 15) (obj.b(2) + 15)];
                    xx = obj.m*yy + obj.c;
                end
                h = line(xx, yy, 'Color', 'c', 'LineStyle', '--',  'LineWidth', 0.1);
                set(h, 'Parent', pl.ha, 'tag', tag);
                % Segment estimated
                h = line([obj.a(1) obj.b(1)], [obj.a(2) obj.b(2)], 'Color', [1 0 1], 'LineWidth', 3);
                set(h, 'Parent', pl.ha, 'tag', tag);
                % Naive segment: endpoints
%                 h = line([obj.p(1,1) obj.p(1,end)], [obj.p(2,1) obj.p(2,end)], 'Color', 'r', 'LineWidth', 1);
%                 set(h, 'Parent', pl.ha, 'tag', tag);
                % Hough
                x = obj.rho * cosd(obj.theta);
                y = obj.rho * sind(obj.theta);
                h = line([0 x], [0 y], 'Color', 'b', 'LineStyle', '-.');
                set(h, 'Parent', pl.ha, 'tag', tag);
            end
        end
        
        function plotAnonymousLandmarks(pl, lans, tag, color, local)
            if ~ishghandle(pl.ha)
                pl.ha = Plotter.newAxes();
            end
            if nargin < 5
               local = false; 
            end
            h = findobj(pl.ha, 'Tag', tag);
            if ~isempty(h)
                delete(h);
            end
            for lan = lans
            % Anonymous landmark
%                     c1 = [190 30 30]./255;
%                     c2 = [250 120 25]./255;
                    c1 = color;
                    c2= color ./ 1.2;
                    if local
                       lx = lan.posl(1);
                       ly = lan.posl(2);
                    else
                        lx = lan.pos(1);
                        ly = lan.pos(2);
                    end
                    h = plot(lx,ly,   'LineStyle','none', ...
                                      'Marker','o', ...
                                      'MarkerSize',5, ...
                                      'MarkerEdgeColor',c1, ...
                                      'MarkerFaceColor',c2, ...
                                      'HitTest', 'off');
                    set(h, 'Tag', tag);
                    set(h, 'Parent', pl.ha);
                    set(h, 'UserData', lan);
                    
                    
                    if ~isempty(lan.matched_landmark) && ~local
                       Xl = [lx lan.matched_landmark.x];
                       Yl = [ly lan.matched_landmark.y];
                       raycolor = [rand*20 + 20, rand*20 + 180, rand*20 + 180]./255;
                       raywidth = rand*3 + 1;
                       h2 = line(Xl, Yl, 'Color', raycolor, 'LineWidth', raywidth);
                       set(h2, 'Tag', tag);
                       set(h, 'Parent', pl.ha);
                    end
                    
            end
        end
              
        
        function plotKnownLandmarks(pl, lans, tag)
            if ~ishghandle(pl.ha)
                pl.ha = Plotter.newAxes();
            end

            for lan = lans              
                % Map landmark
                ltag = [tag '.' num2str(lan.id)];
                h = findobj(pl.ha, 'Tag', ltag);
                if isempty(h)
                    c1 = [30 190 180]./255;
                    c2 = [30 220 80]./255;
                    h = plot(lan.x,lan.y, 'LineStyle','none', ...
                                          'Marker','o', ...
                                          'MarkerSize',5, ...
                                          'MarkerEdgeColor',c1, ...
                                          'MarkerFaceColor',c2, ...
                                          'HitTest', 'off');
                    %text(lan.x , lan.y, int2str(lan.id), 'FontSize', 20, 'Color', 'r');
                    set(h, 'Tag', ltag);
                    set(h, 'Parent', pl.ha);
                    set(h, 'UserData', lan);
                else
                    set(h, 'XData', lan.x, 'YData', lan.y);
                end
                
                
                
%                 % Point landmark
%                 if isempty(lan.u1)
%                     color = 'g';
%                     h = findobj(pl.ha, 'Tag', ltag);
%                     if isempty(h)
%                         c1 = [0 1 0.3];
%                         c2 = [0 0.4 1];
%                         h = plot(lan.x,lan.y,'LineStyle','none','Marker','o','MarkerSize',5,'MarkerEdgeColor',c1,'MarkerFaceColor',c2, 'HitTest', 'off');
%                         %text(lan.x , lan.y, int2str(lan.id), 'FontSize', 20, 'Color', 'r');
%                         set(h, 'Tag', ltag);
%                         set(h, 'Parent', pl.ha);
%                         set(h, 'UserData', lan);
%                     else
%                         set(h, 'XData', lan.x, 'YData', lan.y, 'Color', color);
%                     end
%                 % Vertex landmark
%                 else
%                     u1 = lan.u1 * 0.1;
%                     u2 = lan.u2 * 0.1;
%                     X = [lan.x + u1(1), lan.x, lan.x + u2(1)];
%                     Y = [lan.y + u1(2), lan.y, lan.y + u2(2)];
% 
%                     if lan.isConvex()
%                         color = 'g';
%                     else
%                         color = 'g';
%                     end
%                     h = findobj(pl.ha, 'Tag', ltag);
%                     if isempty(h)
%                         h = line(X, Y, 'Color', color, 'LineWidth', 5, 'HitTest', 'off');
%                         %text(lan.x , lan.y, int2str(lan.id), 'FontSize', 20, 'Color', 'r');
%                         set(h, 'Tag', ltag);
%                         set(h, 'Parent', pl.ha);
%                         set(h, 'UserData', lan);
%                     else
%                         set(h, 'XData', X, 'YData', Y, 'Color', color);
%                     end
%                 end
            end
        end
        
        function plotErrorXY(pl, Pxy, xv, tag, color)
            if size(Pxy,1) ~= size(zeros(2,2))
                error('ellipse is defined by a 2x2 matrix');
            end
            
            if ~ishghandle(pl.ha)
                pl.ha = Plotter.newAxes();
            end
            
            
            
            % define points on a unit circle
            th = linspace(0, 2*pi, 50);
            pc = [cos(th);sin(th)];
            
            % warp it into the ellipse
            pe = sqrtm(Pxy)*pc;
            
            % offset it to optional non-zero centre point
            centre = xv(1:2);
            pe = bsxfun(@plus, centre(1:2), pe);
            x = pe(1,:); y = pe(2,:);
            
            h = findobj(pl.ha, 'Tag', tag);
            if isempty(h)
                h = patch(x, y, color, 'FaceAlpha', 0.5, 'EdgeColor', 'none');
                set(h, 'Tag', tag);
                set(h, 'Parent', pl.ha);
            else
                set(h, 'XData', x, 'YData', y);
            end
        end
        
        function plotErrorAngle(pl, Pa, xv, tag, color)
            if ~ishghandle(pl.ha)
                pl.ha = Plotter.newAxes();
            end
            
            ea = sqrt(Pa);
            angle = xv(3);
            th = linspace(angle + ea/2, angle - ea/2, ceil(ea*180/pi));
            pe = [cos(th);sin(th)];
            
            % offset it to optional non-zero centre point
            centre = xv(1:2);
            
            pe = bsxfun(@plus, centre(1:2), pe);
            x = [xv(1) pe(1,:) xv(1)];
            y = [xv(2) pe(2,:) xv(2)];
            
            
            h = findobj(pl.ha, 'Tag', tag);
            if isempty(h)
                h = patch(x, y, color, 'FaceAlpha', 0.5, 'EdgeColor', 'none');
                set(h, 'Tag', tag);
                set(h, 'Parent', pl.ha);
            else
                set(h, 'XData', x, 'YData', y);
            end
        end
        
        function plotPoints(pl, X, Y, tag, color, s, marker)
            if ~ishghandle(pl.ha)
                pl.ha = Plotter.newAxes();
            end
            
            h = findobj(pl.ha, 'Tag', tag);
            if isempty(h)
                h = scatter(X, Y, s, color, marker);
                set(h, 'Tag', tag);
                set(h, 'Parent', pl.ha);
            else
                set(h, 'XData', X, 'YData', Y, 'CData', color, 'SizeData', s, 'Marker', marker);
            end
        end
        
        function plotRays(pl, xl, X, Y, tag, color, width, style) 
            if ~ishghandle(pl.ha)
                pl.ha = Plotter.newAxes();
            end  
            

            Xr = [];
            Yr = [];
            for i = 1:length(X)
               Xr = [Xr xl(1) X(i) NaN];
               Yr = [Yr xl(2) Y(i) NaN];
            end
            
            h = findobj(pl.ha, 'Tag', tag);
            if isempty(h)
                h = line(Xr, Yr, 'Color', color, 'LineStyle', style, 'LineWidth', width);
                set(h, 'Tag', tag);
                set(h, 'Parent', pl.ha);
            else
                set(h, 'XData', Xr, 'YData', Yr, 'Color', color, 'LineStyle', style, 'LineWidth', width);
            end
        end
        
        
        
        %cp : color points
        %ca : color area
        function plotScanArea(pl, X, Y, tag, color, alph)
            if ~ishghandle(pl.ha)
                pl.ha = Plotter.newAxes();
            end
            if isempty(X) || numel(X) == 0
                Xl = 0;
                Yl = 0;
            else
                Xl = X(1);
                Yl = Y(1);
            end
            h = findobj(pl.ha, 'Tag', tag);
            if isempty(h)
                h = patch([X Xl], [Y Yl], color, 'EdgeColor', 'none', 'HitTest', 'off');
                alpha(h, alph);
                set(h, 'Tag', tag);
                set(h, 'Parent', pl.ha);
            else
                set(h,'XData',[X Xl], 'YData',[Y Yl], 'FaceColor', color);
            end
        end
        
        function plotSplitAndMerge(pl, Res, tag)
            if ~ishghandle(pl.ha)
                pl.ha = Plotter.newAxes();
            end
            p = Res.p;
          
            L = Res.edges;
            X = [];
            Y = [];
            for i = 1: size(L,2)
                X = [X p(1, L(:,i)) NaN];
                Y = [Y p(2, L(:,i)) NaN];               
            end
            
            h = findobj(pl.ha, 'Tag', [tag '.line']);
            if isempty(h)
                h = line(X, Y, 'Color', [0.1 0.1 0.9], 'LineWidth', 2);
                set(h, 'Tag', [tag '.line']);
                set(h, 'Parent', pl.ha);
            else
                set(h, 'XData', X, 'YData', Y);
            end
            
%             h = findobj(pl.ha, 'Tag', [tag '.endpoints']);
%             if isempty(h)
%                 h = scatter(X, Y, 50, 'co');
%                 set(h, 'Tag', [tag '.endpoints']);
%             else
%                 set(h, 'XData', X, 'YData', Y);
%             end
                    
            V = Res.vertices;
            h = findobj(pl.ha, 'Tag', [tag '.vertices']);
            if isempty(h)
                h = scatter(p(1,V), p(2,V), 50, 'go', 'fill');
                set(h, 'Tag', [tag '.vertices']);
                set(h, 'Parent', pl.ha);
            else
                set(h, 'XData', p(1,V), 'YData', p(2,V));
            end

        end
        
        
    end
   
end

