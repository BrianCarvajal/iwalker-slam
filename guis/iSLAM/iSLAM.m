classdef (Sealed) iSLAM < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        fig         % the windows itself              
        sim         % EngineSimulator
        dlog        % DataLog
    end
    
    properties (Constant)
        STATUS = struct('UNREADY', 0, ...
                        'READY', 1, ...
                        'STARTING', 2);
        MODE = struct('ONLINE', 0, ...
                      'OFFLINE', 1);
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
    end
    
    
    methods (Static)
        function instance = GUI()
            persistent singleton
            if isempty(singleton) || ~isvalid(singleton)
                singleton = iSLAM();
            end
            instance = singleton;
            instance.show();
        end
    end
    
    methods (Access = private)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% GUI Initializations
        function gui = iSLAM()
            % Init SimulationEngine
            gui.sim = SimulationEngine();
            gui.setDefaultSettings()
            % Load icons
            gui.icons.iwalker = iconRead('walker.png');
            gui.icons.laptop = iconRead('laptop.png');
            gui.icons.play = iconRead('play.png');
            gui.icons.stop = iconRead('stop.png');
            gui.icons.log = iconRead('log.png');
            
            % Initialize state
            gui.state.mode = gui.MODE.ONLINE;
            gui.state.status = gui.STATUS.STARTING;
            
            % Create the figure
            gui.fig = figure('Visible', 'on', ...
                'name', 'iSLAM', ...
                'NumberTitle', 'off', ...
                'DockControls', 'off', ...
                'toolbar', 'auto', ...
                'MenuBar', 'none', ...
                'CloseRequestFcn', @gui.close_Callback);
            
            % Set icon GUI
            try
                iconpath = [parentpath(parentpath(mfilename('fullpath'))) filesep 'icons' filesep 'slam.gif'];
                warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
                javaFrame = get(gui.fig,'JavaFrame');
                javaFrame.setFigureIcon(javax.swing.ImageIcon(iconpath));
            end
            
            gui.initToolbar();
            
            % Create the main layout
            gui.layout.background = uiextras.VBox('Parent', gui.fig);           
            gui.layout.main = uiextras.HBoxFlex('Parent', gui.layout.background);
            gui.controls.slider = uicontrol('Parent', gui.layout.background, ...
                                            'Style', 'slider');
            gui.statusbar.margin(1) = uiextras.Empty('Parent', gui.layout.background);
            gui.statusbar.bar = uiextras.HBox('Parent', gui.layout.background);
            gui.statusbar.margin(2) =uiextras.Empty('Parent', gui.layout.background);
            
            gui.initStatusbar();
            
            
            set(gui.layout.background, 'Sizes', [-1 17 gui.statusbar.marginWidth 15 gui.statusbar.marginWidth]);
            
            
            

            gui.layout.leftPanel = uiextras.Panel('Parent', gui.layout.main);
