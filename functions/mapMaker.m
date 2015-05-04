function [S, fmap] = mapMaker(xlims, ylims)
    
    %% Initialization    
    if nargin < 2
        xlims = [-5 5];
        ylims = [-5 5];
    end
    xextralims = xlims + [-1 1];
    yextralims = ylims + [-1 1];

    
    color = [0.0 0.7 0.3];

    orig_state = warning;
    warning('off','all')

    xmouse = [];
    ymouse = [];
    P = [];

    gridTiks = 1;
    currentKey = '';
    f = figure('MenuBar', 'none', 'Name', 'Segment Map Editor');
    whitebg(f,[0.2 0.2 0.2]);
    set(f, 'renderer', 'opengl');
    set(f,'DefaultLineLineSmoothing','on');
    set(f,'DefaultPatchLineSmoothing','on');
    set(f, 'WindowButtonDownFcn', @click);
    set(f, 'WindowButtonMotionFcn', @motion);
    set(f, 'WindowKeyPressFcn', @keyPress);
    set(f, 'WindowKeyReleaseFcn', @keyRelease);
    set(f, 'WindowScrollWheelFcn', @mouseScroll);
    
    mapAxes = MapAxes('Parent', f);
    hAxes = mapAxes.hAxes;
    
    axis(hAxes, 'equal');
    grid(hAxes, 'on');
 
    
    hAxes.xLim = xextralims;
    hAxes.yLim = yextralims;
    
    hcP = handle(patch(NaN, NaN, color, 'FaceAlpha', 0.5, 'EdgeColor', 'none'));
 
    xin = [xlims(1) xlims(2) xlims(2) xlims(1) xlims(1)];
    yin = [ylims(1) ylims(1) ylims(2) ylims(2) ylims(1)];
    xout = [xextralims(1) xextralims(2) xextralims(2) xextralims(1) xextralims(1)];
    yout = [yextralims(1) yextralims(1) yextralims(2) yextralims(2) yextralims(1)];
    
    [ff, vv] =  poly2fv({xout,xin}, {yout, yin});
    
    
    patch('Faces', ff, 'Vertices', vv, 'FaceColor', color, 'EdgeColor', 'none')
    
    %% Wait here until figure close
    uiwait(f);
    
    %% Segments and Map construction
    fmap = FeatureMap();   
    S = [ ...
        Segment([xlims(1) xlims(2); ylims(1) ylims(1)]), ...
        Segment([xlims(2) xlims(2); ylims(1) ylims(2)]), ...
        Segment([xlims(2) xlims(1); ylims(2) ylims(2)]), ...
        Segment([xlims(1) xlims(1); ylims(2) ylims(1)]), ...
        ];
    fmap.addFeature(CornerFeature([xlims(1) ylims(1)], diag([0.01, 1*pi/180])));
    fmap.addFeature(CornerFeature([xlims(1) ylims(2)], diag([0.01, 1*pi/180])));
    fmap.addFeature(CornerFeature([xlims(2) ylims(1)], diag([0.01, 1*pi/180])));
    fmap.addFeature(CornerFeature([xlims(2) ylims(2)], diag([0.01, 1*pi/180])));
    
    for s = S
        sf = SegmentFeature([s.rho, s.theta, s.sd s.ed], diag([0.01, 1*pi/180]));
        fmap.addFeature(sf);     
    end
  
    for q = P
        for j = 1:length(q.x)-1
            s = Segment([q.x(j:j+1); q.y(j:j+1)]);
            sf = SegmentFeature([s.rho, s.theta, s.sd s.ed], diag([0.01, 1*pi/180]));
            cf = CornerFeature([q.x(j) q.y(j)], diag([0.01, 1*pi/180]));
            S = [S s];
            fmap.addFeature(sf);
            fmap.addFeature(cf);
        end
    end
    
    
    warning(orig_state);
    
    %% Auxiliar nested functions
    function [x, y] = getMousePoint()
        p = get(hAxes, 'currentpoint');
        if strcmp(get(gcf,'currentModifier'), 'shift')
            p(1,1) = interp1(hAxes.XTick, hAxes.XTick, p(1,1), 'nearest');
            p(1,2) = interp1(hAxes.YTick, hAxes.YTick, p(1,2), 'nearest');
        end
        x = min(max(p(1,1), xlims(1)), xlims(2));
        y = min(max(p(1,2), ylims(1)), ylims(2));
    end

    function motion(~, ~)
        get(hAxes, 'currentpoint');
        switch length(xmouse)
            case 0
                hP.XData = NaN;
                hP.YData = NaN;
            case 1
            x1 = xmouse;
            y1 = ymouse;
            [x2, y2] = getMousePoint();
            hcP.XData = [x1 x2 x2 x1];
            hcP.YData = [y1 y1 y2 y2];
        end
        drawnow;
    end

    function click(src, ~)
        [x, y] = getMousePoint();
        xmouse = [xmouse x];
        ymouse = [ymouse y];
        
        if strcmp(get(src, 'SelectionType'), 'alt')
            % Restart rectangle construction
            xmouse = [];
            ymouse = [];
            hcP.XData = NaN;
            hcP.YData = NaN;
        else
            % Add corner
            if length(xmouse) == 2
                % Two corners
                % Construct new rectangle
                x1 = xmouse(1);
                x2 = xmouse(2);
                y1 = ymouse(1);
                y2 = ymouse(2);
                xn = [x1 x2 x2 x1 x1];
                yn = [y1 y1 y2 y2 y1];
                xmouse = [];
                ymouse = []; 

                % Collect polygons vertices and delete patches
                xx = [];
                yy = [];
                for p = P
                    xx = [xx p.x NaN];
                    yy = [yy p.y NaN];
                    delete(p.hP); 
                end

                % Reconstruct polygons with the new data
                [xx, yy] = polybool('union', xx, yy, xn, yn);
                P = [];
                pol.x = [];
                pol.y = [];
                for i = 1:length(xx) + 1
                    if i > length(xx) || isnan(xx(i))
                        % polybool returns each polygon points separated by NaNs
                        pol.hP = patch(pol.x, pol.y, color, 'EdgeColor', 'none');
                        P = [P pol]; 
                        pol.x = [];
                        pol.y = [];
                    else
                        pol.x = [pol.x xx(i)];
                        pol.y = [pol.y yy(i)];                       
                    end
                end          
            end
        end
        drawnow;
    end

    function keyPress(src, event)
        currentKey = event.Key;
        %% Zoom and Pan of Map Plot
        switch event.Key
            case 'a' % pan left
                mapAxes.pan('left', 10);
            case 'd' % pan right
                mapAxes.pan('right', 10);
            case 'w' % pan up
                mapAxes.pan('up', 10);
            case 's' % pan down
                mapAxes.pan('down', 10);
        end
    end

    function keyRelease(src, event)
        currentKey = '';
    end

    function mouseScroll(src, event)
        if strcmp(currentKey, 'g')
           
        else
            if event.VerticalScrollCount < 0
                %this.zoomInMap(1.5);
                mapAxes.zoomIn(1.5);
            else
                %this.zoomOutMap(1.5);
                mapAxes.zoomOut(1.5);
            end
        end
    end
end



 

