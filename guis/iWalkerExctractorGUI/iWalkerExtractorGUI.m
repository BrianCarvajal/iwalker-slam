function varargout = iWalkerExtractorGUI(varargin)
    % IWALKEREXTRACTORGUI MATLAB code for iWalkerExtractorGUI.fig
    %      IWALKEREXTRACTORGUI, by itself, creates a new IWALKEREXTRACTORGUI or raises the existing
    %      singleton*.
    %
    %      H = IWALKEREXTRACTORGUI returns the handle to a new IWALKEREXTRACTORGUI or the handle to
    %      the existing singleton*.
    %
    %      IWALKEREXTRACTORGUI('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in IWALKEREXTRACTORGUI.M with the given input arguments.
    %
    %      IWALKEREXTRACTORGUI('Property','Value',...) creates a new IWALKEREXTRACTORGUI or raises the
    %      existing singleton*.  Starting from the left, property value pairs are
    %      applied to the GUI before iWalkerExtractorGUI_OpeningFcn gets called.  An
    %      unrecognized property name or invalid value makes property application
    %      stop.  All inputs are passed to iWalkerExtractorGUI_OpeningFcn via varargin.
    %
    %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
    %      instance to run (singleton)".
    %
    % See also: GUIDE, GUIDATA, GUIHANDLES

    % Edit the above text to modify the response to help iWalkerExtractorGUI

    % Last Modified by GUIDE v2.5 27-Oct-2014 12:40:49

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @iWalkerExtractorGUI_OpeningFcn, ...
                       'gui_OutputFcn',  @iWalkerExtractorGUI_OutputFcn, ...
                       'gui_LayoutFcn',  [] , ...
                       'gui_Callback',   []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end

    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end
    % End initialization code - DO NOT EDIT
end

% --- Executes just before iWalkerExtractorGUI is made visible.
function iWalkerExtractorGUI_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to iWalkerExtractorGUI (see VARARGIN)

    % Choose default command line output for iWalkerExtractorGUI
    handles.output = hObject;
    
    if ~isfield(handles, 'init')
       handles.init = true;
    else
        return;
    end
    
    %% Load icons
    handles.playIcon = iconRead('play.png');
    handles.stopIcon = iconRead('stop.png');
    
    handles.landmarkIcon = iconRead('greenMarker.png');
    
    set(gcf, 'Pointer', 'watch');
    
    %% Load mouse pointers
    icon = iconRead('cross2.png');
    handles.crossPointer = ceil(icon(:,:,1));
    
    %% Hardcode Parameters
    handles.configFile = 'config.yaml';
    handles.lidar_location = [0.35, 0, 0];
    handles.isFocusiWalker = 0;
    handles.stopTime = Inf; 
    handles.laserCount = 0;
    handles.lidarFreq = 0;
    handles.lidarLength = 0;
    handles.zoomFocus = 10;
    handles.isGridMapUpdated = true;  
    handles.landmarks = [];
    handles.splitAndMergeInfo = [];   
    handles.modelName = 'iWalkerRoboPeakModel';
    handles.landmarkMode = false;
    handles.infoTextMode = false;
    %% User Inputs Parameters
    config = loadConfiguration(handles.configFile);
    handles.portNumber = config.portNumber;
    loadPorts(hObject);
    handles.odometrySampleTime = config.odometrySampleTime;
    handles.imuSampleTime = config.imuSampleTime;
    handles.forcesSampleTime = config.forcesSampleTime;
    handles.laserSampleTime = config.laserSampleTime;
    handles.leftLambda = config.leftLambda;
    handles.rightLambda = config.rightLambda;
    handles.leftNu = config.leftNu;
    handles.rightNu = config.rightNu;
    handles.gm_res = config.gm_res;
    handles.gm_xlim = config.gm_xlim;
    handles.gm_ylim = config.gm_ylim;
    handles.gm_8bitMode = config.gm_8bitMode;
    set(handles.odometrySampleTimeInput, 'String', num2str(handles.odometrySampleTime));
    set(handles.imuSampleTimeInput, 'String', num2str(handles.imuSampleTime));
    set(handles.forcesSampleTimeInput, 'String', num2str(handles.forcesSampleTime));
    set(handles.laserSampleTimeInput, 'String', num2str(handles.laserSampleTime));
    set(handles.leftLambdaInput, 'String', num2str(handles.leftLambda));
    set(handles.rightLambdaInput, 'String', num2str(handles.rightLambda));
    set(handles.leftNuInput, 'String', num2str(handles.leftNu));
    set(handles.rightNuInput, 'String', num2str(handles.rightNu));
    set(handles.xLimMinInput, 'String', num2str(handles.gm_xlim(1)));
    set(handles.xLimMaxInput, 'String', num2str(handles.gm_xlim(2)));
    set(handles.yLimMinInput, 'String', num2str(handles.gm_ylim(1)));
    set(handles.yLimMaxInput, 'String', num2str(handles.gm_ylim(2)));
    set(handles.resolutionInput, 'String', num2str(handles.gm_res));
    set(handles.bitModeInput, 'Value', handles.gm_8bitMode);
    
    
    guidata(hObject, handles);

    handles = initObjects(hObject);
    
    handles.state = 'NotReady';
    setState(hObject, handles.state);

    %% Main vertical separation
    hbf = uiextras.HBoxFlex( 'Parent', handles.viewPanel );
    leftPanel = uiextras.Panel('Parent', hbf);
    vbf = uiextras.VBoxFlex( 'Parent', leftPanel );
    handles.mapAxes = axes('Parent', hbf, 'ActivePositionProperty', 'OuterPosition');
    handles.lidarAxes = axes('Parent', vbf, 'ActivePositionProperty', 'Position');
    infoBox = uiextras.BoxPanel('Parent', vbf, 'Title', 'Info' );
    textGrid = uiextras.Grid( 'Parent', infoBox, 'Spacing', 5 );
    
    % First column: names
    uicontrol('Parent', textGrid,'Style', 'text','String', 'EKF [x, y, th]'); 
    uicontrol('Parent', textGrid,'Style', 'text','String', 'EKF [Pxx, Pyy, Pxy]');
    uicontrol('Parent', textGrid,'Style', 'text','String', 'Lidar freq');
    uicontrol('Parent', textGrid,'Style', 'text','String', 'Lidar samples ');
    % Second columns: values. We save the handlers
    handles.info.ekf_x = uicontrol('Parent', textGrid,'Style', 'text','String', '0 0 0');
    handles.info.ekf_P = uicontrol('Parent', textGrid,'Style', 'text','String', '0 0 0');
    handles.info.lidar_freq = uicontrol('Parent', textGrid,'Style', 'text','String', '0');
    handles.info.lidar_samples = uicontrol('Parent', textGrid,'Style', 'text','String', '0');
    set(textGrid, 'ColumnSizes', [-1 -1], 'RowSizes', [-1 -1 -1 -1]);
    set( hbf, 'Sizes', [-1 -1.5], 'Spacing', 6 );
    set( vbf, 'Sizes', [-5 -1], 'Spacing', 6 );
    
   
    handles = initPlots(handles);
    axes(handles.lidarAxes);
    polar(handles.lidarAxes, 0, 5); % set max radial ticks
    set(handles.lidarAxes, 'XLim', [-7 7], 'YLim', [-7 7]);
    delete(findall(handles.lidarAxes,'type','text'));
    whitebg([1 1 1]);
    handles.plLid = Plotter(handles.lidarAxes);
    view(handles.lidarAxes,-90,90);
    zoom(handles.lidarAxes, 2);
    hold on;
    axis equal;
%    % whitebg([0 0 0]);
%     
%     %% Init Global Map View
%     
%     globalMap = axes('Parent', hbf, 'ActivePositionProperty', 'OuterPosition');
%     set(globalMap, 'LooseInset', get(globalMap,'TightInset'));
%     %set(globalMap, 'OuterPosition', [0. 0. 0. 0.]);
%    % set(globalMap,'xtick',[], 'ytick', []);
%     
%     imgmap = imshow(handles.gm.image, handles.gm.R);
%     hold on;
%     grid on;
%     axis xy;
%     handles.imgmap = imgmap;
%     handles.pl = Plotter(globalMap);
%     handles.pl.plotRobot(handles.rob.x, 'iWalker', 'r');
%     %% Init Views
%     whitebg([0 0 0]);
%     h = polar(handles.axes, 0, 6); % set max radial ticks
%     
%     camroll(90);
%     delete(findall(h,'type','text'));
%     hold on;
%     axis equal;
%     handles.pl = Plotter();
 
    %axis([-6 6 -6 6]);
   % whitebg([0 0 0]);
    
    
    initModel(handles);
    
    %% Timer for plots refresh
    t = timer;
    t.Period = 0.2;
    t.StartDelay = 0;
    t.ExecutionMode = 'fixedRate';
    t.TimerFcn = {@timerCallback};
    t.UserData = hObject;
    handles.plotTimer = t;
    
    % Update handles structure
    guidata(hObject, handles);
    %loadPorts(hObject);
    updatePlots(hObject, handles);
    setState(hObject, 'Ready');
    set(gcf, 'Pointer', 'arrow');  
end


% --- Outputs from this function are returned to the command line.
function varargout = iWalkerExtractorGUI_OutputFcn(hObject, eventdata, handles) 
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;
end 

% --- Executes when user attempts to close mainWindow.
function mainWindow_CloseRequestFcn(hObject, eventdata, handles)
    % hObject    handle to mainWindow (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: delete(hObject) closes the figure
    
    try     
        modelName = handles.modelName;
        set_param(modelName, 'SimulationCommand', 'stop');
        %bdclose(modelName);
        close_system(modelName);
    catch
        errordlg('Problem closing simulink model', 'Error');
    end
    try 
        stop(handles.plotTimer);
        delete(handles.plotTimer);
    catch
        errordlg('Problem deleting timer', 'Error');
    end
    try
        saveConfiguration(handles.configFile, handles);
    catch
        errordlg('Problem savig configuration', 'Error');
    end
    delete(hObject);
end

function config = defaultConfiguration()
    config.portNumber = '7';
    config.odometrySampleTime = 0.1;
    config.imuSampleTime = 0.1;
    config.forcesSampleTime = 0.1;
    config.laserSampleTime = 0.3;
    config.leftLambda = 0;
    config.rightLambda = 0;
    config.leftNu = 0;
    config.rightNu = 0;
    config.gm_res = 0.1;
    config.gm_xlim = [-15 15];
    config.gm_ylim = [-15 15];
    config.gm_8bitMode = false;
end
% Try to load the configuration file at dir and return it. 
% If the file does not exist, it returns a default configuration.
function config = loadConfiguration(filepath)
    if exist(filepath, 'file') == 2      
        config = ReadYaml(filepath);
        config.gm_xlim = cell2mat(config.gm_xlim);
        config.gm_ylim = cell2mat(config.gm_ylim);
    else
        config = defaultConfiguration();
    end
end

function saveConfiguration(filepath, handles)
    config.portNumber = handles.portNumber;
    config.odometrySampleTime = handles.odometrySampleTime;
    config.imuSampleTime = handles.imuSampleTime;
    config.forcesSampleTime = handles.forcesSampleTime;
    config.laserSampleTime = handles.laserSampleTime;
    config.leftLambda = handles.leftLambda;
    config.rightLambda = handles.rightLambda;
    config.leftNu = handles.leftNu;
    config.rightNu = handles.rightNu;
    config.gm_res = handles.gm_res;
    config.gm_xlim = handles.gm_xlim;
    config.gm_ylim = handles.gm_ylim;
    config.gm_8bitMode = handles.gm_8bitMode;
    WriteYaml(filepath, config);
end


function MapClickCallback( hObject , eventData )
    handles = guidata(hObject);    
    %if handles.landmarkMode
    if strcmp(get(handles.landmarkButton, 'state'), 'on')
        disp('click!');
        hAxes = get(hObject, 'Parent');
        coord = get(hAxes, 'CurrentPoint');
        coord = coord(1, 1:2);
        disp(coord); 
        %%Add new landmark at coord        
        land = Landmark(coord', [0 0]', 0, 0, [], []);
        
        % Search of the nearest extracted landmark
        [dist, id] = land.best_match(handles.landmarks);
        if dist < 0.50
           land = handles.landmarks(id); 
           handles.map.addLandmarks(land); 
           handles.ekf.innovation(land);
           handles.rob.x(1:3) = handles.ekf.x_est(1:3);
           set(handles.numLandmarksText, 'string', num2str(length(handles.map.landmarks)));
           updatePlots(hObject, handles);
        end
%         handles.map.addLandmarks(land); 
%         handles.ekf.innovation(land);
%         updatePlots(hObject, handles);
    end  
end



function handles = initPlots(handles)
    %% Init Map Plot
    %cla(handles.mapAxes, 'reset');
    %colordef('black');
    axes(handles.mapAxes);
    hold off;
  
    set(handles.mapAxes, 'LooseInset', get(handles.mapAxes,'TightInset'));
    
    %set(handles.mapAxes,'xtick',[], 'ytick', []);
    imgmap = imshow(handles.gm.image, handles.gm.R);
    set(imgmap, 'Parent', handles.mapAxes);
    hold on;
    set(imgmap,'ButtonDownFcn',@MapClickCallback);
    set(handles.mapAxes, 'box', 'on');
    grid off;
    axis xy;
    handles.imgmap = imgmap;
    handles.plMap = Plotter(handles.mapAxes);
   % handles.plMap.plotRobot(handles.rob.x, 'iWalker', 'r');
    
    %% Init Lidar Plot
    %axes(handles.lidarAxes);
    %set(handles.lidarAxes, 'box', 'on');
    %polar(handles.lidarAxes, 0, 5); % set max radial ticks
   % delete(findall(handles.lidarAxes,'type','text'));
    %whitebg([1 1 1]);
    %handles.plLid = Plotter(handles.lidarAxes);    
    %hold on;
    %axis equal;
    drawnow;
end

function timerCallback(t, ~)
    hObject = get(t,'UserData');
    handles = guidata(hObject);
    updatePlots(hObject, handles);
    updateInfo(handles);
end

function updatePlots(hObject, handles)
    rob = handles.rob;
    lid = handles.lid;
    gm = handles.gm;
    plMap = handles.plMap;
    plLid = handles.plLid;
    landmarks = handles.landmarks;
    splitAndMergeInfo = handles.splitAndMergeInfo;

    %% Map
    if handles.isGridMapUpdated
        set(handles.imgmap, 'CData', gm.image);
        plMap.plotPoints(lid.pw(1,:), lid.pw(2,:), 'scan', [1 0 0]);
        handles.isGridMapUpdated = false; 
    end
    %plMap.plotRobot(rob.x, 'iWalker', [1 0 0]);
%     if ~isempty(rob.x_hist)
%         lenTrace = min(size(rob.x_hist,1), 500);
%         xh = rob.x_hist(end-lenTrace+1:end, 1:2); 
%         xh = xh(1:end, :);
%         plMap.plotTrace(xh, 'trace.iWalker', [0.8 0.3 0]); 
%     end
    plMap.plotScanArea(lid.pw(1,:), lid.pw(2,:), 'scan', [1 0.2 0.4], 0.5);
    plMap.plotRobot(handles.ekf.x_est(1:3), 'ekf', [30 145 200]./255);
    plMap.plotErrorXY(handles.ekf.P_est(1:2,1:2), handles.ekf.x_est(1:3), 'errorXY', 'c');
    plMap.plotErrorAngle(handles.ekf.P_est(3,3), handles.ekf.x_est(1:3), 'errorAngle', 'y');
    
    mlands = handles.map.landmarks;
    if ~isempty(mlands)
       plMap.plotKnownLandmarks(mlands, 'MapLandmarks');
    end
    
    %if ~isempty(handles.landmarks)
        plMap.plotAnonymousLandmarks(landmarks, 'ExtractedLandmarks');
    %end
    
    
    %% Polar plot
    plLid.plotRobot([-0.35 0 0]', 'robL', [145 200 30]./255);
    
    if ~isempty(splitAndMergeInfo)
        plLid.plotSplitAndMerge(splitAndMergeInfo, 's&m');
    end 
    %plLid.plotPoints(lid.p(1,:), lid.p(2,:), 'scan', [0 1 0.3]);
    plLid.plotScanArea(lid.p(1,:), lid.p(2,:), 'scan', [0 0.2 0.8], 0.4);
%     if ~isempty(handles.landmarks)
%         plLid.plotAnonymousLandmarks(landmarks, 'landmarks');
%     end

    drawnow;
    guidata(hObject, handles);
end

function updateInfo(handles)
    ekf_P = [handles.ekf.P_est(1,1) ...
             handles.ekf.P_est(2,2)  ...
             handles.ekf.P_est(1,2)];
            
    set(handles.info.ekf_x, 'string', num2str(handles.ekf.x_est(1:3)','[%.2f]'));
    set(handles.info.ekf_P, 'string', num2str(ekf_P,'[%.2f]'));
    set(handles.info.lidar_freq, 'string', num2str(handles.lidarFreq, '%.1f'));
    set(handles.info.lidar_samples, 'string', num2str(handles.lidarLength, '%.2f'));
end


function handles = initObjects(hObject)
    handles = guidata(hObject);
    % Lidar
    handles.lid = RPLIDAR(); 
    
    % Landmark Map
    handles.map = LandmarkMap('manual mapping');
    
    % Landmar Extractor
    handles.ext = LandmarkExtractor();
    handles.ext.validRange = [0.10 7];
    handles.ext.maxClusterDist = 0.15;
    handles.ext.splitDist = 0.1;
    handles.ext.angularTolerance = 15.0;
    handles.ext.maxOutliers = 3;
        
    % Robot
    handles.rob = DifferentialRobot();
    handles.rob.x0 = [0; 0; pi/2];
    handles.rob.dt = handles.odometrySampleTime;
    handles.rob.attachLidar(handles.lid, handles.lidar_location);
    
    
    % EKF
    V = diag([0.005, 0.1*pi/180].^2);
    W = diag([0.1, 0.05*pi/180].^2);
    P0 = diag([0.05, 0.05, 0.01].^2);
    handles.ekf = EKFSLAM(handles.rob, V, P0, 'map', handles.map, 'estMap', false, 'W', W);
    handles.ekf.x_est(1:3) = handles.rob.x(1:3);
    % Grid Map
    if handles.gm_8bitMode
        handles.gm = GridMap8b(handles.gm_res, handles.gm_xlim, handles.gm_ylim);
    else
        handles.gm = GridMap(handles.gm_res, handles.gm_xlim, handles.gm_ylim);
    end
    guidata(hObject, handles);
end

function initModel(handles)
    try
     %% Open and set model
         modelName = handles.modelName;
         load_system(modelName); % change for load_system for not open the model window

         % When the model starts, call the localAddEventListener function
         set_param(modelName,'StartFcn',['localAddEventListener(''' modelName ''')']);

        % Simulink may optimise your model by integrating all your blocks. To
        % prevent this, you need to disable the Block Reduction in the Optimisation
        % settings.
        set_param(modelName,'BlockReduction','off');
    catch
        errordlg('Problem loading simulink model', 'Error');
    end
end

function setupModel(handles)
    disp('Configurig model...');
    modelName = handles.modelName;
    
    %Setup RPLidar block
    stl = handles.laserSampleTime;
    set_param([modelName '/RPLidar'], ...
                'SampleTime', num2str(stl),...
                'COM', handles.portNumber, ...
                'UserData', gcbo);
            
    % Setup iWheels block
    stw = handles.odometrySampleTime;
    set_param([modelName '/iWheels'], ...
                'SampleTime', num2str(stw),...
                'UserData', gcbo);
            
    % Setup iWheels block
    set_param([modelName '/High Frequency Odometry'], ...
                'UserData', gcbo);
    
    % Setup Sample Tyme Sync block
    sts = min([stl stw]);
    set_param([modelName '/Sample Time Sync'], ...
                'SampleTime', num2str(sts), ...
                'UserData', gcbo);      
            
    handles.stopTime = Inf;
    set(handles.stopTimeText, 'string', handles.stopTime);
    guidata(gcbo, handles);
    disp('Done!');
end

function eh = localAddEventListener(modelName)
    eh = [];
    eh = [eh add_exec_event_listener([modelName '/Sample Time Sync'], ...
                                     'PostOutputs', @sampleTimeSyncEventListener)];
                        
    eh = [eh add_exec_event_listener([modelName '/RPLidar'], ...
                                     'PostOutputs', @laserEventListener)];
                                 
%     eh = [eh add_exec_event_listener([modelName '/iWheels'], ...
%                                      'PostOutputs', @iWheelsEventListener)];
                                 
    eh = [eh add_exec_event_listener([modelName '/High Frequency Odometry'], ...
                                     'PostOutputs', @OdometryListener)];
end

% % The function to be called when event is registered.
% function currentTimeEventListener(rtb, eventdata)
%     handles = guidata(get_param(rtb.BlockHandle, 'UserData'));
%     t = rtb.CurrentTime;
% %     a = fix(t);
% %     b = fix((t - a)*10);
% %     s = [num2str(a) '.' num2str(b)];
%     s = num2str(t, '%.1f');
%     set(handles.currentTimeText, 'String', s);
%     
%     if t > handles.stopTime
%        %setState(hObject, 'Stop'); 
%     end   
% end

% The function to be called when event is registered.
function laserEventListener(rtb, eventdata)
    hObject = get_param(rtb.BlockHandle, 'UserData');
    handles = guidata(hObject);
    lid = handles.lid;
    ext = handles.ext;
    gm = handles.gm;
    map = handles.map;
    range = rtb.OutputPort(1).Data;
    %Averiguar por que es necesaria la resta. Sin ella, se obtienen los
    %puntos reflejados en el eje X
    angle = rtb.OutputPort(2).Data; 
    length = rtb.OutputPort(3).Data;
    handles.lidarLength = length;
    handles.lidarFreq = rtb.OutputPort(4).Data;
    lid.setScan(range(1:length)'/1000, angle(1:length)');

    %T = lid.globalTransform;
    %p = pTransform(lid.p, T);

    
    [landmarks, info] = ext.extract(lid.range, lid.p, lid.pw);
    handles.landmarks = landmarks;
    handles.splitAndMergeInfo = info;
    for lan = landmarks
       if map.containsLandmark(lan, 0.30)
          handles.ekf.innovation(lan);
       end
    end
    handles.rob.x = handles.ekf.x_est(1:3);
    %handles.laserCount = mod(handles.laserCount + 1, 1);
   % if handles.laserCount == 0

        %xs = pTransform([0;0], T);
    %xs = lid.x;
    rlim = [0.02 5];
    gm.update(lid.x, lid.pw, lid.range, rlim);
    handles.isGridMapUpdated = true;
    %end
    guidata(hObject, handles);
end

% The function to be called when event is registered.
function iWheelsEventListener(rtb, eventdata)
    handles = guidata(get_param(rtb.BlockHandle, 'UserData'));
    %disp(rtb.OutputPort(1).Data);
    rph = [rtb.OutputPort(1).Data rtb.OutputPort(2).Data];
    odo = handles.rob.updateDifferential(rph);
end

function OdometryListener(rtb, eventdata)
    handles = guidata(get_param(rtb.BlockHandle, 'UserData'));
    odo = rtb.OutputPort(1).Data;
    handles.rob.updateOdometry(odo);
    if odo(1) ~= 0 || odo(1) ~= 0
        handles.ekf.prediction(odo);
    end
end

% The function to be called when event is registered.
function imuEventListener(rtb, eventdata)
    handles = guidata(get_param(rtb.BlockHandle, 'UserData'));
    %disp(rtb.OutputPort(1).Data);
    
end

% The function to be called when event is registered.
function forcesEventListener(rtb, eventdata)
    handles = guidata(get_param(rtb.BlockHandle, 'UserData'));
    %disp(rtb.OutputPort(1).Data);
    
end




function setState(hObject, state)  
    handles = guidata(hObject);
    modelName = handles.modelName;
    state = upper(state);
    handles.state = state;
    switch state
        case 'NOTREADY'
            set(handles.stateText, 'string', 'Not Ready');
            set(handles.stateText, 'backgroundcolor', [230 230 90]./255);
            set(handles.runStopButton, 'enable', 'off');
            guidata(hObject, handles);
        case 'READY'
            set(handles.stateText, 'string', 'Ready');
            set(handles.stateText, 'backgroundcolor', [90 160 230]./255);
            set(handles.runStopButton, 'enable', 'on');
            set(handles.runStopButton, 'CData', handles.playIcon);
            set(handles.simulinkButton, 'enable', 'on');
            guidata(hObject, handles);
        case 'RUN'
            prevPointer = get(gcf, 'Pointer');
            set(gcf, 'Pointer', 'watch');
            set(handles.stateText, 'string', 'Starting');
            set(handles.runStopButton, 'enable', 'off');
            set(handles.simulinkButton, 'enable', 'off');
            set(handles.stateText, 'backgroundcolor', [230 230 90]./255);
            strid = nextExperimentID();
            set(handles.experimentID, 'String', strid);
            setupModel(handles)
            handles = initObjects(hObject);
            handles = initPlots(handles);
            guidata(hObject, handles);
            set_param( modelName, 'SimulationCommand', 'start');
            set(handles.runStopButton, 'CData', handles.stopIcon);
            start(handles.plotTimer);
            set(handles.runStopButton, 'enable', 'on');
            set(handles.landmarkButton, 'enable', 'on');
            set(handles.stateText, 'string', 'Running');
            set(handles.stateText, 'backgroundcolor', [130 230 115]./255);
            set(gcf, 'Pointer', prevPointer);
            guidata(hObject, handles);
        case 'STOP'
            set(handles.runStopButton, 'enable', 'off');
            stop(handles.plotTimer);
            set_param( modelName, 'SimulationCommand', 'stop');
            %dstr = strrep(strrep(datestr(now), ' ', '_'), ':', '-');
            %id = get(handles.experimentID, 'String');
            %filename = [id '_' dstr];
            %drpm = evalin('base','drpm');
            %pose = evalin('base','pose');
            %accelgyro = evalin('base','accelgyro');
            %forces = evalin('base','forces');
            %range = evalin('base', 'range');
            %save(filename, 'drpm', 'pose', 'accelgyro', 'forces', 'range');
            guidata(hObject, handles);
            setState(hObject, 'READY');
        otherwise
            set(handles.stateText, 'string', 'BAD STATE');
            set(handles.stateText, 'backgroundcolor', 'r');
            guidata(hObject, handles);
    end
end

function strid = nextExperimentID()
    try 
        x = load('lastID', 'id');
        id = x.id;
    catch
        id = 1;
    end
    
    strid = num2str(id , '%05d');
    id = id + 1;
    save('lastID', 'id');
end




function currentTimeText_Callback(hObject, eventdata, handles)
% hObject    handle to currentTimeText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of currentTimeText as text
%        str2double(get(hObject,'String')) returns contents of currentTimeText as a double

end

% --- Executes during object creation, after setting all properties.
function currentTimeText_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to currentTimeText (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --------------------------------------------------------------------
function openLogButton_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to openLogButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    path =  uigetfile();
    if path ~= 0
        try
            load(path, 'iWheelsLog');
            load(path, 'laserLog');
            assignin('base', 'log', load(path));
            dlog = load(path);
            setupModel(handles, dlog);
            setState(hObject, 'Ready');
        catch 
            errordlg('Bad format data', 'Error');
        end
    end
end



function stateText_Callback(hObject, eventdata, handles)
% hObject    handle to stateText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stateText as text
%        str2double(get(hObject,'String')) returns contents of stateText as a double

end
% --- Executes during object creation, after setting all properties.
function stateText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stateText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end



function stopTimeText_Callback(hObject, eventdata, handles)
% hObject    handle to stopTimeText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stopTimeText as text
%        str2double(get(hObject,'String')) returns contents of stopTimeText as a double
end

% --- Executes during object creation, after setting all properties.
function stopTimeText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stopTimeText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function odometrySampleTimeInput_Callback(hObject, eventdata, handles)
% hObject    handle to odometrySampleTimeInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of odometrySampleTimeInput as text
%        str2double(get(hObject,'String')) returns contents of odometrySampleTimeInput as a double
    st = str2double(get(hObject,'String'));
    if isnan(st)
        set(hObject, 'String', num2str(handles.odometrySampleTime));
    else
        handles.odometrySampleTime = st;
        set(hObject, 'String', num2str(st));
    end
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function odometrySampleTimeInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to odometrySampleTimeInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function imuSampleTimeInput_Callback(hObject, eventdata, handles)
% hObject    handle to imuSampleTimeInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of imuSampleTimeInput as text
%        str2double(get(hObject,'String')) returns contents of imuSampleTimeInput as a double
    st = str2double(get(hObject,'String'));
    if isnan(st)
        set(hObject, 'String', num2str(handles.imuSampleTime));
    else
        handles.imuSampleTime = st;
        set(hObject, 'String', num2str(st));
    end
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function imuSampleTimeInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imuSampleTimeInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function forcesSampleTimeInput_Callback(hObject, eventdata, handles)
% hObject    handle to forcesSampleTimeInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of forcesSampleTimeInput as text
%        str2double(get(hObject,'String')) returns contents of forcesSampleTimeInput as a double
    st = str2double(get(hObject,'String'));
    if isnan(st)
        set(hObject, 'String', num2str(handles.forcesSampleTime));
    else
        handles.forcesSampleTime = st;
        set(hObject, 'String', num2str(st));
    end
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function forcesSampleTimeInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to forcesSampleTimeInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function laserSampleTimeInput_Callback(hObject, eventdata, handles)
% hObject    handle to laserSampleTimeInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of laserSampleTimeInput as text
%        str2double(get(hObject,'String')) returns contents of laserSampleTimeInput as a double
    st = str2double(get(hObject,'String'));
    if isnan(st)
        set(hObject, 'String', num2str(handles.laserSampleTime));
    else
        handles.laserSampleTime = st;
        set(hObject, 'String', num2str(st));
    end
    guidata(hObject, handles);
end
% --- Executes during object creation, after setting all properties.
function laserSampleTimeInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to laserSampleTimeInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end



function leftNuInput_Callback(hObject, eventdata, handles)
% hObject    handle to leftNuInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of leftNuInput as text
%        str2double(get(hObject,'String')) returns contents of leftNuInput as a double
    value = floor(str2double(get(hObject,'String')));
    if isnan(value) || value < 0 || value > 100
        set(hObject, 'String', num2str(handles.leftNu));
    else
        handles.leftNu = value;
        set(hObject, 'String', num2str(value));
    end
    guidata(hObject, handles); 
end

% --- Executes during object creation, after setting all properties.
function leftNuInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to leftNuInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function rightNuInput_Callback(hObject, eventdata, handles)
% hObject    handle to rightNuInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rightNuInput as text
%        str2double(get(hObject,'String')) returns contents of rightNuInput as a double
    value = floor(str2double(get(hObject,'String')));
    if isnan(value) || value < 0 || value > 100
        set(hObject, 'String', num2str(handles.rightNu));
    else
        handles.rightNu = value;
        set(hObject, 'String', num2str(value));
    end
    guidata(hObject, handles); 
end

% --- Executes during object creation, after setting all properties.
function rightNuInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rightNuInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function leftLambdaInput_Callback(hObject, eventdata, handles)
% hObject    handle to leftLambdaInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of leftLambdaInput as text
%        str2double(get(hObject,'String')) returns contents of leftLambdaInput as a double
    value = floor(str2double(get(hObject,'String')));
    if isnan(value) || value < 0 || value > 100
        set(hObject, 'String', num2str(handles.leftLambda));
    else
        handles.leftLambda = value;
        set(hObject, 'String', num2str(value));
    end
    guidata(hObject, handles); 
end
% --- Executes during object creation, after setting all properties.
function leftLambdaInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to leftLambdaInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function rightLambdaInput_Callback(hObject, eventdata, handles)
% hObject    handle to rightLambdaInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rightLambdaInput as text
%        str2double(get(hObject,'String')) returns contents of rightLambdaInput as a double
    value = floor(str2double(get(hObject,'String')));
    if isnan(value) || value < 0 || value > 100
        set(hObject, 'String', num2str(handles.rightLambda));
    else
        handles.rightLambda = value;
        set(hObject, 'String', num2str(value));
    end
    guidata(hObject, handles);   
end
% --- Executes during object creation, after setting all properties.
function rightLambdaInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rightLambdaInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end



% --- Executes during object creation, after setting all properties.
function laserCOMInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to laserCOMInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on selection change in laserCOMInput.
function laserCOMInput_Callback(hObject, eventdata, handles)
% hObject    handle to laserCOMInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns laserCOMInput contents as cell array
%        contents{get(hObject,'Value')} returns selected item from laserCOMInput
    contents = cellstr(get(hObject,'String'));
    port = contents{get(hObject,'Value')};
    if ~isempty(strfind(port, 'COM'))
       handles.portNumber = strrep(port, 'COM', '');
    end
    guidata(hObject, handles);
end

% --- Executes on button press in loadPortsButton.
function loadPortsButton_Callback(hObject, eventdata, handles)
% hObject    handle to loadPortsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    loadPorts(hObject);
end

function loadPorts(hObject)
    handles = guidata(hObject);
    info = instrhwinfo('serial');
    ports = info.AvailableSerialPorts;
    if isempty(ports)
        set(handles.laserCOMInput, 'String', '-');
    else
        set(handles.laserCOMInput, 'String', ports);
        handles.portNumber = strrep(ports{1}, 'COM', '');
        % guidata(hObject, handles);
        % setState(hObject, 'Ready');
    end
    guidata(hObject, handles);
end



function experimentID_Callback(hObject, eventdata, handles)
% hObject    handle to experimentID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of experimentID as text
%        str2double(get(hObject,'String')) returns contents of experimentID as a double

end
% --- Executes during object creation, after setting all properties.
function experimentID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to experimentID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function txt = customDataCursorUpdate(~,hObject)
    pos = get(hObject, 'Position');
    target = get(hObject, 'Target');
    tag = get(target, 'Tag');
    txt = { ...
        ['Tag: ', tag], ...
        ['x: ', num2str(pos(1))],...
        ['y: ', num2str(pos(2))]};
    data = get(target, 'UserData');
    if ~isempty(data)
       disp(data); 
    end
end


% --- Executes on button press in addLanmdarkButton.
function addLanmdarkButton_Callback(hObject, eventdata, handles)
% hObject    handle to addLanmdarkButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    landmarkMode = get(hObject, 'Value');
    if landmarkMode
       handles.landmarkMode = 1;
       set(gcf, 'Pointer', 'cross');
       set(handles.zoomInButton, 'state', 'off');
       set(handles.zoomOutButton, 'state', 'off');
       set(handles.panButton, 'state', 'off');
       set(handles.zoomInButton, 'enable', 'off');
       set(handles.zoomOutButton, 'enable', 'off');
       set(handles.panButton, 'enable', 'off');
       zoom off;
       pan off;
    else
       set(gcf, 'Pointer', 'arrow');
       handles.landmarkMode = 0;
       set(handles.zoomInButton, 'enable', 'on');
       set(handles.zoomOutButton, 'enable', 'on');
       set(handles.panButton, 'enable', 'on');
    end
    guidata(hObject, handles);
end



function numLandmarksText_Callback(hObject, eventdata, handles)
% hObject    handle to numLandmarksText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numLandmarksText as text
%        str2double(get(hObject,'String')) returns contents of numLandmarksText as a double
end

% --- Executes during object creation, after setting all properties.
function numLandmarksText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numLandmarksText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --------------------------------------------------------------------
function simulinkButton_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to simulinkButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    actived = strcmp(get(hObject, 'State'), 'on');
    if actived
        bdclose(handles.modelName);
        open_system(handles.modelName);
    else
        bdclose(handles.modelName);
        load_system(handles.modelName);
    end
end


% --------------------------------------------------------------------
function runStopButton_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to runStopButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    switch upper(handles.state)
        case 'READY'
            setState(hObject, 'RUN');
        case 'RUN'
            setState(hObject, 'STOP');
    end
end


% --------------------------------------------------------------------
function landmarkButton_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to landmarkButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    landmarkMode = strcmp(get(hObject, 'State'), 'on');
    if landmarkMode
       handles.landmarkMode = true;
       set(gcf, 'Pointer', 'custom', ...
                'PointerShapeCData', handles.crossPointer, ...
                'PointerShapeHotSpot', [9 9]);
       set(handles.zoomInButton, 'state', 'off');
       set(handles.zoomOutButton, 'state', 'off');
       set(handles.panButton, 'state', 'off');
       set(handles.zoomInButton, 'enable', 'off');
       set(handles.zoomOutButton, 'enable', 'off');
       set(handles.panButton, 'enable', 'off');
       zoom off;
       pan off;
    else
       set(gcf, 'Pointer', 'arrow');
       handles.landmarkMode = false;
       set(handles.zoomInButton, 'enable', 'on');
       set(handles.zoomOutButton, 'enable', 'on');
       set(handles.panButton, 'enable', 'on');
    end
    guidata(hObject, handles);
end



function resolutionInput_Callback(hObject, eventdata, handles)
% hObject    handle to resolutionInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of resolutionInput as text
%        str2double(get(hObject,'String')) returns contents of resolutionInput as a double
    value = str2double(get(hObject,'String'));
    if isnan(value) || value <= 0
        set(hObject, 'String', num2str(handles.gm_res));
    else
        handles.gm_res = value;
        set(hObject, 'String', num2str(value));
    end
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function resolutionInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resolutionInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function xLimMaxInput_Callback(hObject, eventdata, handles)
% hObject    handle to xLimMaxInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xLimMaxInput as text
%        str2double(get(hObject,'String')) returns contents of xLimMaxInput as a double
    value = str2double(get(hObject,'String'));
    if isnan(value) || value < handles.gm_xlim(1)
        set(hObject, 'String', num2str(handles.gm_xlim(2)));
    else
        handles.gm_xlim(2) = value;
        set(hObject, 'String', num2str(value));
    end
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function xLimMaxInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xLimMaxInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function xLimMinInput_Callback(hObject, eventdata, handles)
% hObject    handle to xLimMinInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xLimMinInput as text
%        str2double(get(hObject,'String')) returns contents of xLimMinInput as a double
    value = str2double(get(hObject,'String'));
    if isnan(value) || value > handles.gm_xlim(2)
        set(hObject, 'String', num2str(handles.gm_xlim(1)));
    else
        handles.gm_xlim(1) = value;
        set(hObject, 'String', num2str(value));
    end
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function xLimMinInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xLimMinInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function yLimMaxInput_Callback(hObject, eventdata, handles)
% hObject    handle to yLimMaxInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yLimMaxInput as text
%        str2double(get(hObject,'String')) returns contents of yLimMaxInput as a double
    value = str2double(get(hObject,'String'));
    if isnan(value) || value < handles.gm_ylim(1)
        set(hObject, 'String', num2str(handles.gm_ylim(2)));
    else
        handles.gm_ylim(2) = value;
        set(hObject, 'String', num2str(value));
    end
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function yLimMaxInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yLimMaxInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function yLimMinInput_Callback(hObject, eventdata, handles)
% hObject    handle to yLimMinInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yLimMinInput as text
%        str2double(get(hObject,'String')) returns contents of yLimMinInput as a double
    value = str2double(get(hObject,'String'));
    if isnan(value) || value > handles.gm_ylim(2)
        set(hObject, 'String', num2str(handles.gm_ylim(1)));
    else
        handles.gm_ylim(1) = value;
        set(hObject, 'String', num2str(value));
    end
    guidata(hObject, handles); 
end

% --- Executes during object creation, after setting all properties.
function yLimMinInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yLimMinInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on button press in bitModeInput.
function bitModeInput_Callback(hObject, eventdata, handles)
% hObject    handle to bitModeInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bitModeInput
    handles.gm_8bitMode = get(hObject, 'Value');
    guidata(hObject, handles); 
end


% --- Executes on button press in applyMapButton.
function applyMapButton_Callback(hObject, eventdata, handles)
% hObject    handle to applyMapButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles = initObjects(hObject);
    handles = initPlots(handles);
    updatePlots(hObject, handles);
    guidata(hObject, handles);
end

