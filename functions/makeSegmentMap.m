function S = makeSegmentMap(xlims, ylims)
    function motion(~, ~)
        get(mapAxes.hAxes, 'currentpoint');
        if length(xmouse) == 1
            p = get(mapAxes.hAxes, 'currentpoint');
            s = Segment([xmouse p(1,1); ymouse p(1,2)]);
            mapAxes.drawSegments('provsegment', s, [0 0.7 0], 1, '--');
        else
            mapAxes.erase('provsegment');
        end
        drawnow;
    end

    function click(src, ~)
        p = get(mapAxes.hAxes, 'currentpoint');
        xmouse = [xmouse p(1,1)];
        ymouse = [ymouse p(1,2)];
        
        if strcmp(get(src, 'SelectionType'), 'alt')
            xmouse = [];
            ymouse = [];
        else
            if length(xmouse) == 2
                S = [S Segment([xmouse; ymouse])];
                xmouse = xmouse(2);
                ymouse =  ymouse(2);                
                mapAxes.drawSegments('segments', S, [0 0 0.9], 2, '-');
                drawnow;
            end
        end              
    end

    xmouse = [];
    ymouse = [];
    S = [];
    s = [];

    f = figure('MenuBar', 'none', 'Name', 'Segment Map Editor');
    set(f, 'renderer', 'opengl');
    set(f,'DefaultLineLineSmoothing','on');
    set(f,'DefaultPatchLineSmoothing','on');
    
    mapAxes = MapAxes('Parent', f);
    set(f, 'WindowButtonDownFcn', @click);
    set(f, 'WindowButtonMotionFcn', @motion);
    mapAxes.hAxes.xLim = xlims;
    mapAxes.hAxes.yLim = ylims;

    uiwait(f);

end



 

