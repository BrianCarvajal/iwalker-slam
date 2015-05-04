function simData = virtualSLAM(filename, fps)
    d = 5;
    xlims = [-1 2*d+1];
    ylims = [-1 2*d+1];
    traceLength = 100;
   
    
    %S = makeSegmentMap(xlims, ylims);
    [S, fmap] = mapMaker(xlims, ylims);
    
    
    
    dt = 0.01;
    
    P0 = diag([0.001, 0.001, 5*pi/180].^2);
    V = diag([0.02, 3*pi/180].^2);% .*dt;
    %W = diag([0.1, 1*pi/180].^2);
    
    
    rob = DifferentialRobot('Vr', V, 'maxwspeed', 5, 'alphalim', 2*pi);
    ekfDR = EKFSLAM(rob, FeatureMap(), P0);
    
    fmap = FeatureMap();    
    ekf = EKFSLAM(rob, fmap, P0);
    ekf.estimateMap = true;
    
    
    vlid = VirtualLidar(S);
    vlid.validRange = [0 5];
     % Landmar Extractor
    ext = FeatureExtractor();
    ext.validRange =  [0 5];
    ext.maxClusterDist = 0.3;
    ext.splitDist = 0.15;
    ext.maxOutliers = 3;
    
%     for s = S
%        sf = SegmentFeature([s.rho, s.theta, s.sd s.ed], diag([0.01, 1*pi/180]));
%        fmap.addFeature(sf);
%     end
    
    f = figure('MenuBar', 'none', 'Name', 'Virtual SLAM');
    whitebg(f,[0.2 0.2 0.2]);
    set(f, 'renderer', 'opengl');
    set(f,'DefaultLineLineSmoothing','on');
    set(f,'DefaultPatchLineSmoothing','on');
    
    h = subplot(1,3, [2 3]);
    mapAxes = MapAxes('Parent', f, 'hAxes', h);
    set(f, 'WindowButtonDownFcn', @click);
    set(f, 'WindowButtonMotionFcn', @motion);
    set(mapAxes.hAxes, 'XLim', xlims + [-1 1], 'YLim', ylims + [-1 1]);
    
    h = subplot(4,3, 1);
    xErrorAxes = SignalScopeAxes('Parent', f, 'hAxes', h);
    
    h = subplot(4,3, 4);
    yErrorAxes = SignalScopeAxes('Parent', f, 'hAxes', h);
    
    h = subplot(4,3, 7);
    thErrorAxes = SignalScopeAxes('Parent', f, 'hAxes', h);
    
    h = subplot(4,3, 10);
    PAxes = handle(imshow(ekf.P, [], 'Parent', h));
    
    mapAxes.drawSegments('Walls', S, [0 0 0.9], 1, '-');
    
    
    
    
        
    p = [];
    out = [];
    goals = [];
    currentGoal = 1;
    step = 0;
    simtime = 0;
    

    if nargin < 2
        fps = 10;
    end
    if nargin >= 1
        opengl('software')
        saveVideo = true;
        M = [];
        pause(0.00001);
        set(get(handle(f),'JavaFrame'),'Maximized',1);
    else
        saveVideo = false;
    end
    
    itsPlottingTime = false;
    plotTimer = timer('Name', 'PlotTimer', ...
        'ExecutionMode', 'fixedRate', ...
        'BusyMode', 'drop', ...
        'Period', 1/fps, ...
        'StartDelay', 0.5, ...
        'TimerFcn', @ticTimer);
    %start(plotTimer);
    timeToPlot = 0;
    while ishandle(f)
        tic;
        step = step + 1;
        simtime = simtime + dt;
        timeToPlot = timeToPlot + dt;
                        
        % Compute contol and move robot 
        xv = rob.Xr(1:3);
        if ~isempty(goals)
            goal = goals(:,currentGoal)';
            dist = pdist2(xv(1:2)', goal);
            
            if (size(goals, 2) == 1 && dist > 0.1) || dist > 0.2            
                goal_heading = atan2(goal(2)-xv(2), goal(1)-xv(1));
                steer = angdiff(goal_heading, xv(3));
                if abs(steer) > pi/8
                    speed = 1;
                    steer = 2*pi*sign(steer);
                else
                    speed = 2;
                    steer = steer * 3;
                end
                
                steer = steer + rand - 0.5;
                
                odo = rob.updateNoisy(speed, steer, dt);
                
                ekf.prediction(odo);
                ekfDR.prediction(odo);
                
            elseif size(goals, 2) == 1
                beep;
                goals = [];
                mapAxes.erase('goal1');
            else
                beep;
                if ~isempty(goals)
                   currentGoal =  mod(currentGoal, size(goals, 2))+1;
                end
            end
        end
        

        
        % Simulate lidar data
        xv = ekf.X(1:3);
        if mod(step, 50) == 0
            [r, a] = vlid.getScan(rob.Xr(1), rob.Xr(2), rob.Xr(3)*180/pi);
            valid = find(r > 0);
            th = xv(3)*180/pi;
            x = xv(1) + r(valid) .* cosd(a(valid) + th);
            y = xv(2) + r(valid) .* sind(a(valid) + th);
            p = [x;y];
            ext.extract(r, a, p);
            out = ext.output;
%             for sf = out.segmentFeatures
%                ekf.innovation(sf); 
%             end
%             for corner = out.corners
%                 ekf.innovation(corner);
%             end
            
        end

%         if itsPlottingTime
%            itsPlottingTime = false;
%            coolDrawer();
%         end
        if timeToPlot > 0.1
           timeToPlot = 0;
           coolDrawer(); 
        end
        
        tpause = dt-toc;
        if tpause > 0
            pause(tpause)
        end

    end
    stop(plotTimer);
    delete(plotTimer);
    if saveVideo
        
        movie2avi(M, filename, 'compression', 'None', 'fps', length(M)/simtime);
        simData.video = M;
    end
    
    simData.rob = rob;
    simData.map = fmap;
    simData.ekf = ekf;
    
    
    function click(src, ~)
        type = get(src, 'SelectionType');
        point = get(mapAxes.hAxes, 'currentpoint');
        switch type
            case 'normal'
                goals = [goals point(1,1:2)'];
            case 'alt'
                for j = 1:size(goals,2)
                    mapAxes.erase(['goal' num2str(j)]);
                end
                currentGoal = 1;
                goals = point(1,1:2)';
        end 
    end

    function motion(~, ~)
        if strcmp(get(f,'SelectionType'), 'open') && size(goals,2) < 2 
            point = get(mapAxes.hAxes, 'currentpoint');
            currentGoal = 1;
            goals = point(1,1:2)';
        end
    end

    function ticTimer(~, ~, ~)
       itsPlottingTime = true; 
    end

    function coolDrawer()
%         try 
            mapAxes.writeText('time', [0, 1], num2str(simtime), [0 0 0]);

            for i = 1:size(goals,2)
                if i == currentGoal
                    mapAxes.drawGoal(['goal' num2str(i)], goals(:,i)', 0.5, [0 1 0], 1, 20);
                else
                    mapAxes.drawGoal(['goal' num2str(i)], goals(:,i)', 0.5, [0 0.7 0.3], 0.5, 10); 
                end
            end

            if ~isempty(out)
                LSF = [];
                    for sf = ext.output.segmentFeatures

                        LSF = [LSF SegmentFeature(sf.g(rob.Xr), diag([0.01, 1*pi/180]))];
                    end
                mapAxes.drawSegmentFeature('Lines',LSF, [1 0 0]);
                mapAxes.drawHough('SegmentH', LSF, rob.Xr, [1 0 1], 1, '--');
            end
            %mapAxes.drawLandmark('Corners', out.corners, [1 1 0]);

            %mapAxes.drawLandmark('Lands', fmap.features, [0 1 0]);
            mapAxes.drawCornerFeatures('Corners', fmap.corners, [0 1 0]);
            mapAxes.drawSegmentFeature('SegmentFeature', fmap.segments, [0 1 0]);
            
            
            mapAxes.drawRobot('rob', rob.Xr, rob.S, [1 0 0]);
            mapAxes.drawTrace('robT', rob.Xr_hist(max(end-traceLength,1):end,:), [1 0 0], 1,  '-');

            mapAxes.drawRobot('ekf', ekf.X(1:3), rob.S, [0 1 1]);
            mapAxes.drawRobot('ekfDR', ekfDR.X(1:3), rob.S, [1 1 0]);
            if ~isempty(ekf.history)
                ekf_hist = [ekf.history.Xr]';
                mapAxes.drawTrace('ekfT', ekf_hist(max(end-traceLength,1):end,:), [0 1 1], 1,  '-');
            end
            if ~isempty(ekfDR.history)
                ekf_hist = [ekfDR.history.Xr]';
                mapAxes.drawTrace('ekfDRT', ekf_hist(max(end-traceLength,1):end,:), [1 1 0], 1,  '-');
            end
            mapAxes.drawErrorXY('ekfPxy', ekf.X(1:3), ekf.P(1:2,1:2), [1 0 1], 0.3);
            mapAxes.drawErrorAngle('ekfPth', ekf.X(1:3), ekf.P(3,3), [1 1 0], 0.5);
            
            

            %xErrorAxes.addScalarSignal('x_est', ekf.X(1), time, [1 0 0]);
            xErrorAxes.addGausianSignal('x_cov', 0, sqrt(ekf.P(1,1)), simtime, [1 0 0], 0.5);
            
            %yErrorAxes.addScalarSignal('x_est', ekf.X(2), time, [0 1 0]);
            yErrorAxes.addGausianSignal('x_cov', 0, sqrt(ekf.P(2,2)), simtime, [0 1 0], 0.5);
            
            %thErrorAxes.addScalarSignal('x_est', ekf.X(2), time, [1 1 0]);
            thErrorAxes.addGausianSignal('x_cov', 0, sqrt(ekf.P(3,3)), simtime, [1 1 0], 0.5);


            
            pp = [xv(1:2) p xv(1:2)];
            mapAxes.drawScannedArea('Scan', pp, [0 0.7 0.7], 0.5);
            
            handle(imshow(ekf.P, [], 'Parent', h));
%             PAxes.XData = [1 size(ekf.P,1)];
%             PAxes.YData = [1 size(ekf.P,1)];
%             PAxes.CData = ekf.P;
            
            drawnow;
            if saveVideo && ishandle(f)
                try
                    %writeVideo(writerObj, getframe(f));
                    M = [M getframe(f)];
                catch
                    
                end
            end
%         catch exception
%                 
%                 stop(plotTimer);
%                 error(exception.getReport);
%         end
    end
    
end





