classdef (Sealed) LandmarkExtractionGUI < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        fig         % the windows itself
        lid
        range
        angle
        ext
        logType
        radar
        
        working
    end
    
    

    
    properties (Access = public) % Public for debug       
        plots       % map, lidar, ...

        icons       % png icons
        toolbar     % toolbar itself and his buttons

        controls    % buttons, sliders, ...

        layout      % panels, tabpanels, ...
        settings    % persistent settings

    end
    
    
    methods (Static)
        function instance = GUI()
            persistent singleton
            if isempty(singleton) || ~isvalid(singleton)
                singleton = LandmarkExtractionGUI();
            end
            instance = singleton;
            instance.show();
        end
    end
    
    methods (Access = private)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% GUI Initializations
        function gui = LandmarkExtractionGUI()
            gui.working = false;
            gui.lid = RPLIDAR();
            gui.ext = LandmarkExtractor();
            
            
            % Load icons
            gui.icons.log = iconRead('log.png');

            % Create the figure
            gui.fig = figure('Visible', 'on', ...
                'name', 'LandmarkExtraction', ...
                'NumberTitle', 'off', ...
                'DockControls', 'off', ...
                'toolbar', 'auto', ...
                'MenuBar', 'none', ...
                'CloseRequestFcn', @gui.close_Callback);
            
            % Antialiasing mode with OpenGL (all the graphics are nicer)
            set(gui.fig, 'renderer', 'opengl');
            set(gui.fig,'DefaultLineLineSmoothing','on');
            set(gui.fig,'DefaultPatchLineSmoothing','on');
          
            gui.initToolbar();
            
            % Create the main layout
            gui.layout.background = uiextras.VBox('Parent', gui.fig);
            gui.layout.main = uiextras.HBoxFlex('Parent', gui.layout.background);
            gui.controls.slider = uicontrol('Parent', gui.layout.background, ...
                'Style', 'slider', ...
                'callback', @gui.moveSlider_Callback);
     
            set(gui.layout.background, 'Sizes', [-1 17]);
            gui.radar = RadarAxes('Parent', gui.layout.main, 'backColor', [0 0 0]);
            gui.controls.settings = uiextras.Grid('Parent', gui.layout.main);

            %gui.layout.tabpanel = uiextras.TabPanel('Parent', gui.layout.main);
            %Set the width of the left column (lidar plot and info box) and map
            set( gui.layout.main, 'Sizes', [-1.5 -1], 'Spacing', 6 );
            
            cs = gui.controls.settings;
            gui.controls.validRangeMin = LandmarkExtractionGUI.textBoxRow(cs, 'Valid Range Min', {@gui.checkNumber_Callback, [0.01 Inf]});
            gui.controls.validRangeMax = LandmarkExtractionGUI.textBoxRow(cs, 'Valid Range Max', {@gui.checkNumber_Callback, [0 Inf]});
            gui.controls.maxClusterDist = LandmarkExtractionGUI.textBoxRow(cs, 'maxClusterDist', {@gui.checkNumber_Callback, [0 Inf]});
            gui.controls.minClusterPoints = LandmarkExtractionGUI.textBoxRow(cs, 'minClusterPoints', {@gui.checkNumber_Callback, [3 Inf]});
            gui.controls.splitDist = LandmarkExtractionGUI.textBoxRow(cs, 'splitDist', {@gui.checkNumber_Callback, [0.01 Inf]});
            gui.controls.deadZoneAngle = LandmarkExtractionGUI.textBoxRow(cs, 'deadZoneAngle', {@gui.checkNumber_Callback, [0 180]});
            gui.controls.collinearityThresh = LandmarkExtractionGUI.textBoxRow(cs, 'collinearityThresh', {@gui.checkNumber_Callback, [0 Inf]});
            gui.controls.lengthSegmentThresh = LandmarkExtractionGUI.textBoxRow(cs, 'lengthSegmentThresh', {@gui.checkNumber_Callback, [0 Inf]});
            
            gui.controls.plotLandmarkCorner = LandmarkExtractionGUI.checkBoxRow(cs, 'Plot corner landmarks', @gui.checkboxToggled_Callback);
            gui.controls.plotLandmarkOclusor = LandmarkExtractionGUI.checkBoxRow(cs, 'Plot oclusor landmarks', @gui.checkboxToggled_Callback);
            gui.controls.plotLines = LandmarkExtractionGUI.checkBoxRow(cs, 'Plot lines', @gui.checkboxToggled_Callback);
            gui.controls.plotSegments = LandmarkExtractionGUI.checkBoxRow(cs, 'Plot segments', @gui.checkboxToggled_Callback);
            gui.controls.plotArea = LandmarkExtractionGUI.checkBoxRow(cs, 'Plot area', @gui.checkboxToggled_Callback);
            gui.controls.plotPoints = LandmarkExtractionGUI.checkBoxRow(cs, 'Plot points', @gui.checkboxToggled_Callback);
            gui.controls.plotRays = LandmarkExtractionGUI.checkBoxRow(cs, 'Plot rays', @gui.checkboxToggled_Callback);
            gui.controls.plotValids = LandmarkExtractionGUI.checkBoxRow(cs, 'Plot valid data', @gui.checkboxToggled_Callback);
            gui.controls.plotOutRange = LandmarkExtractionGUI.checkBoxRow(cs, 'Plot outrange data', @gui.checkboxToggled_Callback);
            gui.controls.plotDeadZone = LandmarkExtractionGUI.checkBoxRow(cs, 'Plot deadZone data', @gui.checkboxToggled_Callback);
            gui.controls.plotOutlier = LandmarkExtractionGUI.checkBoxRow(cs, 'Plot outlier data', @gui.checkboxToggled_Callback);
            
            nc = numel(get(cs, 'Children'));
            set(cs, 'RowSizes', ones(nc,1)*40);
            
            
            %Load settings
            try 
                s = load(fullfile(parentpath(mfilename('fullpath')), 'settingsLE.mat'));
                gui.settings.path.loadLog = s.loadPath;
                gui.controls.validRangeMin.Value = s.validRange(1);
                gui.controls.validRangeMax.Value = s.validRange(2);
                gui.controls.maxClusterDist.Value = s.maxClusterDist;
                gui.controls.minClusterPoints.Value = s.minClusterPoints;
                gui.controls.splitDist.Value = s.splitDist;
                gui.controls.deadZoneAngle.Value = s.deadZoneAngle;
                gui.controls.collinearityThresh.Value = s.collinearityThresh;
                gui.controls.lengthSegmentThresh.Value = s.lengthSegmentThresh;
                
                
            catch
               disp('Error loading settigs.');
               gui.settings.path.loadLog = cd;
               gui.controls.validRangeMax.Value = 6;
               gui.controls.validRangeMin.Value = 0.01;
               gui.controls.maxClusterDist.Value = 0.3;
               gui.controls.minClusterPoints.Value = 3;
               gui.controls.splitDist.Value = 0.3;
               gui.controls.deadZoneAngle.Value = 0;
               gui.controls.collinearityThresh.Value = 0.5;
               gui.controls.lengthSegmentThresh.Value = 0.5;
            end
            
             gui.controls.validRangeMax.String  = gui.controls.validRangeMax.Value;
             gui.controls.validRangeMin.String = gui.controls.validRangeMin.Value;
             gui.controls.maxClusterDist.String = gui.controls.maxClusterDist.Value;
             gui.controls.minClusterPoints.String = gui.controls.minClusterPoints.Value;
             gui.controls.splitDist.String = gui.controls.splitDist.Value;
             gui.controls.deadZoneAngle.String = gui.controls.deadZoneAngle.Value;
             gui.controls.collinearityThresh.String = gui.controls.collinearityThresh.Value;
             gui.controls.lengthSegmentThresh.String = gui.controls.lengthSegmentThresh.Value;
            % Set visible the figure

            gui.show();
        end
        
  
        
        function initToolbar(gui)
            gui.toolbar.bar = uitoolbar(gui.fig);

            % Load log button
            gui.toolbar.loadLog = uipushtool(gui.toolbar.bar, ...
                'CData', gui.icons.log,...
                'TooltipString','Load a datalog',...
                'HandleVisibility','off', ...
                'ClickedCallback', @gui.loadLog_Callback);
        end
        

        function initSlider(gui, endTime, dt)
            step = dt/endTime;
            set(gui.controls.slider, 'value', 0, ...
                'max', endTime, ...
                'SliderStep', [step step]);
        end
        

        function type = getLogType(gui, s) 
            if isfield(s, 'pose')   && ...
               isfield(s, 'rph')    && ...
               isfield(s, 'range')  && ...
               isfield(s, 'angle')
                type = 'rplidar';
            elseif isfield(s, 'pose')   && ...
                   isfield(s, 'drpm')   && ...
                   isfield(s, 'range')  && ...
                   isfield(s, 'imu')    && ...
                   isfield(s, 'forces')
               type = 'hokuyo';
            else
                type = 'unknown';
            end
        end
        
        function loadLog(gui, file)
            try
                s = load(file);
                gui.logType = gui.getLogType(s);               
                if ~strcmp(gui.logType, 'unknown');
                    switch gui.logType
                        case 'rplidar'
                            gui.range = s.range;
                            gui.angle = s.angle;                           
                        case 'hokuyo'
                            gui.range = s.range;
                            gui.angle = ((0.3515625 *((1:682) - 1)) - 120);
                    end                    
                    gui.initSlider(size(gui.range.Data,1)-1, 1);
                else
                     errordlg('Unknown format data', 'Error');
                end               
            catch
                errordlg('Problem loading the log', 'Error');
            end
        end
        
        function doHardWork(gui)
            if isempty(gui.range)
               return; 
            end
            if gui.working
               return; 
            end
            
            gui.working = true;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Get objects
            ext = gui.ext;
            lid = gui.lid;
            ptr = gui.radar.plotter;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Copy parameters from the GUI
            validRange = [gui.controls.validRangeMin.Value gui.controls.validRangeMax.Value];
            maxClusterDist = gui.controls.maxClusterDist.Value;
            minClusterPoints = gui.controls.minClusterPoints.Value;
            splitDist = gui.controls.splitDist.Value;
            deadZoneAngle = gui.controls.deadZoneAngle.Value;
            collinearityThresh = gui.controls.collinearityThresh.Value;
            lengthSegmentThresh = gui.controls.lengthSegmentThresh.Value;
            maxOutliers = 1;
            
            ext.validRange = [gui.controls.validRangeMin.Value gui.controls.validRangeMax.Value];
            ext.maxClusterDist = gui.controls.maxClusterDist.Value;
            ext.minClusterPoints = gui.controls.minClusterPoints.Value;
            ext.splitDist = gui.controls.splitDist.Value;
            ext.deadZoneAngle = gui.controls.deadZoneAngle.Value;
            ext.collinearityThresh = gui.controls.collinearityThresh.Value;
            ext.lengthSegmentThresh = gui.controls.lengthSegmentThresh.Value;
            ext.maxOutliers = 1;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %% Get the scan at current slider value
            i = floor(get(gui.controls.slider, 'value')) + 1;          
            switch gui.logType
                case 'rplidar'
                    r = double(gui.range.Data(i,:))/1000.0;
                    a = double(gui.angle.Data(i,:));
                    
                case 'hokuyo'
                    r = double(gui.range.Data(i,:))/1000.0;
                    a = double(gui.angle);
            end
            
            %% Drop invalid data
            s = length(a);
            while s > 1 && a(s) == 0
               s = s-1; 
            end
            if (s == 1)
               gui.working = false;
               return;
            end
            r = r(1:s);
            a = a(1:s);
            
            %% Set points at 0 to Inf
            r(r==0 | r>6) = 6;
            gui.lid.setScan(r,a);
            
            lans = ext.extract(lid);
            res = ext.output;
