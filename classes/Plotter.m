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
            axis equal;
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
        
        
        function plotRobot(pl, x, tag)
            if ~ishghandle(pl.ha)
                pl.ha = Plotter.newAxes();
            end
            h = findobj(pl.ha, 'Tag', tag);
            
            if isempty(h)
                           
                h = hgtransform();
                set(h, 'Tag', tag);  % tag it
                
                rx = pl.wRad;
                ry = pl.wRad/4;
                S = pl.wSep;

                hp = [];
                %% center of robot
                %hp = [hp scatter(0, 0, 50, 'ro')];
                
                
                %% frame              
                xx = [0 0.6  0 0];
                yy = [S/2 0 -S/2 S/2];
                hp = [hp patch( xx, yy, 'r', 'EdgeColor', 'none')];
                
                %% wheels
                xx = [-rx -rx rx  rx -rx];
                yy = [-ry  ry ry -ry -ry];                
                hp = [hp patch( xx, yy + S/2, [0.7 0.7 0.7], 'EdgeColor', 'none')];
                hp = [hp patch( xx, yy - S/2, [0.7 0.7 0.7], 'EdgeColor', 'none')];
                
                                                                
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
               h = plot(x(:,1), x(:,2), 'Color', color);
               set(h, 'Tag', tag);
            else
                set(h, 'XData', x(:,1), 'YData', x(:,2), 'Color', color);
            end
        end
        
        function plotLandmark(pl, lans, tag)           
            if ~ishghandle(pl.ha)
                pl.ha = Plotter.newAxes();
            end  
            
            for lan = lans
                u1 = lan.u1 * 0.1;
                u2 = lan.u2 * 0.1;
                X = [lan.x + u1(1), lan.x, lan.x + u2(1)];
                Y = [lan.y + u1(2), lan.y, lan.y + u2(2)];
                if lan.isConvex()
                    color = 'c';
                else
                    color = 'y';
                end
                
                %tag = ['Landmark_', num2str(lan.id)];
                h = findobj(pl.ha, 'Tag', tag);
                if isempty(h)
                    h = line(X, Y, 'Color', color, 'LineWidth', 5);
                    %text(lan.x , lan.y, int2str(lan.id), 'FontSize', 20, 'Color', 'r');
                    set(h, 'Tag', tag);
                    set(h, 'UserData', lan);
                else
                    set(h, 'XData', X, 'YData', Y, 'Color', color);
                end

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
            else
                set(h, 'XData', x, 'YData', y);
            end
        end
        
        
        
        
    end
    
end

