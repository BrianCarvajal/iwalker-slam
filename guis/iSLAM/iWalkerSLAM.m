classdef (Sealed) iWalkerSLAM < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        fig         % the windows itself
        sim         % EngineSimulator
        dlog        % DataLog
    end
    
    
    properties (Constant)
        %% Enumerations (native enumerations matlab's are crap)
        STATUS = struct(...
            'STARTING',     1, ...
            'LOG_LOAD',     2, ...
            'LOG_READY',    3, ...
            'LOG_RUNNING',  4, ...
            'LOG_PAUSED',   5, ...
            'LOG_STOPING',  6, ...
            'IWK_CONNECT',  7, ...
            'IWK_READY',    8, ...
            'IWK_RUNNING',  9, ...
            'IWK_STOPING',  10, ...
            'BUSY',         11);
        
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
        eh          %event handles for simulink
        logSaved    %flag that indicates if last log was saved
        redrawScan
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
            this.icons.pause = iconRead('pause4.png');
            this.icons.stop = iconRead('stop4.png');
            this.icons.step = iconRead('step.png');
            this.icons.log = iconRead('log.png');
            this.icons.simulink = iconRead('simulink.png');
            this.icons.zoomIn = iconRead('zoomIn.png');
            this.icons.zoomOut = iconRead('zoomOut.png');
            this.icons.settings = iconRead('gear.png');
            this.icons.saveLog = iconRead('save.png');
            
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
            this.statusbar.margin(1) = uiextras.Empty('Parent', this.layout.background);
            this.statusbar.bar = uiextras.HBox('Parent', this.layout.background);
            this.statusbar.margin(2) =uiextras.Empty('Parent', this.layout.background);
            
            this.initStatusbar();
            
            set(this.layout.background, 'Sizes', [-1 this.statusbar.marginWidth 15 this.statusbar.marginWidth]);
            this.layout.leftPanel = uiextras.VBoxFlex('Parent', this.layout.main);
            this.plots.radar = RadarAxes('Parent', this.layout.leftPanel);
            uiextras.Empty('Parent', this.layout.leftPanel);
            set(this.layout.leftPanel, 'Sizes', [-1 0], 'Spacing', 6);
            this.plots.map = MapAxes('Parent', this.layout.main);
            %gui.layout.tabpanel = uiextras.TabPanel('Parent', gui.layout.main);
            %Set the width of the left column (lidar plot and info box) and map
            set( this.layout.main, 'Sizes', [-1 -1.5], 'Spacing', 6 );
            
            this.settingsPath = fullfile(parentpath(mfilename('fullpath')), 'settings.mat');
            this.settings = iSettings(this.settingsPath);
            this.sim = SimulationEngine();
            this.initSimulation();
            
            
            this.timers.simlog = timer('Name', 'DataLogTimer', ...
                'BusyMode', 'queue', ...
                'ExecutionMode', 'fixedRate', ...
                'TimerFcn', @this.updateSimlog_Callback, ...
                'ErrorFcn', @this.errorSimlog_Callback);
           
            this.timers.plot = timer('Name', 'PlotTimer', ...
                'ExecutionMode', 'fixedRate', ...
                'BusyMode', 'drop', ...
                'Period', this.settings.values.Plots_fps, ...
                'TimerFcn', @this.updatePlots_Callback, ...
                'ErrorFcn', @this.errorPlots_Callback);
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
            % Load log button
            this.toolbar.simulink = uipushtool(this.toolbar.bar, ...
                'CData', this.icons.simulink,...
                'TooltipString','Open simulink model',...
                'HandleVisibility','off', ...
                'ClickedCallback', @this.loadModel_Callback);
            
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
            
            % Step button
            this.toolbar.stepButton = uipushtool(this.toolbar.bar, ...
                'CData', this.icons.step,...
                'TooltipString','Run simulation',...
                'HandleVisibility','off', ...
                'ClickedCallback', @this.stepButton_Callback);
            
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
            start(this.timers.plot);
        end
               
        
        function initSimulation(gui)
            gui.sim.settings = gui.settings.values;
            gui.sim.init();
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% State GUI Management
        function setStatus(this, status)
            this.state.status = status;
            switch status
                case this.STATUS.LOG_LOAD
                    set(this.info.status, ...
                        'string', 'Load a datalog', ...
                        'backgroundcolor', this.COLOR.UNREADY);
                    this.disableToolbar();
                    set(this.toolbar.loadLog, 'enable', 'on');
                    set(this.toolbar.settings, 'enable', 'on');
                    set(this.toolbar.mode, 'enable', 'on');
                    
                case this.STATUS.LOG_READY
                    set(this.info.status, ...
                        'string', 'Ready', ...
                        'backgroundcolor', this.COLOR.READY);
                    this.disableToolbar();
                    set(this.toolbar.playButton, 'enable', 'on');
                    set(this.toolbar.stepButton, 'enable', 'on');
                    set(this.toolbar.mode, 'enable', 'on');
                    set(this.toolbar.settings, 'enable', 'on');
                    set(this.toolbar.loadLog, 'enable', 'on');
                    set(this.toolbar.zoomIn, 'enable', 'on');
                    
                    
                case this.STATUS.LOG_RUNNING
                    set(this.info.status, ...
                        'string', 'Running', ...
                        'backgroundcolor', this.COLOR.RUNNING);
                    set(this.toolbar.playButton, 'CData', this.icons.pause);
                    this.disableToolbar();
                    set(this.toolbar.playButton, 'enable', 'on');
                    set(this.toolbar.stopButton, 'enable', 'on');
                    
                    
                case this.STATUS.LOG_PAUSED
                    set(this.info.status, ...
                        'string', 'Paused', ...
                        'backgroundcolor', this.COLOR.READY);
                    this.disableToolbar();
                    set(this.toolbar.playButton, 'CData', this.icons.play);
                    set(this.toolbar.playButton, 'enable', 'on');
                    set(this.toolbar.stopButton, 'enable', 'on');
                    set(this.toolbar.stepButton, 'enable', 'on');
                    set(this.toolbar.zoomIn, 'enable', 'on');
                    
                case this.STATUS.IWK_CONNECT
                    set(this.info.status, ...
                        'string', 'Connect the lidar', ...
                        'backgroundcolor', this.COLOR.UNREADY);
                    this.disableToolbar();
                    set(this.toolbar.settings, 'enable', 'on');
                    set(this.toolbar.mode, 'enable', 'on');
                    set(this.toolbar.simulink, 'enable', 'on');
                    set(this.toolbar.zoomIn, 'enable', 'on');
                    
                case this.STATUS.IWK_READY
                    set(this.info.status, ...
                        'string', 'Ready', ...
                        'backgroundcolor', this.COLOR.READY);
                    set(this.toolbar.playButton, 'enable', 'on');   
                    set(this.toolbar.mode, 'enable', 'on');
                    set(this.toolbar.settings, 'enable', 'on');
                    set(this.toolbar.simulink, 'enable', 'on');
                    set(this.toolbar.saveLogButton, 'enable', 'on');
                    
                case this.STATUS.IWK_RUNNING
                    set(this.info.status, ...
                        'string', 'Running', ...
                        'backgroundcolor', this.COLOR.RUNNING);
                    this.disableToolbar();
                    set(this.toolbar.stopButton, 'enable', 'on');
                    
                    this.logSaved = false;
                    
                case this.STATUS.BUSY
                    set(this.info.status, ...
                        'string', 'Busy...', ...
                        'backgroundcolor', this.COLOR.UNREADY);
                    this.disableToolbar();
                    set(this.toolbar.playButton, 'CData', this.icons.play);
                    
                otherwise
                    error('Not valid status');
            end
        end
        
        function disableToolbar(this)
            set(this.toolbar.settings, 'enable', 'off');
            set(this.toolbar.mode, 'enable', 'off');
            set(this.toolbar.loadLog, 'enable', 'off');
            set(this.toolbar.simulink, 'enable', 'off');
            set(this.toolbar.zoomIn, 'enable', 'off');
            set(this.toolbar.stopButton, 'enable', 'off');
            set(this.toolbar.playButton, 'enable', 'off');
            set(this.toolbar.stepButton, 'enable', 'off');
            set(this.toolbar.saveLogButton, 'enable', 'off');
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
                    set(this.toolbar.simulink, 'visible', 'off');
                    set(this.toolbar.stepButton, 'visible', 'on');
                    set(this.toolbar.saveLogButton, 'visible', 'off');
                case this.MODE.ONLINE;
                    this.state.mode = mode;
                    set(this.toolbar.mode, ...
                        'CData', this.icons.iwalker, ...
                        'TooltipString','Swap source to Log');
                    set(this.info.mode, 'string', 'iWalker');
                    set(this.toolbar.loadLog, 'visible', 'off');
                    set(this.toolbar.simulink, 'visible', 'on');
                    set(this.toolbar.stepButton, 'visible', 'off');
                    set(this.toolbar.saveLogButton, 'visible', 'on');
                    set(this.toolbar.saveLogButton, 'enable', 'off');
                otherwise
                    error('Erroneus mode');
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Simulink Management
        
        function initModel(this)
            this.setStatus(this.STATUS.BUSY);
            set(this.fig, 'Pointer','watch');
            try
                %% Open and set model
                modelName = this.settings.values.Simulink_model;
                
                load_system(modelName); % change for load_system for not open the model window
                
                % When the model starts, call the localAddEventListener function
                set_param(modelName,'StartFcn','gui.localAddEventListener');
                
                % Simulink may optimise your model by integrating all your blocks. To
                % prevent this, you need to disable the Block Reduction in the Optimisation
                % settings.
                set_param(modelName,'BlockReduction','off');
                this.setStatus(this.STATUS.IWK_READY);
            catch
                errordlg('Problem loading simulink model', 'Error');
                this.setStatus(this.STATUS.IWK_CONNECT);
            end
            set(this.fig, 'Pointer','arrow');
        end
        
        function setupModel(this)
            try 
                disp('Configurig model...');
                s = this.settings.values;
                modelName = s.Simulink_model;
                if ~strcmp(s.Simulink_COM, '-')
                    portNumber = strrep(s.Simulink_COM, 'COM', '');
                else
                    error('COM Port not connected');
                end
                switch (modelName)
                    case 'iWalkerRoboPeakModel'
                        %Setup RPLidar block
                        stl = s.Simulink_SampleTimeLidar;
                        set_param([modelName '/RPLidar'], ...
                            'SampleTime', num2str(stl),...
                            'COM', portNumber);

                        % Setup iWheels block
                        stw = s.Simulink_SampleTimeOdometry;
                        set_param([modelName '/iWheels'], ...
                            'SampleTime', num2str(stw));

                        % Setup Sample Tyme Sync block
                        sts = min([stl stw]);
                        set_param([modelName '/Sample Time Sync'], ...
                            'SampleTime', num2str(sts));

                    case 'iWalkerHokuyoModel'
                        % Setup URG-04LX log block
                        stl = s.Simulink_SampleTimeLidar;
                        set_param([modelName '/Hokuyo'], ...
                            'SampleTime', num2str(stl),...
                            'COM', portNumber);

                        % Setup iWheels block
                        stw = s.Simulink_SampleTimeOdometry;
                        set_param([modelName '/iWheels'], ...
                            'SampleTime', num2str(stw));

                        % Setup IMU block
                        set_param([modelName '/IMU'], ...
                            'SampleTime', num2str(stw),...
                            'UserData', gcbo);

                        % Setup FORCES block
                        set_param([modelName '/FORCES'], ...
                            'SampleTime', num2str(stw),...
                            'UserData', gcbo);

                        % Setup Sample Tyme Sync block
                        sts = min([stl,stw]);
                        set_param([modelName '/Sample Time Sync'], ...
                            'SampleTime', num2str(sts));

                        % Setup leftLambda block
                        set_param([modelName '/leftLambda'], ...
                            'Value', num2str(s.Simulink_LeftLambda));

                        % Setup rightLambda block
                        set_param([modelName '/rightLambda'], ...
                            'Value', num2str(s.Simulink_RightLambda));

                        % Setup leftNu block
                        set_param([modelName '/leftNu'], ...
                            'Value', num2str(s.Simulink_LeftNu));

                        % Setup rightNu block
                        set_param([modelName '/rightNu'], ...
                            'Value', num2str(s.Simulink_RightNu));

                    otherwise, error('Erroneus lidar');
                end
            catch
                errordlg('Problem configuring model', 'Error');
            end
        end
        
        function localAddEventListener(this)
            modelName = this.settings.values.Simulink_model;
            % we need to save the event handlers or the callback won't be
            % executed
            
            switch modelName
                case 'iWalkerRoboPeakModel'
                    this.eh = [ ...
                        add_exec_event_listener([modelName '/Sample Time Sync'], ...
                        'PostOutputs', @this.sampleTimeSyncEventListener) ...
                        
                        add_exec_event_listener([modelName '/RPLidar'], ...
                        'PostOutputs', @this.rplidarEventListener) ...
                        
                        add_exec_event_listener([modelName '/High Frequency Odometry'], ...
                        'PostOutputs', @this.OdometryListener) ...
                        ];
                    
                case 'iWalkerHokuyoModel'
                    this.eh = [ ...
                        add_exec_event_listener([modelName '/Sample Time Sync'], ...
                        'PostOutputs', @this.sampleTimeSyncEventListener) ...
                        
                        add_exec_event_listener([modelName '/Hokuyo'], ...
                        'PostOutputs', @this.hokuyoEventListener) ...
                        
                        add_exec_event_listener([modelName '/High Frequency Odometry'], ...
                        'PostOutputs', @this.OdometryListener) ...
                        ];
            end
        end
        
        function sampleTimeSyncEventListener(this, rtb, ~)
            set(this.info.currentTime, 'string', num2str(rtb.CurrentTime, '%.1f'));
        end
        
        function OdometryListener(this, rtb, ~)
            this.sim.stepOdometry(rtb.OutputPort(1).Data);
        end
        
        function rplidarEventListener(this, rtb, ~)
            length = rtb.OutputPort(3).Data;
            if length > 0
                range = double(rtb.OutputPort(1).Data(1:length))/1000;
                angle = double(rtb.OutputPort(2).Data(1:length));
            else
                range = 0;
                angle = 0;
            end           
            this.sim.stepScan(range', angle');
            this.redrawScan = true;
        end
        
        function hokuyoEventListener(this, rtb, ~)
            range = double(rtb.OutputPort(1).Data)/1000;
            angle = ((0.3515625 *((1:682) - 1)) - 120);
            this.sim.stepScan(range', angle);
            this.redrawScan = true;
        end
        
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Controls GUI Management
               
        
        function setCurrentTime(this, time)          
            set(this.info.currentTime, 'string', num2str(time, '%.1f'));
        end
        
        
        function type = getLogType(~, s)
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
        
        function loadLog(this, file)
            try
                s = load(file);
                type = this.getLogType(s);
                if ~strcmp(type, 'unknown');
                    switch type
                        case 'rplidar'
                            this.dlog = DataLog('pose', s.pose,'w', s.rph, 'range', s.range,'angle', s.angle);
                            this.settings.values.Lidar_x = 0.35;
                        case 'hokuyo'
                            this.dlog = DataLog('pose', s.pose, 'w', s.drpm, 'range', s.range);
                            this.settings.values.Lidar_x = 0.6;
                    end
                    if this.settings.values.GridMap_LimitsAuto
                        lims = this.dlog.limits();
                        this.settings.values.GridMap_LimitsMinX = lims(1) - 6;
                        this.settings.values.GridMap_LimitsMaxX = lims(2) + 6;
                        this.settings.values.GridMap_LimitsMinY = lims(1) - 6;
                        this.settings.values.GridMap_LimitsMaxY = lims(2) + 6;
                    end
                    this.initSimulation();
                    this.initPlots();
                    set(this.info.endTime, 'String', num2str(this.dlog.endTime, '%.1f'));
                    setStatus(this, this.STATUS.LOG_READY);
                else
                    errordlg('Unknown format data', 'Error');
                end
            catch
                errordlg('Problem loading the log', 'Error');
            end
        end
        
        function simulationStep(this)
            if this.dlog.remainingData()
                [samples, ts] = this.dlog.nextSample();
                this.setCurrentTime(ts);
                for s = samples
                    switch s.source
                        case 'wheels'
                            this.sim.stepOdometry(s.data.odo);
                        case 'lidar'
                            this.sim.stepScan(s.data.range/1000, s.data.angle);
                            this.redrawScan = true;
                    end
                end
            end
        end
        
        function b = continuaAndDiscard(this)
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

                this.settings.save(fullfile(parentpath(mfilename('fullpath')), 'settings.mat'));
                bdclose(this.settings.values.Simulink_model);
                %gui.settings.close()
                delete(this.fig);
                delete(this);
            catch
               errordlg('Problem during close callback', 'Error'); 
            end
        end
        
        % Toolbar callbaks %
        function changeMode_Callback(this, ~, ~)
            switch this.state.mode
                case this.MODE.ONLINE
                    if this.continuaAndDiscard()
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
                    this.setMode(this.MODE.ONLINE);
                    if strcmp(this.settings.values.Simulink_COM, '-')
                        this.setStatus(this.STATUS.IWK_CONNECT);
                    else
                        this.initModel();
                        this.setupModel();
                        this.setStatus(this.STATUS.IWK_READY);
                        
                    end
                    set(this.info.endTime, 'string', 'Inf');
            end
            set(this.info.currentTime, 'string', 0);
        end
        
        function loadModel_Callback(this, ~, ~)
            
        end
        
        function loadLog_Callback(this, ~, ~)
            path = this.settings.values.Log_path;
            [file, path] = uigetfile('*.mat', 'Load datalog', path);
            if path ~= 0
                this.settings.values.Log_path = path;
                this.loadLog(file);
            end
        end
        
        function stopButton_Callback(this, ~, ~)
            if this.state.mode == this.MODE.ONLINE
                this.setStatus(this.STATUS.BUSY);
                set_param( this.settings.values.Simulink_model, 'SimulationCommand', 'stop');
                this.setStatus(this.STATUS.IWK_READY);
            else
                this.setStatus(this.STATUS.BUSY);
                stop(this.timers.simlog);
                this.setStatus(this.STATUS.LOG_READY);
            end
        end
        
        
        function playButton_Callback(this, ~, ~)         
            if this.state.mode == this.MODE.ONLINE
                
                if this.continuaAndDiscard()
                    this.setStatus(this.STATUS.BUSY);
                    set(this.fig, 'Pointer','watch');
                    this.setupModel();
                    this.initSimulation();
                    set_param( this.settings.values.Simulink_model, 'SimulationCommand', 'start');
                    this.setStatus(this.STATUS.IWK_RUNNING);
                end
            else
                switch this.state.status
                    case this.STATUS.LOG_READY % start log simulation
                        this.setStatus(this.STATUS.BUSY);
                        set(this.fig, 'Pointer','watch');
                        this.dlog.init();
                        this.sim.settings.Rob.dt = this.dlog.dt;
                        this.initSimulation();
                        this.timers.simlog.period = this.dlog.dt;
                        start(this.timers.simlog);
                        this.setStatus(this.STATUS.LOG_RUNNING);
                        
                    case this.STATUS.LOG_RUNNING % pause log simulation
                        this.setStatus(this.STATUS.LOG_PAUSED);
                        stop(this.timers.simlog);
                        
                    case this.STATUS.LOG_PAUSED % resume log simulation
                        start(this.timers.simlog);
                        this.setStatus(this.STATUS.LOG_RUNNING);
                        
                    case this.STATUS.IWK_READY
                        this.setStatus(this.STATUS.IWK_RUNNING);
                end
            end
            set(this.fig, 'Pointer','arrow');
        end
        
        function stepButton_Callback(this, ~, ~)
            if this.state.status == this.STATUS.LOG_READY
                this.dlog.init();
                this.sim.settings.Rob_dt = this.dlog.dt;
                this.initSimulation();
                this.setStatus(this.STATUS.LOG_PAUSED);
            end
            
            if this.state.status == this.STATUS.LOG_PAUSED && this.dlog.remainingData()
                this.simulationStep();
                if this.dlog.remainingData()
                    this.setStatus(this.STATUS.LOG_PAUSED);
                else
                    this.setStatus(this.STATUS.BUSY);
                    this.setStatus(this.STATUS.LOG_READY);
                end
            end
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
            %             axes(gui.plots.map.hAxes);
            %             switch get(src, 'State')
            %                 case 'on'
            %                     zoom;
            %                 case 'off'
            %                     zoom off;
            %             end
        end
        
                
        function settings_Callback(this, src, ~)
            if this.state.mode == this.MODE.ONLINE && ~this.continuaAndDiscard()
                return;
            end
            
            this.settings.show();
            this.initSimulation();
            this.initPlots();
            
            if this.state.mode == this.MODE.ONLINE
                if strcmp(this.settings.values.Simulink_COM, '-')
                    this.setStatus(this.STATUS.IWK_CONNECT);
                else
                    
                    this.setupModel();
                    this.setStatus(this.STATUS.IWK_READY);
                end
            end
        end
        
        function saveLogButton_Callback(this, ~, ~)
            try
                dstr = strrep(strrep(datestr(now), ' ', '_'), ':', '-');
                id = this.settings.values.Simulink_count;
                filename = [num2str(id) '_' dstr];
                pathname = this.settings.values.Simulink_SavePath;
                [filename, pathname] =  uiputfile('*.mat', 'Save log', fullfile(pathname, filename));
                if pathname ~= 0
                    if strcmp(this.settings.values.Simulink_model, 'iWalkerRoboPeakModel')
                        rph = evalin('base','rph');
                        pose = evalin('base','pose');
                        range = evalin('base','range');
                        angle = evalin('base','angle');
                        count = evalin('base','count');
                        save(fullfile(pathname, filename), 'rph', 'pose', 'range', 'angle', 'count');
                    else
                        drpm = evalin('base', 'drpm');
                        pose = evalin('base', 'pose');
                        imu = evalin('base', 'imu');
                        forces = evalin('base', 'forces');
                        range = evalin('base', 'range');
                        save(fullfile(pathname, filename), 'drpm', 'pose', 'range', 'imu', 'forces');
                    end
                    this.settings.values.Simulink_SavePath = pathname;
                    this.settings.values.Simulink_count = id + 1;
                    this.logSaved = true;
                end
            catch
                errordlg('Problem saving the log', 'Error');
            end
        end
        
        
        
        % Timer callbacks
        function updatePlots_Callback(this, t, ~)
            s = this.settings.values;
            lid = this.sim.lid;
            ext = this.sim.ext;
            rob = this.sim.rob;
            mapPlot = this.plots.map;
            radPlot = this.plots.radar;
            if this.redrawScan
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
            end
            
            if s.MapPlot_drawRobot
                mapPlot.drawRobot('iWalker', rob.x, rob.S, [1 0 0]);
            end
            
            if s.MapPlot_drawRobotTrace && ~isempty(rob.x_hist)
                mapPlot.drawTrace('iWalkerTrace', rob.x_hist, [1 0 0], 1);
            end
            
            drawnow;
        end
        
        function errorPlots_Callback(this, t, event)
            this.setStatus(this.STATUS.BUSY);
            stop(this.timers.simlog);
            this.setStatus(this.STATUS.LOG_READY);
            errordlg('Error in drawing process', 'Error');
        end
        
        
        
        function updateSimlog_Callback(this, t, event)
            if this.dlog.remainingData()
                this.simulationStep();
            else
                this.setStatus(this.STATUS.BUSY);
                stop(this.timers.simlog);
                this.setStatus(this.STATUS.LOG_READY);
            end
        end
        
        function errorSimlog_Callback(this, t, event)
            this.setStatus(this.STATUS.BUSY);
            stop(this.timers.simlog);
            this.setStatus(this.STATUS.LOG_READY);
            errordlg('Error in simulation process', 'Error');
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



