classdef (Sealed) iWalkerSLAM < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        fig         % the windows itself
        sim         % EngineSimulator
        dlog        % DataLog
        iwalker     % iWalker Interface
    end
    
    
    properties (Constant)
        %% Enumerations (native enumerations matlab's are crap)
        STATUS = struct(...
            'STARTING',             1, ...
            'LOG_LOAD',             2, ...
            'LOG_READY',            3, ...
            'LOG_RUNNING',          4, ...
            'LOG_SIMULATE',         6, ...
            'IWK_NOT_CONNECTED',    7, ...
            'IWK_CONNECTED',        8, ...
            'IWK_RUNNING',          9, ...
            'BUSY',                 10);
        
        MODE =   struct(...
            'ONLINE',   1, ...
            'OFFLINE',  2);
        
        COLOR = struct(...
            'RUNNING',  [0.65	0.85	0.20], ...
            'READY',    [0.25	0.40	0.89], ...
            'UNREADY',  [1.00	0.27    0.20], ...
            'Valid',    [0.00   1.00    1.00], ...
            'OutRange', [0.80   0.00    0.00], ...
            'DeadAngle',[0.30   0.30    0.30], ...
            'Outlier',  [1.00   1.00    0.00], ...
            'Landmark', [0.00   0.00    0.80], ...
            'Robot',    [1.00   0.00    0.00], ...
            'Trace',    [1.00   0.00    0.00],  ...
            'Segment',  [1.00   0.00    0.00] ...
                );
        
        
    end
    
    properties (Access = public) % Public for debug
        plots       % map, lidar, ...
        state       % current state of the gui
        icons       % png icons
        toolbar     % toolbar itself and his buttons
        statusbar   % statusbar itself and his info
        controls    % buttons, sliders, ...
        info        % status, notifications, ...
        layout      % panels, tabpanels, ...
        settings    % persistent settings
        settingsPath
        timers      % for plots, adquisition, ...
        eh
        zoomTool
        
        % Flags
        logSaved    % true if last log was saved
        redrawScan  % true if there is new lidar data to plot
        simulating  % true if simulating
        stopCmd     % true for stop play in log mode
        lockSlider  % true to lock slider functions
        followRobot % true to follow robot
        textMap     % true to info on map plot
    end
    
    
    methods (Static)
        function instance = GUI()
            persistent singleton
            if isempty(singleton) || ~isvalid(singleton)
                singleton = iWalkerSLAM();
            end
            instance = singleton;
            instance.show();
        end
    end
    
    methods (Access = public)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% GUI Initializations
        function this = iWalkerSLAM()          
            % Load icons
            this.icons.iwalker = iconRead('walker.png');
            this.icons.laptop = iconRead('laptop.png');
            this.icons.play = iconRead('play.png');
            this.icons.stop = iconRead('stop.png');
            this.icons.log = iconRead('log.png');
            this.icons.zoom = iconRead('zoom.png');
            this.icons.settings = iconRead('tools.png');
            this.icons.saveLog = iconRead('save.png');
            this.icons.connect = iconRead('plug-disconnect.png');
            this.icons.disconnect = iconRead('plug-connect.png');
            this.icons.gear = iconRead('gear.png');
            
            % Initialize state
            this.state.mode = this.MODE.ONLINE;
            this.state.status = this.STATUS.LOG_LOAD;
            this.lockSlider = false;
           
            % Create the figure
            this.fig = figure('Visible', 'on', ...
                'name', 'iWalkerSLAM', ...
                'NumberTitle', 'off', ...
                'DockControls', 'off', ...
                'toolbar', 'auto', ...
                'MenuBar', 'none', ...
                'CloseRequestFcn', @this.close_Callback);
            
            % Antialiasing mode with OpenGL (all the graphics are nicer)
            set(this.fig, 'renderer', 'opengl');
            set(this.fig,'DefaultLineLineSmoothing','on');
            set(this.fig,'DefaultPatchLineSmoothing','on');

              
                      
            
            % Create the main layout
            this.layout.background = uiextras.VBox('Parent', this.fig);
            
            this.layout.main = uiextras.HBoxFlex('Parent', this.layout.background);
            
       
            this.controls.slider = handle(uicontrol('Parent', this.layout.background, ... 
                                                    'style', 'slider',...
                                                    'callback', @this.slider_Callback));
            
            this.statusbar.margin(1) = uiextras.Empty('Parent', this.layout.background);
            this.statusbar.bar = uiextras.HBox('Parent', this.layout.background);
            this.statusbar.margin(2) =uiextras.Empty('Parent', this.layout.background);           
            this.initStatusbar();
            
            set(this.layout.background, 'Sizes', [-1  20 this.statusbar.marginWidth 15 this.statusbar.marginWidth]);
            
            
            this.layout.leftPanel = uiextras.VBoxFlex('Parent', this.layout.main);
            
            this.plots.radar = RadarAxes('Parent', this.layout.leftPanel);
 
           

%             this.info.table = handle(uitable('Parent', this.layout.leftPanel));
%             this.initInfoTable();
            %uiextras.Empty('Parent', this.layout.leftPanel);
            
            
            set(this.layout.leftPanel, 'Sizes', [-1], 'Spacing', 6);
            this.plots.map = MapAxes('Parent', this.layout.main);
            %gui.layout.tabpanel = uiextras.TabPanel('Parent', gui.layout.main);
            %Set the width of the left column (lidar plot and info box) and map
            set( this.layout.main, 'Sizes', [-1 -1.5], 'Spacing', 6 );
            
            this.initToolbar();
            this.disableToolbar();
            this.setStatus(this.STATUS.BUSY);
            
            this.settingsPath = fullfile(parentpath(mfilename('fullpath')), 'settings.mat');
            this.settings = iSettings(this.settingsPath);
            this.sim = SimulationEngine();
            this.initSimulation();
            
            this.simulating = false;
            this.timers.plot = timer('Name', 'PlotTimer', ...
                'ExecutionMode', 'fixedRate', ...
                'BusyMode', 'drop', ...
                'Period', this.settings.values.Plots_fps, ...
                'TimerFcn', @this.updatePlots_Callback, ...
                'ErrorFcn', @this.errorPlots_Callback);
            
            this.stopCmd = false;
            
            initPlots(this);
            
            % Setup zoom tool
            this.zoomTool = zoom(this.fig);
            this.zoomTool.Enable = 'off';
            this.zoomTool.setAllowAxesZoom(this.plots.radar.hAxes, false);
            this.zoomTool.setAllowAxesZoom(this.plots.map.hAxes, true);
        
            this.followRobot = false;
            this.textMap = false;
            % Set initial status
            this.logSaved = true;
            
                  
            % Enable keypress and mouse scroll
            set(this.fig, 'WindowKeyPressFcn', @this.keyPress_Callback);
            set(this.fig, 'WindowScrollWheelFcn', @this.mouseScroll_Callback);     
            
            % This may not work (uses undocumented java calls). It's not
            % necessary, but it looks nice if it works.
            try
                %pause(0.1);
                % get the java window
                warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
                javaFrame = get(this.fig,'JavaFrame');
                % set a cool custom window icon
                iconpath = [parentpath(parentpath(mfilename('fullpath'))) filesep 'icons' filesep 'slam.gif'];
                javaFrame.setFigureIcon(javax.swing.ImageIcon(iconpath));
                % maximize window
                %javaFrame.setMaximized(true);
            catch
                disp('javaFrame not available');
            end
            
            this.setMode(this.MODE.OFFLINE);
            this.setStatus(this.STATUS.LOG_LOAD);
        end
        
        function initToolbar(this)
            this.toolbar.bar = uitoolbar(this.fig);
            % Settings button
            this.toolbar.settings = uipushtool(this.toolbar.bar, ...
                'CData', this.icons.settings,...
                'TooltipString','Open settings window',...
                'HandleVisibility','off', ...
                'ClickedCallback', @this.settings_Callback);
            % Swap mode button
            this.toolbar.mode = uipushtool(this.toolbar.bar, ...
                'CData', this.icons.iwalker,...
                'TooltipString','Swap source to Log',...
                'HandleVisibility','off', ...
                'ClickedCallback', @this.changeMode_Callback);
            
            % Load log button
            this.toolbar.loadLog = uipushtool(this.toolbar.bar, ...
                'CData', this.icons.log,...
                'TooltipString','Load a datalog',...
                'HandleVisibility','off', ...
                'ClickedCallback', @this.loadLog_Callback);
            
            % Simulate button
            this.toolbar.simulateButton = uipushtool(this.toolbar.bar, ...
                'CData', this.icons.gear,...
                'TooltipString','Simulate log',...
                'HandleVisibility','off', ...
                'ClickedCallback', @this.simulateButton_Callback);
            
            % Connect iwalker button
            this.toolbar.connect = uipushtool(this.toolbar.bar, ...
                'CData', this.icons.connect,...
                'TooltipString','Connect iWalker',...
                'HandleVisibility','off', ...
                'ClickedCallback', @this.connect_Callback);
            
            % Save log button
            this.toolbar.saveLogButton = uipushtool(this.toolbar.bar, ...
                'CData', this.icons.saveLog,...
                'TooltipString','Save log',...
                'HandleVisibility','off', ...
                'ClickedCallback', @this.saveLogButton_Callback);
            
            % Zoom button
            this.toolbar.zoom = uitoggletool(this.toolbar.bar, ...
                'CData', this.icons.zoom,...
                'TooltipString','Zoom In',...
                'HandleVisibility','off', ...
                'ClickedCallback', @this.zoom_Callback);
                          
            % Stop button
            this.toolbar.stopButton = uipushtool(this.toolbar.bar, ...
                'CData', this.icons.stop,...
                'TooltipString','Stop simulation',...
                'HandleVisibility','off', ...
                'ClickedCallback', @this.stopButton_Callback);
            
            % Play button
            this.toolbar.playButton = uipushtool(this.toolbar.bar, ...
                'CData', this.icons.play,...
                'TooltipString','Run simulation',...
                'HandleVisibility','off', ...
                'ClickedCallback', @this.playButton_Callback);             
        end
        
        function initStatusbar(this)
            bar = this.statusbar.bar;
            m = 5;
            this.statusbar.marginWidth = m;
            c = [0.8 0.8 0.8];
            this.statusbar.marginColor = c;
            this.statusbar.margin = [this.statusbar.margin uiextras.Empty('Parent', bar)];% left margin
            
            this.info.status = uicontrol('Parent', bar, ...
                'style', 'text', ...
                'string', 'Status', ...
                'BackgroundColor', [205 205 255]/255);
            this.statusbar.margin = [this.statusbar.margin uiextras.Empty('Parent', bar)];
            this.info.mode = uicontrol('Parent', bar, ...
                'style', 'text', ...
                'string', 'Mode', ...
                'TooltipString', 'Data source', ...
                'BackgroundColor', [1 1 1]);
            this.statusbar.margin = [this.statusbar.margin uiextras.Empty('Parent', bar)];
            this.info.currentTime = uicontrol('Parent', bar, ...
                'style', 'text', ...
                'string', '0.0', ...
                'BackgroundColor', [1 1 1]);
            this.statusbar.margin = [this.statusbar.margin uiextras.Empty('Parent', bar)];
            this.info.endTime = uicontrol('Parent', bar, ...
                'style', 'text', ...
                'string', '0.0', ...
                'BackgroundColor', [1 1 1]);
            this.statusbar.margin = [this.statusbar.margin uiextras.Empty('Parent', bar)]; % fill empty space
            this.statusbar.margin = [this.statusbar.margin uiextras.Empty('Parent', bar)]; % right margin
            set(bar, 'Sizes', [m 100 m 100 m 50 m 50 -1 m] );
            for h = this.statusbar.margin
                set(h, 'BackgroundColor', c);
            end
        end
        
        function initPlots(this)
            if isvalid(this.timers.plot)
                stop(this.timers.plot);
            end
            this.redrawScan = true;
            this.plots.map.init();
            this.plots.map.setImage(this.sim.gmp.image(), this.sim.gmp.R);
            
            this.plots.radar.radius = this.settings.values.Lidar_Horizon;
            this.plots.radar.init();
            this.updatePlots_Callback();
            this.timers.plot.Period =  this.settings.values.Plots_fps;
            %start(this.timers.plot);
        end
        
        
        function initInfoTable(this)
            t = this.info.table;
            t.RowName = [];
            t.ColumnName = [];
            t.ColumnWidth = {200, 30, 30, 30};
            t.Data = {'Pose [x, y, theta]'; ...
                      'Angular Speed [left, right]'};
            t.BackgroundColor = [.4 .4 .4; .4 .4 .8];
            t.ForegroundColor = [1 1 1];
            
            t.Data(1,2:4) = {0, 0, 0};
            t.Data(2,2:3) = {0, 0};
        end
               
        
        function initSimulation(this)
            type = '';
            switch this.state.mode
                case this.MODE.OFFLINE;
                    if ~isempty(this.dlog)
                        if this.settings.values.GridMap_LimitsAuto
                            lims = this.dlog.limits();
                            this.settings.values.GridMap_LimitsMinX = lims(1) - 6;
                            this.settings.values.GridMap_LimitsMaxX = lims(2) + 6;
                            this.settings.values.GridMap_LimitsMinY = lims(1) - 6;
                            this.settings.values.GridMap_LimitsMaxY = lims(2) + 6;
                        end
                        type = this.dlog.type;
                    end
                                      
                case this.MODE.ONLINE
                    type = this.settings.values.Adquisition_walker;
            end
            
            switch type
                case 'iWalkerRoboPeak'
                    this.settings.values.Lidar_x = 0.35;
                case 'iWalkerHokuyo'
                     this.settings.values.Lidar_x = 0.6;
            end
           
            this.sim.settings = this.settings.values;
            this.sim.init();
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% State GUI Management
        function setStatus(this, status)
            this.state.status = status;
            set(this.fig, 'Pointer','arrow');
            this.disableToolbar();
            switch status
                case this.STATUS.LOG_LOAD
                    set(this.info.status, ...
                        'string', 'Load a datalog', ...
                        'backgroundcolor', this.COLOR.UNREADY);   
                    set(this.toolbar.loadLog, 'enable', 'on');
                    set(this.toolbar.settings, 'enable', 'on');
                    set(this.toolbar.mode, 'enable', 'on');
                    set(this.toolbar.zoom, 'enable', 'on');
                    
                case this.STATUS.LOG_READY
                    set(this.info.status, ...
                        'string', 'Ready', ...
                        'backgroundcolor', this.COLOR.READY);
                    set(this.toolbar.playButton, 'enable', 'on');
                    set(this.toolbar.mode, 'enable', 'on');
                    set(this.toolbar.settings, 'enable', 'on');
                    set(this.toolbar.loadLog, 'enable', 'on');
                    set(this.toolbar.zoom, 'enable', 'on');
                    set(this.toolbar.simulateButton, 'enable', 'on');
                    set(this.controls.slider, 'enable', 'on');
                 
                case this.STATUS.LOG_SIMULATE
                    set(this.info.status, ...
                        'string', 'Simulate', ...
                        'backgroundcolor', this.COLOR.READY);
                    set(this.toolbar.mode, 'enable', 'on');
                    set(this.toolbar.settings, 'enable', 'on');
                    set(this.toolbar.loadLog, 'enable', 'on');
                    set(this.toolbar.simulateButton, 'enable', 'on');
                    set(this.toolbar.zoom, 'enable', 'on');
                    
                case this.STATUS.LOG_RUNNING
                    set(this.info.status, ...
                        'string', 'Running', ...
                        'backgroundcolor', this.COLOR.RUNNING);
                    set(this.toolbar.stopButton, 'enable', 'on');
                    set(this.controls.slider, 'enable', 'on');
                    set(this.toolbar.zoom, 'enable', 'on');
                    
                case this.STATUS.IWK_NOT_CONNECTED
                    set(this.info.status, ...
                        'string', 'Connect the lidar', ...
                        'backgroundcolor', this.COLOR.UNREADY);
                    set(this.toolbar.settings, 'enable', 'on');
                    set(this.toolbar.mode, 'enable', 'on');
                    set(this.toolbar.connect, 'enable', 'on');
                    set(this.toolbar.connect, 'CData', this.icons.connect);
                    set(this.toolbar.zoom, 'enable', 'on');
                                      
                case this.STATUS.IWK_CONNECTED
                    set(this.info.status, ...
                        'string', 'Ready', ...
                        'backgroundcolor', this.COLOR.READY);
                    set(this.toolbar.playButton, 'enable', 'on');   
                    set(this.toolbar.connect, 'enable', 'on');
                    set(this.toolbar.connect, 'CData', this.icons.disconnect);
                    set(this.toolbar.saveLogButton, 'enable', 'on');
                    set(this.toolbar.zoom, 'enable', 'on');
                    
                case this.STATUS.IWK_RUNNING
                    set(this.info.status, ...
                        'string', 'Running', ...
                        'backgroundcolor', this.COLOR.RUNNING);
                    
                    set(this.toolbar.stopButton, 'enable', 'on');
                    
                    this.logSaved = false;
                    
                case this.STATUS.BUSY
                    set(this.info.status, ...
                        'string', 'Busy...', ...
                        'backgroundcolor', this.COLOR.UNREADY);
                    set(this.toolbar.playButton, 'CData', this.icons.play);
                    set(this.fig, 'Pointer','watch');
                otherwise
                    error('Not valid status');
            end
        end
        
        function disableToolbar(this)
            set(this.toolbar.settings, 'enable', 'off');
            set(this.toolbar.mode, 'enable', 'off');
            set(this.toolbar.loadLog, 'enable', 'off');
            set(this.toolbar.connect, 'enable', 'off');
            set(this.toolbar.zoom, 'enable', 'off');
            set(this.toolbar.stopButton, 'enable', 'off');
            set(this.toolbar.playButton, 'enable', 'off');
            set(this.toolbar.saveLogButton, 'enable', 'off');
            set(this.toolbar.simulateButton, 'enable', 'off');
            set(this.controls.slider, 'enable', 'off');
        end
        
        function setMode(this, mode)
            switch mode
                case this.MODE.OFFLINE;
                    this.state.mode = mode;
                    set(this.toolbar.mode, ...
                        'CData', this.icons.laptop, ...
                        'TooltipString','Swap source to iWalker');
                    set(this.info.mode, 'string', 'Datalog');
                    set(this.toolbar.loadLog, 'visible', 'on');
                    set(this.toolbar.connect, 'visible', 'off');
                    set(this.toolbar.saveLogButton, 'visible', 'off');
                    set(this.toolbar.zoom, 'visible', 'off');
                    set(this.toolbar.simulateButton, 'visible', 'on');
                    set(this.controls.slider, 'visible', 'on');
                case this.MODE.ONLINE;
                    this.state.mode = mode;
                    set(this.toolbar.mode, ...
                        'CData', this.icons.iwalker, ...
                        'TooltipString','Swap source to Log');
                    set(this.info.mode, 'string', 'iWalker');
                    set(this.toolbar.loadLog, 'visible', 'off');
                     set(this.toolbar.connect, 'visible', 'off');
                    set(this.toolbar.saveLogButton, 'visible', 'on');
                    set(this.toolbar.zoom, 'visible', 'on');
                    set(this.toolbar.simulateButton, 'visible', 'off');
                    set(this.controls.slider, 'visible', 'off');
                otherwise
                    error('Erroneuos mode');
            end
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Adquisition Management
        
        function iWalkerInit(this)
            s = this.settings.values;
            if strcmp(s.Adquisition_walker, 'iWalkerRoboPeak')
                this.iwalker = iWalkerRoboPeak();
                           
                % Register adquisition listeners
                this.eh = [ ...
                    addlistener(this.iwalker, 'canusbReaded', @this.rpcanListner), ...
                    addlistener(this.iwalker, 'lidarReaded', @this.rplidarListener), ...
                    ];
            else
                this.iwalker = iWalkerHokuyo();
                
                % Register adquisition listeners
                this.eh = [ ...
                    addlistener(this.iwalker, 'canusbReaded', @this.hokuyocanListner), ...
                    addlistener(this.iwalker, 'lidarReaded', @this.hokuyolidarListener), ...
                    ];
            end
        end
        
        function success = iWalkerConnect(this)
            this.iWalkerInit();
            s = this.settings.values;
            this.settings.values.Rob_dt = s.Adquisition_SampleTimeCAN;
            COM = str2double(strrep(s.Adquisition_COM, 'COM', ''));           
            this.iwalker.setCANUSBSampleTime(s.Adquisition_SampleTimeCAN);
            this.iwalker.setLidarSampleTime(s.Adquisition_SampleTimeLidar);
            sc = this.iwalker.connect(COM);
            if ~sc.canusb || ~sc.lidar
                msg1 = '';
                msg2 = '';
                if ~sc.canusb 
                    msg1 = 'CANUSB: connection failed';
                end
                if ~sc.lidar
                    msg2 = 'Lidar: connection failed';
                end
                answer = questdlg({msg1, msg2, 'Do you want to start anyways?'}, 'Connection problem', 'yes','no','no');
                if strcmp(answer, 'no')
                    success =  false;
                    return;
                end                   
            end
            success = true;
        end
        
        function success = iWalkerDisconnect(this)
            this.iwalker.disconnect();
            success = true;
        end
        
        function iWalkerStart(this)
            this.iwalker.start();
        end
        
        % Listener for CANUSB connected to iWalkerRoboPeak
        function rpcanListner(this, src, e)
            try
                this.setCurrentTime(e.Timestamp);
                this.sim.stepOdometry(e.Data.odo);
                %t = this.info.table;
                %t.Data(1,2:4) = {this.sim.rob.x(1), this.sim.rob.x(2), this.sim.rob.x(3)};
                %t.Data(2,2:3) = {e.Data.rps(1), e.Data.rps(2)};
            catch
                disp('Error in rpcanListner!');
            end
        end
        
        % Listener for RPLidar connected to iWalkerRoboPeak
        function rplidarListener(this, src, e)
            try
                if e.Data.count > 0
                    range = double(e.Data.range)/1000;
                    angle = double(e.Data.angle);
                else
                    range = 0;
                    angle = 0;
                end                
                this.sim.stepScan(range, angle);
                this.redrawScan = true;
            catch
                disp('Error in rplidarListener!');
            end
        end
        
        function hokuyocanListner(this, src, e)
           try
                this.setCurrentTime(this.iwalker.time);
                this.sim.stepOdometry(e.Data.odo);
            catch
                disp('Error in hokuyocanListner!');
            end
        end
        
        function hokuyolidarListener(this, src, e)
            try
                range = double(e.Data.range)/1000;
                angle = double(e.Data.angle);
                this.sim.stepScan(range, angle);
                this.redrawScan = true;
            catch
                disp('Error in hokuyolidarListener!');
            end
        end
              
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Controls GUI Management
                     
        function setCurrentTime(this, time)          
            set(this.info.currentTime, 'string', num2str(time, '%.1f'));
        end
                      
        function b = continueAndDiscard(this)
            if ~this.logSaved
                answer = questdlg('The last log was not saved. Do you want to discard it?', ...
                    'Discard log?', ...
                    'Discard and continue', ...
                    'Cancel', ...
                    'Cancel');
                b = ~strcmp(answer,'Cancel');
            else
                this.logSaved = true;
                b = true;
            end
        end
                     
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Callbacks
        
        % Figure callbacks %
        function close_Callback(this, ~, ~)
            try 
                if isvalid(this.timers.plot)
                    stop(this.timers.plot);
                    delete(this.timers.plot);
                end
                
                if ~isempty(this.iwalker) && isvalid(this.iwalker)
                   this.iwalker.delete(); 
                end

                this.settings.save(fullfile(parentpath(mfilename('fullpath')), 'settings.mat'));

                %gui.settings.close()
                %delete(this.fig);
                %delete(this);
            catch
               errordlg('Problem during close callback', 'Error'); 
            end
            delete(this.fig);
            delete(this);
        end
        
        % Toolbar callbaks %
        function changeMode_Callback(this, ~, ~)
            s = this.settings.values;
            switch this.state.mode
                case this.MODE.ONLINE 
                    % set offline Mode
                    if this.continueAndDiscard()
                        if this.state.status == this.STATUS.IWK_CONNECTED
                            this.iWalkerDisconnect();
                        end
                        stop(this.timers.plot);
                        this.setMode(this.MODE.OFFLINE);
                        this.setStatus(this.STATUS.LOG_LOAD);
                        set(this.info.endTime, 'string', '0');
                    end                    
                case this.MODE.OFFLINE 
                    % set online mode       
                    this.iWalkerInit();
                    this.setMode(this.MODE.ONLINE);
                    this.setStatus(this.STATUS.IWK_NOT_CONNECTED);
                    set(this.info.endTime, 'string', 'Inf');
                    start(this.timers.plot);
            end
            set(this.info.currentTime, 'string', 0);
        end
        
        function connect_Callback(this, ~, ~)
            status = this.state.status;
            this.setStatus(this.STATUS.BUSY);
            if status == this.STATUS.IWK_NOT_CONNECTED
                if this.iWalkerConnect()               
                    this.setStatus(this.STATUS.IWK_CONNECTED);
                else
                    this.setStatus(this.STATUS.IWK_NOT_CONNECTED);
                end
            elseif status == this.STATUS.IWK_CONNECTED
                if this.continueAndDiscard()
                    if this.iWalkerDisconnect()
                        this.setStatus(this.STATUS.IWK_NOT_CONNECTED);                 
                    else
                        this.setStatus(this.STATUS.IWK_CONNECTED);
                    end
                end
            end
        end
        
        
        function loadLog_Callback(this, ~, ~)
            try               
                path = this.settings.values.Log_path;
                [file, path] = uigetfile('*.mat', 'Load datalog', path);
                if path ~= 0
                    this.settings.values.Log_path = path;
                   
                    f = load(file);
                    try
                        this.dlog = DataLog(f.iWalkerLog, this.sim);
                    catch
                        ff = newLogFormatHokuyo(file);
                        this.dlog = DataLog(ff, this.sim);
                    end

                    set(this.info.endTime, 'String', num2str(this.dlog.endTime, '%.1f'));
                    setStatus(this, this.STATUS.LOG_SIMULATE);
                end
            catch
                errordlg('Problem loading the log', 'Error');
            end
        end
        
        function saveLogButton_Callback(this, ~, ~)
            try
                s = this.settings.values;
                dstr = strrep(strrep(datestr(now), ' ', '_'), ':', '-');
                id = s.Adquisition_count;
                filename = [num2str(id) '_' dstr];
                pathname = s.Adquisition_SavePath;
                [filename, pathname] =  uiputfile('*.mat', 'Save log', fullfile(pathname, filename));
                if pathname ~= 0
                    saver = matfile(fullfile(pathname, filename),'Writable',true);
                    saver.iWalkerLog = this.iwalker.log;
                    saver.lidar_X = [s.Lidar_x s.Lidar_y s.Lidar_th];
                    this.settings.values.Adquisition_SavePath = pathname;
                    this.settings.values.Adquisition_count = id + 1;
                    this.logSaved = true;
                end
            catch
                errordlg('Error saving the log', 'Error');
            end
        end
        
        function stopButton_Callback(this, ~, ~)
            if this.state.mode == this.MODE.ONLINE
                this.setStatus(this.STATUS.BUSY);
                this.iwalker.stop();
                this.setStatus(this.STATUS.IWK_CONNECTED);
            else
                this.setStatus(this.STATUS.BUSY);
                this.stopCmd = true;
                this.setStatus(this.STATUS.LOG_READY);
            end
        end
        
        
        function playButton_Callback(this, ~, ~)
            s = this.settings.values;
            if this.state.mode == this.MODE.ONLINE              
                if this.continueAndDiscard()
                    this.setStatus(this.STATUS.BUSY);             
                    this.initSimulation();
                    this.setStatus(this.STATUS.IWK_RUNNING);
                    this.iWalkerStart();
                end
            else                  
                this.setStatus(this.STATUS.LOG_RUNNING);
                this.stopCmd = false;               
                slider = this.controls.slider;
                step = floor(slider.Value);
                while step < slider.Max && ~this.stopCmd
                    tic;
                    this.setSimulationStep(step);
                    t = this.dlog.nextDelay(step) - toc;
                    if t > 0
                        pause(t);
                    end
                    step = step + 1;
                end               
                this.setStatus(this.STATUS.LOG_READY);               
            end
        end
        
        function slider_Callback(this, slider, ~)
            % To avoid acumulate callbacks we lock the function
            if (~this.lockSlider)    
                this.lockSlider = true;
                slider = handle(slider);
                step = floor(slider.Value);                       
                this.setSimulationStep(step);                    
                this.lockSlider = false;
            end
        end
        
        function simulateButton_Callback(this, ~, ~)
            this.setStatus(this.STATUS.BUSY);
            this.initSimulation();
            this.initPlots();
            this.simulating = true;
            
            dlog = this.dlog;
            sim = this.sim;
            
%             sim.ekf.estimateMap = false;
%             file = load('omega3-lsi.mat');
%             sim.map = file.fmap;
%             sim.ekf.map = file.fmap;
            try
%                 start(this.timers.plot);
                h = waitbar(0, ...
                    '0% simulated', ...
                    'Name','Simulating...', ...
                    'WindowStyle', 'normal');
                success = true;
                iprev = 0;
                maxStep = dlog.maxStep();
                %profile on
                for step = 1:maxStep
                    [source, data, ts, dt] = dlog.getSample(step);
                    if (strcmp(source, 'can'))
                        sim.stepOdometry(data.odo);
                    else
                        sim.stepScan(data.range/1000, data.angle);
                    end
%                     this.updatePlots();
                    if ishandle(h)
                        p = step/maxStep;
                        i = int32(p*100);
                        if i ~= iprev
                            txt = sprintf('%d%% simulated', i);
                            waitbar(p, h, txt);
                            iprev = i;
                            if mod(i,1) == 0
                                this.updatePlots();
                            end
                        end
                    else
                        success = false;
                        break;
                    end
                end
            catch exception
                warning(exception.getReport);
                success = false;
            end
            if ishandle(h)
                close(h);
            end
            %profile viewer
            
                         

%                          stop(this.timers.plot);
            if success
                set(this.controls.slider, ...
                    'Value', 0, ...
                    'Min', 0, ...
                    'Max', this.dlog.maxStep(), ...
                    'SliderStep', [1 10]/this.dlog.maxStep());
                this.setSimulationStep(0);
                this.setStatus(this.STATUS.LOG_READY);
            else
                this.setStatus(this.STATUS.LOG_SIMULATE);
            end
            this.simulating = true;
        end
        
        function setSimulationStep(this, step)
            try 
                % Sync slider
                this.controls.slider.Value = step;
                data = this.dlog.setSimulationStep(step);
                this.setCurrentTime(data.timestamp);
                this.updatePlots(data);
               
            catch exception
                warning(exception.getReport);
            end
        end
        
        function updatePlots(this, data)
            if nargin < 2
               data = []; 
            end
            s = this.settings.values;
            lid = this.sim.lid;
            ext = this.sim.ext;
            rob = this.sim.rob;
            map = this.sim.map;
            ekf = this.sim.ekf;
            
            mapPlot = this.plots.map;
            radPlot = this.plots.radar;
            c = this.COLOR;
            if this.redrawScan ||  this.simulating
                this.redrawScan = false;
                
                if s.RadarPlot_drawPoints
                    if s.RadarPlot_drawValid
                        radPlot.drawPoints('ScanPoints.Valid', lid.p(:,lid.valid), 10, c.Valid, '.');
                    end
                    if s.RadarPlot_drawOutRange
                        radPlot.drawPoints('ScanPoints.OutRange', lid.p(:,lid.outRange), 10, c.OutRange, '.');
                    end
                    if s.RadarPlot_drawDeadAngle
                        radPlot.drawPoints('ScanPoints.DeadAngle', lid.p(:,lid.inDeadAngle), 10, c.DeadAngle, '.');
                    end
                    if s.RadarPlot_drawOutlier
                        radPlot.drawPoints('ScanPoints.Outliers', lid.p(:,lid.outliers), 10, c.Outlier, 'x');
                    end
                end
                
                if s.RadarPlot_drawRays
                    if s.RadarPlot_drawValid
                        radPlot.drawRays('ScanRays.Valid', lid.p(:,lid.valid), c.Valid/2, 1, '-');
                    end
                    if s.RadarPlot_drawOutRange
                        radPlot.drawRays('ScanRays.OutRange', lid.p(:,lid.outRange), c.OutRange/2, 1, '-');
                    end
                    if s.RadarPlot_drawDeadAngle
                        radPlot.drawRays('ScanRays.DeadAngle', lid.p(:,lid.inDeadAngle), c.DeadAngle/2, 1, '-');
                    end
                    if s.RadarPlot_drawOutlier
                        radPlot.drawRays('ScanRays.Outliers', lid.p(:,lid.outliers), c.Outlier/2, 1, ':');
                    end
                end
                           
                
                if s.GridMap_Enabled
                    if isempty(data)
                        mapPlot.setImage(this.sim.gmp.image(), this.sim.gmp.R);
                    else
                        mapPlot.setImage(data.img, this.sim.gmp.R);
                    end
                end
                if s.MapPlot_drawScanArea
                    % To obtain a valid geometry for the patch, we set the
                    % non valid points to lidar location and add two extra
                    % points, one at the begining and other at the end at
                    % lidar position.
                    p = repmat(lid.x, 1, size(lid.pw,2));
                    p(:,lid.valid) = lid.pw(:,lid.valid);
                    p = [lid.x  p  lid.x];
                    mapPlot.drawScannedArea('ScannedArea', p, c.Valid/2, 0.5);
                end
                if ~isempty(ext.output)
                    %mapPlot.drawLandmark('Corners', ext.output.corners, c.Landmark);
                    %mapPlot.drawSegmentedLines('Lines', ext.output.lines);
%                     mapPlot.drawSegments('Segments', ext.output.segments, c.Segment, 2, '-');
%                      mapPlot.drawSegmentFeature('Segment', ext.output.segmentFeatures, [1 0 0]);
                    
                    LSF = [];
                    for sf = ext.output.segmentFeatures
                        if isvalid(sf)
                            LSF = [LSF SegmentFeature([sf.h(ekf.X(1:3)) 0 0], diag([0.01, 1*pi/180]))];
                    
                        end
                    end
                    mapPlot.drawHough('SegmentH', LSF, ekf.X(1:3), [1 0 1], 1, '--');
                    
%                      LSF = [];
%                     for sf = map.segments
%                         LSF = [LSF SegmentFeature([sf.h(ekf.X(1:3)) 0 0], diag([0.01, 1*pi/180]))];
%                     end
%                     mapPlot.drawHough('SegmentHM', LSF, ekf.X(1:3), [0 1 0], 1, '--');
                    
                    mapPlot.drawSegmentFeature('SegmentG', ext.output.segmentFeatures, [1 0 0]);
                end
            end
            
%             mapPlot.drawCornerFeatures('Corners', [], [0 1 0]);
%             mapPlot.drawSegmentFeature('SegmentFeature', [], [0 1 0]);
            
            if s.MapPlot_drawRobot
                mapPlot.drawRobot('iWalker', ekf.X(1:3), rob.S, c.Robot);
            end
            
            if s.MapPlot_drawRobotTrace && ~isempty(rob.Xr_hist)
                if isempty(data)
                            
                    mapPlot.drawTrace('iWalkerTrace', rob.Xr_hist, c.Trace, 1, '-');
                else
                    past = rob.Xr_hist(1:data.i_rob,:);
                    mapPlot.drawTrace('iWalkerTrace', past, c.Trace, 1, '-');
%                     future = rob.Xr_hist(data.i_rob:end,:);
%                     mapPlot.drawTrace('iWalkerTraceForward', future, c.Trace/4, 0.1, '-');   
                end
            end
            
 
            mapPlot.drawErrorXY('ekfPxy', ekf.X(1:3), ekf.P(1:2,1:2), [1 0 1], 0.3);
            mapPlot.drawErrorAngle('ekfPth', ekf.X(1:3), ekf.P(3,3), [1 1 0], 0.5);
            
            
            if this.followRobot
               this.centerMap(rob.Xr(1:2));
            end
            
            mapPlot.drawCornerFeatures('Corners', map.corners, [0 1 0]);
            mapPlot.drawSegmentFeature('SegmentFeature', map.segments, [0 1 0]);
            %mapPlot.drawHough('SegmentFeatureH', map.segments, [0 1 1], 1, '--');
            
            
            drawnow;
        end
                
        % Timer callbacks
        function updatePlots_Callback(this, ~, ~)
            this.updatePlots();
        end
        
        function errorPlots_Callback(this, t, event)
            this.setStatus(this.STATUS.BUSY);
            %stop(this.timers.simlog);
            this.setStatus(this.STATUS.LOG_READY);
            errordlg('Error in drawing process', 'Error');
        end
        
        function zoom_Callback(this, src, event)  
            this.zoomTool.Enable = get(src, 'State');           
        end
        
        function centerMap(this, pos)
            ax = this.plots.map.hAxes;
            XLon = ax.XLim(2) - ax.XLim(1);
            YLon = ax.YLim(2) - ax.YLim(1);
            ax.XLim = [pos(1) - XLon/2, pos(1) + XLon/2];
            ax.YLim = [pos(2) - YLon/2, pos(2) + YLon/2];
        end
        
        function zoomInMap(this, factor)
           ax = this.plots.map.hAxes;
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
        
        function zoomOutMap(this, factor)
           ax = this.plots.map.hAxes;
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
        
        function panMap(this, direction, dis)
           ax = this.plots.map.hAxes;
           XLon = ax.XLim(2) - ax.XLim(1);
           YLon = ax.YLim(2) - ax.YLim(1);
           d = min(XLon, YLon) / dis;
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
        
        function mouseScroll_Callback(this, src, event)
            if event.VerticalScrollCount < 0
                %this.zoomInMap(1.5);
                this.plots.map.zoomIn(1.5);
            else
                %this.zoomOutMap(1.5);
                this.plots.map.zoomOut(1.5);
            end

        end
        
        
        function keyPress_Callback(this, src, event)
            slider = this.controls.slider;
            
           %% Zoom and Pan of Map Plot
           switch event.Key             
               case 'a' % pan left
                   this.panMap('left', 10);
               case 'd' % pan right
                   this.panMap('right', 10);
               case 'w' % pan up
                   this.panMap('up', 10);
               case 's' % pan down
                   this.panMap('down', 10);
               case 'x' % zoom out
                   this.zoomOutMap(1.5);
               case 'z' % zoom in
                   this.zoomInMap(1.5);
               case 'r' % center to robot
                   this.centerMap(this.sim.rob.Xr(1:2));
               case 'f' % follor robot mode
                   this.followRobot = ~this.followRobot;
%                    if this.state.mode == this.MODE.OFFLINE
%                        this.setSimulationStep(slider.value);
%                    end
               case 't' % active text info
                   this.textMap = ~this.textMap;
                   this.setSimulationStep(slider.value);                    
           end
           
           % Run / Stop
           if strcmp(event.Key, 'space')
               if this.state.status == this.STATUS.LOG_RUNNING
                   this.stopButton_Callback();
               elseif this.state.status == this.STATUS.LOG_READY
                   this.playButton_Callback();
               end
           end
                   
           %% Slider
           if this.state.status == this.STATUS.LOG_READY && ~this.lockSlider
               this.lockSlider = true;
               switch event.Key
                   case 'rightarrow'
                       if slider.value < slider.Max
                           this.setSimulationStep(slider.value + 1);
                       end
                   case 'leftarrow'
                       if slider.value > slider.Min
                           this.setSimulationStep(slider.value - 1);
                       end
               end
               this.lockSlider = false;
           end
        end
        
    
        function settings_Callback(this, src, ~)
            try
                this.settings.show();               
                this.initSimulation();
                this.initPlots();               
                %this.iWalkerInit();
            catch
                errordlg('Error in settings', 'Error');
            end
        end
                      
    end
    
    methods (Access = public)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Public GUI methods
        function show(this)
            set(this.fig, 'Visible', 'on');
        end
    end
    
    
end