%             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             %% Preproces
% 
%             %% Find points in dead zone (behind iwalker)
%             deadZone = lid.ang > 180-deadZoneAngle/2 & lid.ang < 180+deadZoneAngle/2;
%             pDeadZone = lid.p(:,deadZone);
%             p = lid.p(:, ~deadZone);
%             r = r(~deadZone);
%             a = a(~deadZone);
%             
%             %% Find outliers
%             pd = pdist2next(p);
%             outlier = false(size(pd));
%             for i = 2:length(outlier)-1
%                 outlier(i) = pd(i-1) > maxClusterDist && pd(i) > maxClusterDist;
%             end
%             pOutlier = p(:, outlier);
%             p = p(:, ~outlier);
%             r = r(~outlier);
%             a = a(~outlier); 
%                        
            %% Find Oclusor points
%             olans = [];
%             pd = pdist2next(p);
%             oclusor2 =  false(size(pd));
%             for i = 1:length(pd)-1
%                 if pd(i) > maxClusterDist && abs(angdiffd(a(i),a(i+1))) < 5
%                    if  r(i) < r(i+1)
%                        oclusor2(i) = true;
%                    else
%                        oclusor2(i+1) = true;
%                    end
%                 end
%             end
%             for i = find(oclusor2 == true)
%                     olans = [olans Landmark(p(:,i),2)];
%             end
            
            
%             %% Find points too near or too far
%             outRange = r < validRange(1) | r > validRange(2);
%             pOutRange = p(:,outRange);
%             %p = p(:, ~outRange);
%             %r = r(~outRange);
%             %a = a(~outRange); 
%             
%             
%             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             %% Line extraction   
%             %% Clusterize
%             C = clusterize(p,r,a, validRange, maxClusterDist);
%             
%          
%             oclusor = false(1,length(p));
%             %% Split and Merge
%             LL = []; %
%             VV = [];
%             for i = 1: length(C) 
%                 cl = C{i};
%                 n = cl.end - cl.start;
%                 if n > minClusterPoints && ~cl.outOfRange
%                     oclusor(cl.start) = cl.startOclusor;
%                     oclusor(cl.end) = cl.endOclusor;
% %                     if cl.startOclusor
% %                         olansS = [olansS Landmark(p(:,cl.start),2)];
% %                     end
% %                     if cl.endOclusor
% %                         olansE = [olansE Landmark(p(:,cl.end),2)];
% %                     end
%                    pp = p(:, cl.start:cl.end);
%                    [L, V]= splitAndMerge(pp, splitDist, maxOutliers);
%                    % Add index offset
%                     offset = cl.start - 1;
%                     L = L + offset;
%                     V = V + offset;
% 
%                     LL = [LL L];
%                     VV = [VV V];
%                end
%             end
% 
%             olans = [];
%             %% Fit segments
%             segs = [];
%             for i = 1:size(LL,2)
%                 if LL(2,i) - LL(1, i) > 2    
%                     pl = p(:, LL(1, i):LL(2,i));
%                     s = Segment(pl);
%                     if s.d > lengthSegmentThresh
%                         if oclusor(LL(1,i))
%                             s.aOclusor = true;
%                             olans = [olans Landmark(s.a,2)];
%                         end
%                         if oclusor(LL(2,i))
%                             s.bOclusor = true;
%                             olans = [olans Landmark(s.b,2)];
%                         end
%                         segs = [segs s];
%                     end
%                 end
%             end
%             
%             %% Agroup segment in lines
%             agrouped = false(1,length(segs));
%             seglins = [];
%             for i = 1:length(segs)
%                if ~agrouped(i)
%                   group = i;
%                   agrouped(i) = true;
%                   for j = i+1:length(segs)
%                      if ~agrouped(j)
%                         if collinearity(segs(i), segs(j)) < collinearityThresh
%                            agrouped(j) = true;
%                            group = [group j];
%                         end
%                      end
%                   end
%                   seglins = [seglins SegmentedLine(segs(group))];
%                end
%             end
%             
%             %% Construct Landmarks
%             q = [];
%             f = [];
%             vlans = [];
%             elans = [];
%             clans = [];
% %             for i = 1:length(segs)
% %                 for j = i+1:length(segs)
% %                     k = segs(i).perpendicularity(segs(j));
% %                     if k > 0.5
% %                         %TODO: implement SegmentedLine.interesections !
% %                         [qq, ff] = segs(i).interesection(segs(j));
% %                         if ff == 1 % virtual landmark
% %                             %vlans = [vlans Landmark(qq, 3)];
% %                         elseif ff == 2
% %                            % elans = [elans Landmark(qq, 2)];
% %                         elseif ff == 3 % corner landmark
% %                             clans = [clans Landmark(qq, 1)];
% %                         end
% %                         q = [q qq];
% %                         f = [f ff];
% %                     end
% %                 end
% %             end
%             for i = 1:length(seglins)
%                 for j = i+1:length(seglins)
%                     k = seglins(i).perpendicularity(seglins(j));
%                     if k > 0.5
%                         %TODO: implement SegmentedLine.interesections !
%                         [qq, ff] = seglins(i).interesection(seglins(j));
%                         if ff == 1 % virtual landmark
%                             %vlans = [vlans Landmark(qq, 3)];
%                         elseif ff == 2
%                            % elans = [elans Landmark(qq, 2)];
%                         elseif ff == 3 % corner landmark
%                             clans = [clans Landmark(qq, 1)];
%                         end
%                         q = [q qq];
%                         f = [f ff];
%                     end
%                 end
%             end
            
            
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if get(gui.controls.plotArea, 'value')
                ptr.plotScanArea(lid.p(1,:), lid.p(2,:), 'scan', [0 0.8 0.4], 0.7);
            else
                ptr.plotScanArea([],[], 'scan', [0 0.8 0.4], 0.7);
            end
            
            if get(gui.controls.plotLines, 'value')
                ptr.plotSegmentedLines(res.lines, 'lines');
            else
                ptr.plotSegmentedLines([], 'lines');
            end
            if get(gui.controls.plotSegments, 'value')
                ptr.plotSegments(res.segments, 'segments');
            else
               ptr.plotSegments([], 'segments');
            end

          
            % Scan points
            if get(gui.controls.plotPoints, 'value') && get(gui.controls.plotValids, 'value')
                ptr.plotPoints(res.p(1,:), res.p(2,:), 'points.inRange', [0 1 1], 10, '.');
            else
                ptr.plotPoints([], [], 'points.inRange', [0 1 1], 10, '.');
            end
            if get(gui.controls.plotPoints, 'value') && get(gui.controls.plotOutRange, 'value')
                ptr.plotPoints(res.pOutRange(1,:), res.pOutRange(2,:), 'points.outRange', [1 0 1], 10, '^');
            else
                ptr.plotPoints([], [], 'points.outRange', [0 1 1], 10, '.');
            end
            if get(gui.controls.plotPoints, 'value') && get(gui.controls.plotOutlier, 'value')
                ptr.plotPoints(res.pOutlier(1,:), res.pOutlier(2,:), 'points.outlier', [1 1 0], 10, '+');
            else
                ptr.plotPoints([], [], 'points.outlier', [0 1 1], 10, '.');
            end
            if get(gui.controls.plotPoints, 'value') && get(gui.controls.plotDeadZone, 'value')
                ptr.plotPoints(res.pDeadZone(1,:), res.pDeadZone(2,:), 'points.deadZone', [0.2 0.2 0.2], 10, 'x');
            else
                ptr.plotPoints([], [], 'points.deadZone', [0 1 1], 10, '.');
            end
                
            if get(gui.controls.plotRays, 'value') && get(gui.controls.plotValids, 'value')
                ptr.plotRays([0 0], res.p(1,:), res.p(2,:), 'rays.inRange', [0 1 1]./2, 0.5, '-');
            else
               ptr.plotRays([0 0], [], [], 'rays.inRange', [0 1 1]./2, 0.5, '-');
            end
            if get(gui.controls.plotRays, 'value') && get(gui.controls.plotOutRange, 'value')
               ptr.plotRays([0 0], res.pOutRange(1,:), res.pOutRange(2,:), 'rays.outRange', [1 0 0]./2, 0.5, '-');
            else
                ptr.plotRays([0 0], [], [], 'rays.outRange', [0 1 1]./2, 0.5, '-');
            end
            if get(gui.controls.plotRays, 'value') && get(gui.controls.plotOutlier, 'value')
                ptr.plotRays([0 0], res.pOutlier(1,:), res.pOutlier(2,:), 'rays.outlier', [1 1 0]./2, 0.5, '-');
            else
                ptr.plotRays([0 0], [], [], 'rays.outlier', [0 1 1]./2, 0.5, '-');
            end
            if get(gui.controls.plotRays, 'value') && get(gui.controls.plotDeadZone, 'value')
                ptr.plotRays([0 0], res.pDeadZone(1,:), res.pDeadZone(2,:), 'rays.deadZone', [0.2 0.2 0.2], 0.5, '-');
            else
               ptr.plotRays([0 0], [], [], 'rays.deadZone', [0 1 1]./2, 0.5, '-');
            end    
               
            if get(gui.controls.plotLandmarkCorner, 'value')
                ptr.plotAnonymousLandmarks(lans, 'cornerLandmarks', [0.8 0 0.8], true);
            else
               ptr.plotAnonymousLandmarks([], 'cornerLandmarks', [0.8 0 0.8], true);
            end

            % Landmarks
            %ptr.plotAnonymousLandmarks(vlans, 'virtualLandmarks', [0 0.2 0.8], true);
            %ptr.plotAnonymousLandmarks(elans, 'endpointsLandmarks', [0.8 0 0.8], true);
            %ptr.plotAnonymousLandmarks(lans, 'cornerLandmarks', [0.8 0 0.8], true);
           % ptr.plotAnonymousLandmarks(olans, 'oclusorLandmarks', [0 0.8 0.3], true);

            gui.working = false;
        end
     
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Callbacks
        
        % Figure callbacks %
        function close_Callback(gui, src, event)
            try 
                s.loadPath = gui.settings.path.loadLog;
                s.validRange = [gui.controls.validRangeMin.Value gui.controls.validRangeMax.Value];
                s.maxClusterDist = gui.controls.maxClusterDist.Value;
                s.minClusterPoints = gui.controls.minClusterPoints.Value;
                s.splitDist = gui.controls.splitDist.Value;
                s.deadZoneAngle = gui.controls.deadZoneAngle.Value;
                s.collinearityThresh = gui.controls.collinearityThresh.Value;
                s.lengthSegmentThresh = gui.controls.lengthSegmentThresh.Value;
                s.maxOutliers = 3;
                save(fullfile(parentpath(mfilename('fullpath')), 'settingsLE.mat'), '-struct', 's');
            catch
               disp('Error saving settigs.'); 
            end
            
            delete(gui.fig);
            delete(gui);
        end
        
        
        function loadLog_Callback(gui, src, event)
            path = gui.settings.path.loadLog;
            [file, path] = uigetfile('*.mat', 'Load datalog', path);
            if path ~= 0
                gui.settings.path.loadLog = path;
                gui.loadLog(file);
            end
        end
        

        % Controls callbaks %
        function moveSlider_Callback(gui, src, event)
            n = floor(get(src, 'value'));        
            set(src,'value', n);
            ct = num2str(n);
            set(src, 'TooltipString', ct);
            gui.doHardWork();
        end
        
        function checkNumber_Callback(gui, src, event, range) 
            num = str2double(get(src, 'String'));
            if isempty(num) || num < range(1) || num > range(2)
                set(src, 'String', get(src, 'Value'));
            else
                set(src, 'Value', num);
            end
            gui.doHardWork();
        end
        
        function checkboxToggled_Callback(gui,src, event)
            gui.doHardWork();
        end
        
  
    end
    
    methods (Access = public)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Public GUI methods
        function show(gui)
            set(gui.fig, 'Visible', 'on');
        end
    end
    
    methods (Access = private, Static)
        function h = checkBoxRow(parent, text, callback)
            row = uiextras.HButtonBox('Parent', parent);
            row.HorizontalAlignment = 'left';
            row.VerticalAlignment = 'middle';
            uicontrol('Parent', row, ...
                'Style', 'text', ...
                'String', text);
            h = uicontrol('Parent', row, ...
                'Style', 'checkbox', ...
                'Value', 1, ...
                'Callback', callback);
            h = handle(h);
        end
        
        function h = textBoxRow(parent, text, callback)
            row = uiextras.HButtonBox('Parent', parent);
            row.HorizontalAlignment = 'left';
            row.VerticalAlignment = 'middle';
            uicontrol('Parent', row, ...
                'Style', 'text', ...
                'String', text);
            h  = uicontrol('Parent', row, ...
                'Style', 'edit', ...
                'String', '0', ...
                'Value', 0, ...
                'BackgroundColor','white', ...
                'Callback', callback);
            h = handle(h);
        end
    end
    
end