%             gui.plots.map = axes('Parent', gui.layout.main, 'ActivePositionProperty', 'OuterPosition');
            gui.plots.map = MapAxes('Parent', gui.layout.main, 'sim', gui.sim);
            gui.layout.tabpanel = uiextras.TabPanel('Parent', gui.layout.main);
            %Set the width of the left column (lidar plot and info box) and map
            set( gui.layout.main, 'Sizes', [-1 -1.5 -0.5], 'Spacing', 6 );
            
            initPlots(gui);
            
            % Set initial status
            gui.setStatus(gui.STATUS.UNREADY);
            gui.setMode(gui.MODE.OFFLINE);
            % Set visible the figure
            gui.show();
        end
        
        function initPlots(gui)
                
        end
        
        function setDefaultSettings(gui)
            s.lid.port = '7';
            % Sample times
            s.st.wheels = 0.1;
            s.st.imu = 0.1;
            s.st.forces = 0.1;
            s.st.lid = 0.3;
            % Reactive control
            s.rc.leftLambda = 0;
            s.rc.rightLambda = 0;
            s.rc.leftNu = 0;
            s.rc.rightNu = 0;
            % GridMap
            s.gmp.res = 0.1;
            s.gmp.xlim.min = -15;
            s.gmp.xlim.max = 15;
            s.gmp.ylim.min = -15;
            s.gmp.ylim.max = 15;
            s.gmp.bitMode = false;
            s.path.loadLog = cd;
            s.path.saveLog = cd;
            
            gui.settings = s;
        end
        
        function initToolbar(gui)
            gui.toolbar.bar = uitoolbar(gui.fig);
            gui.toolbar.mode = uipushtool(gui.toolbar.bar, ...
                'CData', gui.icons.iwalker,...
                'TooltipString','Swap source to Log',...
                'HandleVisibility','off', ...
                'ClickedCallback', @gui.changeMode_Callback);
            
            gui.toolbar.loadLog = uipushtool(gui.toolbar.bar, ...
                'CData', gui.icons.log,...
                'TooltipString','Load a datalog',...
                'HandleVisibility','off', ...
                'ClickedCallback', @gui.loadLog_Callback);
        end
        
        function initStatusbar(gui)
            bar = gui.statusbar.bar;
            m = 5;
            gui.statusbar.marginWidth = m;
            c = [0.8 0.8 0.8];
            gui.statusbar.marginColor = c;
            gui.statusbar.margin = [gui.statusbar.margin uiextras.Empty('Parent', bar)];% left margin
            
            gui.info.status = uicontrol('Parent', bar, ...
                'style', 'text', ...
                'string', 'Status', ...
                'BackgroundColor', [205 205 255]/255);
            gui.statusbar.margin = [gui.statusbar.margin uiextras.Empty('Parent', bar)];
            gui.info.mode = uicontrol('Parent', bar, ...
                'style', 'text', ...
                'string', 'Mode', ...
                'TooltipString', 'Data source', ...
                'BackgroundColor', [1 1 1]);
            gui.statusbar.margin = [gui.statusbar.margin uiextras.Empty('Parent', bar)];
            gui.info.currentTime = uicontrol('Parent', bar, ...
                'style', 'text', ...
                'string', '0.0', ...
                'BackgroundColor', [1 1 1]);
            gui.statusbar.margin = [gui.statusbar.margin uiextras.Empty('Parent', bar)];
            gui.info.endTime = uicontrol('Parent', bar, ...
                'style', 'text', ...
                'string', '0.0', ...
                'BackgroundColor', [1 1 1]);
            gui.statusbar.margin = [gui.statusbar.margin uiextras.Empty('Parent', bar)]; % fill empty space
            gui.statusbar.margin = [gui.statusbar.margin uiextras.Empty('Parent', bar)]; % right margin
            set(bar, 'Sizes', [m 100 m 100 m 50 m 50 -1 m] );
            for h = gui.statusbar.margin
               set(h, 'BackgroundColor', c); 
            end
        end
        
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Internal GUI Management
        function setStatus(gui, status)
            switch status
                case gui.STATUS.STARTING
                    gui.state.status = status;
                    set(gui.info.status, ...
                        'string', 'Starting', ...
                        'backgroundcolor', [0 1 0]);
                case gui.STATUS.UNREADY
                    gui.state.status = status;
                    set(gui.info.status, ...
                        'string', 'Unready', ...
                        'backgroundcolor', [1 0 0]);
                case gui.STATUS.READY
                    gui.state.status = status;
                    set(gui.info.status, ...
                        'string', 'Ready', ...
                        'backgroundcolor', [0 1 0]);
                    
                otherwise
                    error('Not valid status');
            end
        end
        
        function setMode(gui, mode)
            switch mode
                case gui.MODE.OFFLINE;
                    gui.state.mode = mode;
                    set(gui.toolbar.mode, ...
                        'CData', gui.icons.laptop, ...
                        'TooltipString','Swap source to iWalker');
                    set(gui.info.mode, 'string', 'Datalog');
                    set(gui.toolbar.loadLog, 'visible', 'on');
                case gui.MODE.ONLINE;
                    gui.state.mode = mode;
                    set(gui.toolbar.mode, ...
                        'CData', gui.icons.iwalker, ...
                        'TooltipString','Swap source to Log');
                    set(gui.info.mode, 'string', 'iWalker');
                    set(gui.toolbar.loadLog, 'visible', 'off');
                otherwise
                    error('Erroneus mode');
            end
        end
        
        function loadLog(gui, file)
            try
                s = load(file);
                if isfield(s, 'pose') && ...
                        isfield(s, 'rph') && ...
                        isfield(s, 'range') && ...
                        isfield(s, 'angle')
                    gui.dlog = DataLog('pose', s.pose, ...
                        'w', s.rph, ...
                        'range', s.rph, ...
                        'angle', s.angle);
                    set(gui.info.endTime, 'String', num2str(gui.dlog.endTime, '%.1f'));
                    setStatus(gui, gui.STATUS.READY);
                else
                    errordlg('Bad format data', 'Error');
                end
            catch
                errordlg('Problem loading the log', 'Error');
            end
        end
        
        function loadConfiguration(path)
            
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Callbacks
        function close_Callback(gui, src, event)
            delete(gui.fig);
            delete(gui);
        end
        
        function changeMode_Callback(gui, src, event)
            switch gui.state.mode
                case gui.MODE.ONLINE
                    gui.setMode(gui.MODE.OFFLINE);
                case gui.MODE.OFFLINE
                    gui.setMode(gui.MODE.ONLINE);
            end
        end
        
        function loadLog_Callback(gui, src, event)
            path = gui.settings.path.loadLog;
            [file, path] = uigetfile('*.mat', 'Load datalog', path);
            if path ~= 0
                gui.settings.path.loadLog = path;
                gui.loadLog(file);
            end
        end
        
    end
    
    methods (Access = public)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Public GUI methods
        function show(gui)
            set(gui.fig, 'Visible', 'on');
        end
    end
    
end



