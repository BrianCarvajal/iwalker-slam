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
            'RUNNING', [160,215,50]/255, ...
            'READY',   [65,105,225]/255, ...
            'UNREADY', [255,70,50]/255);
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
        eh          % event handles for simulink
        logSaved    % true if last log was saved
        redrawScan  % true if there is new lidar data to plot
        stopCmd
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
            this.icons.play = iconRead('play4.png');
            this.icons.stop = iconRead('stop4.png');
            this.icons.log = iconRead('log.png');
            this.icons.zoomIn = iconRead('zoomIn.png');
            this.icons.zoomOut = iconRead('zoomOut.png');
            this.icons.settings = iconRead('gear.png');
            this.icons.saveLog = iconRead('save.png');
            this.icons.connect = iconRead('plug-disconnect.png');
            this.icons.disconnect = iconRead('plug-connect.png');
            this.icons.gear = iconRead('gear2.png');
            
            % Initialize state
            this.state.mode = this.MODE.ONLINE;
            this.state.status = this.STATUS.LOG_LOAD;

           
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
                      
            this.initToolbar();
            
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
            
            this.info.table = handle(uitable('Parent', this.layout.leftPanel));
            this.initInfoTable();
            %uiextras.Empty('Parent', this.layout.leftPanel);
            
            
            set(this.layout.leftPanel, 'Sizes', [-1 0], 'Spacing', 6);
            this.plots.map = MapAxes('Parent', this.layout.main);
            %gui.layout.tabpanel = uiextras.TabPanel('Parent', gui.layout.main);
            %Set the width of the left column (lidar plot and info box) and map
            set( this.layout.main, 'Sizes', [-1 -1.5], 'Spacing', 6 );
            
            this.settingsPath = fullfile(parentpath(mfilename('fullpath')), 'settings.mat');
            this.settings = iSettings(this.settingsPath);
            this.sim = SimulationEngine();
            this.initSimulation();
                       
            this.timers.plot = timer('Name', 'PlotTimer', ...
                'ExecutionMode', 'fixedRate', ...
                'BusyMode', 'drop', ...
                'Period', this.settings.values.Plots_fps, ...
                'TimerFcn', @this.updatePlots_Callback, ...
                'ErrorFcn', @this.errorPlots_Callback);
            
            this.stopCmd = false;
            
            initPlots(this);
            
            % Set initial status
            this.logSaved = true;
            this.setStatus(this.STATUS.LOG_LOAD);
            this.setMode(this.MODE.OFFLINE);
            
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
            
            % Zoom button
            this.toolbar.zoomIn = uitoggletool(this.toolbar.bar, ...
                'CData', this.icons.zoomIn,...
                'TooltipString','Zoom In',...
                'HandleVisibility','off', ...
                'ClickedCallback', @this.zoomIn_Callback);
            
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
            
            % Save log button
            this.toolbar.saveLogButton = uipushtool(this.toolbar.bar, ...
                'CData', this.icons.saveLog,...
                'TooltipString','Save log',...
                'HandleVisibility','off', ...
                'ClickedCallback', @this.saveLogButton_Callback);
            
            
            
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
            start(this.timers.plot);
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
                    
                case this.STATUS.LOG_READY
                    set(this.info.status, ...
                        'string', 'Ready', ...
                        'backgroundcolor', this.COLOR.READY);
                    set(this.toolbar.playButton, 'enable', 'on');
                    set(this.toolbar.mode, 'enable', 'on');
                    set(this.toolbar.settings, 'enable', 'on');
                    set(this.toolbar.loadLog, 'enable', 'on');
                    set(this.toolbar.zoomIn, 'enable', 'on');
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
                    
                case this.STATUS.LOG_RUNNING
                    set(this.info.status, ...
                        'string', 'Running', ...
                        'backgroundcolor', this.COLOR.RUNNING);
                    set(this.toolbar.stopButton, 'enable', 'on');
                    set(this.controls.slider, 'enable', 'on');
                
                    
                case this.STATUS.IWK_NOT_CONNECTED
                    set(this.info.status, ...
                        'string', 'Connect the lidar', ...
                        'backgroundcolor', this.COLOR.UNREADY);
                    set(this.toolbar.settings, 'enable', 'on');
                    set(this.toolbar.mode, 'enable', 'on');
                    set(this.toolbar.connect, 'enable', 'on');
                    set(this.toolbar.connect, 'CData', this.icons.connect);
                    set(this.toolbar.zoomIn, 'enable', 'on');
                                      
                case this.STATUS.IWK_CONNECTED
                    set(this.info.status, ...
                        'string', 'Ready', ...
                        'backgroundcolor', this.COLOR.READY);
                    set(this.toolbar.playButton, 'enable', 'on');   
                    set(this.toolbar.connect, 'enable', 'on');
                    set(this.toolbar.connect, 'CData', this.icons.disconnect);
                    set(this.toolbar.saveLogButton, 'enable', 'on');
                    
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
            set(this.toolbar.zoomIn, 'enable', 'off');
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
                    set(this.toolbar.zoomIn, 'visible', 'off');
                    set(this.toolbar.simulateButton, 'visible', 'on');
                    set(this.controls.slider, 'visible', 'on');
                case this.MODE.ONLINE;
                    this.state.mode = mode;
                    set(this.toolbar.mode, ...
                        'CData', this.icons.iwalker, ...
                        'TooltipString','Swap source to Log');
                    set(this.info.mode, 'string', 'iWalker');
                    set(this.toolbar.loadLog, 'visible', 'off');
                     set(this.toolbar.connect, 'visible', 'on');
                    set(this.toolbar.saveLogButton, 'visible', 'on');
                    set(this.toolbar.zoomIn, 'visible', 'off');
                    set(this.toolbar.simulateButton, 'visible', 'off');
                    set(this.controls.slider, 'visible', 'off');
                otherwise
                    error('Erroneus mode');
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
%                 bdclose(this.settings.values.Simulink_model);
                %gui.settings.close()
                delete(this.fig);
                delete(this);
            catch
               errordlg('Problem during close callback', 'Error'); 
            end
        end
        
        % Toolbar callbaks %
        function changeMode_Callback(this, ~, ~)
            s = this.settings.values;
            switch this.state.mode
                case this.MODE.ONLINE
                    if this.continueAndDiscard()
                        if this.state.status == this.STATUS.IWK_CONNECTED
                            this.iWalkerDisconnect();
                        end
                        
                        this.setMode(this.MODE.OFFLINE);
                        if isempty(this.dlog)
                            this.setStatus(this.STATUS.LOG_LOAD);
                            set(this.info.endTime, 'string', '0');
                        else
                            this.setStatus(this.STATUS.LOG_READY);
                            set(this.info.endTime, 'string', num2str(this.dlog.endTime, '%.1f'));
                        end
                    end
                    
                case this.MODE.OFFLINE
                    this.iWalkerInit();
                    this.setMode(this.MODE.ONLINE);
                    this.setStatus(this.STATUS.IWK_NOT_CONNECTED);
                    set(this.info.endTime, 'string', 'Inf');                   
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
                    this.dlog = DataLog(f.iWalkerLog);

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
        
        
        function simulateButton_Callback(this, ~, ~)
            this.setStatus(this.STATUS.BUSY);
            this.initSimulation();
            this.initPlots();          
            success = this.dlog.simulate(this.sim);           
            if success
                set(this.controls.slider, ...
                    'Value', 0, ...
                    'Min', 0, ...
                    'Max', this.dlog.maxStep(), ...
                    'SliderStep', [1 10]/this.dlog.maxStep());               
                this.setSimulationStep(0);              
                stop(this.timers.plot);
                this.setStatus(this.STATUS.LOG_READY);
            else
                this.setStatus(this.STATUS.LOG_SIMULATE);
            end
        end
        
        function setSimulationStep(this, step)
            % Sync slider
            this.controls.slider.Value = step;
            
            data = this.dlog.setSimulationStep(step);
            
            lid = data.lid;
            rob = data.rob;
            s = this.settings.values;
            mapPlot = this.plots.map;
            radPlot = this.plots.radar;
 
            this.setCurrentTime(data.timestamp);
            
            if s.MapPlot_drawRobot
                mapPlot.drawRobot('iWalker', rob.x, this.sim.rob.S, [1 0 0]);
            end
            
            if s.MapPlot_drawRobotTrace
                mapPlot.drawTrace('iWalkerTrace', rob.x_back, [1 0 0], 0.1, '-');
                mapPlot.drawTrace('iWalkerTraceForward', rob.x_forw, [0.7 0.7 0.7], 0.1, '-');
            end
            
            if s.RadarPlot_drawValid && s.RadarPlot_drawPoints
                radPlot.drawPoints('ScanPoints.Valid', lid.p(:,lid.valid), 10, [0 1 1], '.');
            end
            if s.RadarPlot_drawValid && s.RadarPlot_drawRays
                radPlot.drawRays('ScanRays.Valid', lid.p(:,lid.valid), [0 0.5 0.5], 1, '-');
            end
            if s.GridMap_Enabled
                mapPlot.setImage(data.img, this.sim.gmp.R);
            end
            if s.MapPlot_drawScanArea
                % To obtain a valid geometry for the patch, we set the
                % non valid points to lidar location and add two extra
                % points, one at the begining and other at the end at
                % lidar position.
                p = repmat(lid.x, 1, size(lid.pw,2));
                p(:,lid.valid) = lid.pw(:,lid.valid);
                p = [lid.x  p  lid.x];
                mapPlot.drawScannedArea('ScannedArea', p, [0 0.5 0.5], 0.5);
            end
            
            mapPlot.drawLandmark('Landmarks', data.landmarks, [0 1 0]);
            
            

            drawnow;
        end
               
        function zoomIn_Callback(this, src, event)
            %             axes(gui.plots.map.hAxes);
            %             switch get(src, 'State')
            %                 case 'on';
            %                     zoom
            %                 case 'off'
            %                     zoom off;
            %             end
        end
        
        function zoomOut_Callback(this, src, event)
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
        
        
        
        function slider_Callback(this, slider, ~)
            % To avoid acumulate callbacks we lock the function
            persistent lock_slider_Callback            
            if isempty(lock_slider_Callback)
                lock_slider_Callback = 1;
            else
                return;
            end            
            slider = handle(slider);
            step = floor(slider.Value);                       
            this.setSimulationStep(step);                    
            lock_slider_Callback = [];
        end
        
        % Timer callbacks
        function updatePlots_Callback(this, t, ~)
            s = this.settings.values;
            lid = this.sim.lid;
            ext = this.sim.ext;
            rob = this.sim.rob;
            mapPlot = this.plots.map;
            radPlot = this.plots.radar;
            %if this.redrawScan
            if true
                this.redrawScan = false;
                
                if s.RadarPlot_drawValid && s.RadarPlot_drawPoints
                    radPlot.drawPoints('ScanPoints.Valid', lid.p(:,lid.valid), 10, [0 1 1], '.');
                end
                if s.RadarPlot_drawValid && s.RadarPlot_drawRays
                    radPlot.drawRays('ScanRays.Valid', lid.p(:,lid.valid), [0 0.5 0.5], 1, '-');
                end              
                
                if s.GridMap_Enabled
                    mapPlot.setImage(this.sim.gmp.image(), this.sim.gmp.R);
                end
                if s.MapPlot_drawScanArea
                    % To obtain a valid geometry for the patch, we set the
                    % non valid points to lidar location and add two extra
                    % points, one at the begining and other at the end at
                    % lidar position.
                    p = repmat(lid.x, 1, size(lid.pw,2));
                    p(:,lid.valid) = lid.pw(:,lid.valid);
                    p = [lid.x  p  lid.x];
                    mapPlot.drawScannedArea('ScannedArea', p, [0 0.5 0.5], 0.5);
                end
                if ~isempty(ext.output)
                    mapPlot.drawLandmark('Landmarks', ext.output.landmarks, [0 1 0]);
                end
            end
            
            if s.MapPlot_drawRobot
                mapPlot.drawRobot('iWalker', rob.x, rob.S, [1 0 0]);
            end
            
            if s.MapPlot_drawRobotTrace && ~isempty(rob.x_hist)
                mapPlot.drawTrace('iWalkerTrace', rob.x_hist, [1 0 0], 1, '-');
            end           
            drawnow;
        end
        
        function errorPlots_Callback(this, t, event)
            this.setStatus(this.STATUS.BUSY);
            %stop(this.timers.simlog);
            this.setStatus(this.STATUS.LOG_READY);
            errordlg('Error in drawing process', 'Error');
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