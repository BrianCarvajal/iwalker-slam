function varargout = iWalkerGUI(varargin)
    % IWALKERGUI MATLAB code for iWalkerGUI.fig
    %      IWALKERGUI, by itself, creates a new IWALKERGUI or raises the existing
    %      singleton*.
    %
    %      H = IWALKERGUI returns the handle to a new IWALKERGUI or the handle to
    %      the existing singleton*.
    %
    %      IWALKERGUI('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in IWALKERGUI.M with the given input arguments.
    %
    %      IWALKERGUI('Property','Value',...) creates a new IWALKERGUI or raises the
    %      existing singleton*.  Starting from the left, property value pairs are
    %      applied to the GUI before iWalkerGUI_OpeningFcn gets called.  An
    %      unrecognized property name or invalid value makes property application
    %      stop.  All inputs are passed to iWalkerGUI_OpeningFcn via varargin.
    %
    %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
    %      instance to run (singleton)".
    %
    % See also: GUIDE, GUIDATA, GUIHANDLES

    % Edit the above text to modify the response to help iWalkerGUI

    % Last Modified by GUIDE v2.5 16-Oct-2014 16:12:33

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @iWalkerGUI_OpeningFcn, ...
                       'gui_OutputFcn',  @iWalkerGUI_OutputFcn, ...
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

% --- Executes just before iWalkerGUI is made visible.
function iWalkerGUI_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to iWalkerGUI (see VARARGIN)

    % Choose default command line output for iWalkerGUI
    handles.output = hObject;
    if ~isfield(handles, 'init')
       disp('new'); 
       handles.init = true;
    else
        disp('open'),
        return;
    end
        
    set(handles.sampleTimePanel, 'visible', 'off');
    set(handles.sampleTimePanel, 'visible', 'on');
    align([handles.sampleTimePanel, ...
           handles.laserCOMPanel, ...
           handles.lambdasPanel, ...
           handles.nusPanel], ...
           'VerticalAlignment', 'bottom');

    lid = LIDAR();
    ext = LandmarkExtractor();
    rob = DifferentialRobot();
    rob.dt = 0.01;
    rob.attachLidar(lid, [0.6,0,0]);
    gm = GridMap(0.2);
    
    handles.lid = lid;
    handles.rob = rob;
    handles.ext = ext;
    handles.gm = gm;
    
    %% User Inputs Parameters
    handles.portNumber = '1';
    handles.odometrySampleTime = 0.01;
    handles.imuSampleTime = 0.01;
    handles.forcesSampleTime = 0.05;
    handles.laserSampleTime = 0.5;
    handles.leftLambda = 0;
    handles.rightLambda = 0;
    handles.leftNu = 0;
    handles.rightNu = 0;
    set(handles.odometrySampleTimeInput, 'String', num2str(handles.odometrySampleTime));
    set(handles.imuSampleTimeInput, 'String', num2str(handles.imuSampleTime));
    set(handles.forcesSampleTimeInput, 'String', num2str(handles.forcesSampleTime));
    set(handles.laserSampleTimeInput, 'String', num2str(handles.laserSampleTime));
    set(handles.leftLambdaInput, 'String', num2str(handles.leftLambda));
    set(handles.rightLambdaInput, 'String', num2str(handles.rightLambda));
    set(handles.leftNuInput, 'String', num2str(handles.leftNu));
    set(handles.rightNuInput, 'String', num2str(handles.rightNu));
    
    
    handles.isFocusiWalker = 0;
    handles.stopTime = 0.0;
    
    handles.laserCount = 0;
    handles.zoomFocus = 10;
    handles.isGridMapUpdated = true;
    
    handles.landmarks = [];
    handles.splitAndMergeInfo = [];
    
    handles.modelName = 'iWalkerModel';   
    handles.state = 'Ready';
    guidata(hObject, handles);
    setState(hObject, handles.state);
    %% Main vertical separation
    hbf = uiextras.HBoxFlex( 'Parent', handles.viewPanel );
    leftPanel = uiextras.Panel('Parent', hbf);
    vbf = uiextras.VBoxFlex( 'Parent', leftPanel );
    
    %% Init Laser Polar View
    whitebg([1 1 1]);
    laserMap = axes('Parent', vbf, 'ActivePositionProperty', 'Position');
    
    h = polar(0, 5); % set max radial ticks
    delete(h);
    handles.polarPlot = patch(lid.p(1,:), lid.p(2,:), 'b');
    alpha(handles.polarPlot, 0.5);
    
   % handles.polarPlot = polar(laserMap,0,5);
    camroll(90);
    delete(findall(laserMap,'type','text'));
    uiextras.Empty('Parent', vbf );
    set( vbf, 'Sizes', [-1 -1], 'Spacing', 6 );
   % whitebg([0 0 0]);
    
    %% Init Global Map View
    
    globalMap = axes('Parent', hbf, 'ActivePositionProperty', 'OuterPosition');
    set(globalMap, 'LooseInset', get(globalMap,'TightInset'));
    %set(globalMap, 'OuterPosition', [0. 0. 0. 0.]);
   % set(globalMap,'xtick',[], 'ytick', []);
    
    imgmap = imshow(gm.image, gm.R);
    hold on;
    grid on;
    axis xy;
    handles.imgmap = imgmap;
    handles.pl = Plotter(globalMap);
    handles.pl.plotRobot(handles.rob.x, 'iWalker', 'r');


    set( hbf, 'Sizes', [-1 -3], 'Spacing', 3 );
    
    initModel(handles);
    
    %% Timer for plots refresh
    t = timer;
    t.Period = 1;
    t.StartDelay = 0;
    t.ExecutionMode = 'fixedRate';
    t.TimerFcn = {@timerCallback};
    t.UserData = hObject;
    handles.plotTimer = t;
    
    % Update handles structure
    guidata(hObject, handles);
    loadPorts(hObject);
    start(handles.plotTimer);
end


% --- Outputs from this function are returned to the command line.
function varargout = iWalkerGUI_OutputFcn(hObject, eventdata, handles) 
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;
end 
% When simulation starts, Simulink will call this function in order to
% register the event listener to the block 'SineWave'. The function
% localEventListener will execute everytime after the block 'SineWave' has
% returned its output.

function timerCallback(t, ~)
    hObject = get(t,'UserData');
    handles = guidata(hObject);
    updatePlots(hObject, handles);
end

function updatePlots(hObject, handles)
    rob = handles.rob;
    lid = handles.lid;
    gm = handles.gm;
    pl = handles.pl;
    landmarks = handles.landmarks;
    splitAndMergeInfo = handles.splitAndMergeInfo;
    % Polar plot
    h = handles.polarPlot;
    set(h,'XData',[0 lid.p(1,:) 0], 'YData',[0 lid.p(2,:) 0]);
    
    % Map
    
    if ~isempty(handles.landmarks)
       pl.plotLandmark(landmarks, 'landmarks');
      % pl.plotSplitAndMerge(splitAndMergeInfo, 's&m');
    end
    
    if handles.isGridMapUpdated
        set(handles.imgmap, 'CData', gm.image);
        handles.isGridMapUpdated = false;
    end
    p = pTransform(lid.p, lid.globalTransform);
    pl.plotPoints(p(1,:), p(2,:), 'laseData', 'g');
    pl.plotRobot(rob.x, 'iWalker', 'r');
    if ~isempty(rob.x_hist)
        lenTrace = min(size(rob.x_hist,1), 5000);
        xh = rob.x_hist(end-lenTrace+1:end, 1:2);
        xh = xh(1:20:end, :);
        pl.plotTrace(xh, 'trace.iWalker', [0.8 0.3 0]);
    end
    
    if handles.isFocusiWalker
        zf = handles.zoomFocus;
        axis([[-zf zf]+rob.x(1) [-zf zf]+rob.x(2)]);
    else
        %axis fill;
    end
    
    drawnow;
    guidata(hObject, handles);
end

function initModel(handles)
    try
     %% Open and set model
         modelName = handles.modelName;
         open_system(modelName); % change for load_system for not open the model window

         % When the model starts, call the localAddEventListener function
         set_param(modelName,'StartFcn','localAddEventListener');

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
%   Setup URG-04LX log block
    stl = handles.laserSampleTime;
    set_param([modelName '/URG-04LX'], ...
                'SampleTime', num2str(stl),...
                'COM', handles.portNumber, ...
                'UserData', gcbo);

    % Setup iWheels block
    stw = handles.odometrySampleTime;
    set_param([modelName '/iWheels'], ...
                'SampleTime', num2str(stw),...
                'UserData', gcbo);
            
    % Setup IMU block
    sti = handles.imuSampleTime;
    set_param([modelName '/IMU'], ...
                'SampleTime', num2str(sti),...
                'UserData', gcbo);   
            
     % Setup FORCES block
    stf = handles.forcesSampleTime;
    set_param([modelName '/FORCES'], ...
                'SampleTime', num2str(stf),...
                'UserData', gcbo);       
            
    % Setup leftLambda block
    set_param([modelName '/leftLambda'], ...
                'Value', num2str(handles.leftLambda), ...
                'UserData', gcbo);
            
    % Setup rightLambda block
    set_param([modelName '/rightLambda'], ...
                'Value', num2str(handles.rightLambda), ...
                'UserData', gcbo);
            
    % Setup leftNu block
    set_param([modelName '/leftNu'], ...
                'Value', num2str(handles.leftNu), ...
                'UserData', gcbo);
            
     % Setup rightNu block
    set_param([modelName '/rightNu'], ...
                'Value', num2str(handles.rightNu), ...
                'UserData', gcbo);
            
    % Setup Sample Tyme Sync block
    sts = min([stl,stw,sti,stf]);
    set_param([modelName '/Sample Time Sync'], ...
                'SampleTime', num2str(sts), ...
                'UserData', gcbo);      
            
    handles.stopTime = Inf;
    set(handles.stopTimeText, 'string', handles.stopTime);
    guidata(gcbo, handles);
    disp('Done!');
end

function eh = localAddEventListener
    eh = [];
    eh = [eh add_exec_event_listener('iWalkerModel/Sample Time Sync', ...
                                     'PostOutputs', @currentTimeEventListener)];
                        
    eh = [eh add_exec_event_listener('iWalkerModel/URG-04LX', ...
                                     'PostOutputs', @laserEventListener)];
    
    eh = [eh add_exec_event_listener('iWalkerModel/iWheels', ...
                                     'PostOutputs', @iWheelsEventListener)];
                                 
    eh = [eh add_exec_event_listener('iWalkerModel/IMU', ...
                                     'PostOutputs', @imuEventListener)];
                                 
    eh = [eh add_exec_event_listener('iWalkerModel/FORCES', ...
                                     'PostOutputs', @forcesEventListener)];
end

% The function to be called when event is registered.
function currentTimeEventListener(rtb, eventdata)
    handles = guidata(get_param(rtb.BlockHandle, 'UserData'));
    t = rtb.CurrentTime;
    a = fix(t);
    b = fix((t - a)*10);
    set(handles.currentTimeText, 'String', [num2str(a) '.' num2str(b)]);
    
    if t > handles.stopTime
       %setState(hObject, 'Stop'); 
    end   
end

% The function to be called when event is registered.
function laserEventListener(rtb, eventdata)
    hObject = get_param(rtb.BlockHandle, 'UserData');
    handles = guidata(hObject);
    lid = handles.lid;
    gm = handles.gm;
    ext = handles.ext;
    
    lid.setRangeData(double(rtb.OutputPort(1).Data)'/1000);

    T = lid.globalTransform;
    p = pTransform(lid.p, T);
    r =  lid.range;
    
    [landmarks, info] = ext.extract(r, p);
    handles.landmarks = landmarks;
    handles.splitAndMergeInfo = info;
    
    handles.laserCount = mod(handles.laserCount + 1, 3);
    if handles.laserCount == 10
        disp('GridMap update');
        tic;
        xs = pTransform([0;0], T);
        rlim = [0.02 3.8];
        gm.update(xs, p, r, rlim);
        handles.isGridMapUpdated = true;
        toc
    end
    guidata(hObject, handles);
end

% The function to be called when event is registered.
function iWheelsEventListener(rtb, eventdata)
    handles = guidata(get_param(rtb.BlockHandle, 'UserData'));
    %disp(rtb.OutputPort(1).Data);
    drpm = [rtb.OutputPort(1).Data rtb.OutputPort(2).Data];
    odo = handles.rob.updateDifferential(drpm);
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
    switch upper(state)
        case 'NOTREADY'
            set(handles.stateText, 'string', 'Not Ready');
            set(handles.stateText, 'backgroundcolor', 'r');
            set(handles.runButton, 'enable', 'off');
            set(handles.runButton, 'string', 'Run');
            guidata(hObject, handles);
        case 'READY'
            set(handles.stateText, 'string', 'Ready');
            set(handles.stateText, 'backgroundcolor', 'b');
            set(handles.runButton, 'enable', 'on');
            set(handles.runButton, 'string', 'Run');
            guidata(hObject, handles);
        case 'RUN'
            handles.lid = LIDAR();
            handles.ext = LandmarkExtractor();
            handles.rob = DifferentialRobot();
            handles.rob.dt = handles.odometrySampleTime;
            handles.rob.attachLidar(handles.lid, [0.6,0,0]);
            handles.gm = GridMap(0.2);
            set(handles.stateText, 'string', 'Running');
            set(handles.stateText, 'backgroundcolor', 'g');
            set(handles.runButton, 'enable', 'on');
            set(handles.runButton, 'string', 'Stop');
            strid = nextExperimentID();
            set(handles.experimentID, 'String', strid);
            setupModel(handles)
            set_param( modelName, 'SimulationCommand', 'start');
            guidata(hObject, handles);
        case 'STOP'
            set_param( modelName, 'SimulationCommand', 'stop');
            dstr = strrep(strrep(datestr(now), ' ', '_'), ':', '-');
            id = get(handles.experimentID, 'String');
            filename = [id '_' dstr];
            drpm = evalin('base','drpm');
            pose = evalin('base','pose');
            imu = evalin('base','imu');
            forces = evalin('base','forces');
            range = evalin('base', 'range');
            save(filename, 'drpm', 'pose', 'imu', 'forces', 'range');
            guidata(hObject, handles);
            setState(hObject, 'READY');
        otherwise
            set(handles.stateText, 'string', 'BAD STATE');
            set(handles.stateText, 'backgroundcolor', 'r');
            guidata(hObject, handles);
    end
    guidata(hObject, handles);
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

% --- Executes when user attempts to close mainWindow.
function mainWindow_CloseRequestFcn(hObject, eventdata, handles)
    % hObject    handle to mainWindow (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: delete(hObject) closes the figure
    
    try     
        modelName = handles.modelName;
        set_param(modelName, 'SimulationCommand', 'stop');
        bdclose(modelName);
    catch
        errordlg('Problem closing simulink model', 'Error');
    end
    try 
        stop(handles.plotTimer);
        delete(handles.plotTimer);
    catch
        errordlg('Problem deleting timer', 'Error');
    end
    delete(hObject);
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


% --- Executes on button press in runButton.
function runButton_Callback(hObject, eventdata, handles)
    % hObject    handle to runButton (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of runButton
    running = get(hObject, 'Value');

    if running
       setState(hObject, 'Run');       
    else
        setState(hObject, 'Stop');        
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





% --------------------------------------------------------------------
function zoomButton_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to zoomButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    state = get(hObject, 'State');
    switch state
        case 'on'
            zoom on;
            set(handles.focusButton, 'enable', 'off');
            set(handles.panButton, 'enable', 'off');
        case 'off'
            zoom off;
            set(handles.focusButton, 'enable', 'on');
            set(handles.panButton, 'enable', 'on');
    end
    updatePlots(gcbo, handles);
end


% --------------------------------------------------------------------
function panButton_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to panButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    state = get(hObject, 'State');
    switch state
        case 'on'
            pan on;
            set(handles.focusButton, 'enable', 'off');
            set(handles.zoomButton, 'enable', 'off');
        case 'off'
            pan off;
            set(handles.focusButton, 'enable', 'on');
            set(handles.zoomButton, 'enable', 'on');
    end
    updatePlots(gcbo, handles);
end

% --------------------------------------------------------------------
function focusButton_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to focusButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    state = get(hObject, 'State');
    switch state
        case 'on'
            handles.isFocusiWalker = 1;
            handles.xlim = xlim;
            handles.ylim = ylim;
            set(handles.panButton, 'enable', 'off');
            set(handles.zoomButton, 'enable', 'off');
            set(handles.zoomInFocusButton, 'enable', 'on');
            set(handles.zoomOutFocusButton, 'enable', 'on');
        case 'off'
            handles.isFocusiWalker = 0;
            xlim([-100 100]);
            ylim([-100 100]);
            set(handles.panButton, 'enable', 'on');
            set(handles.zoomButton, 'enable', 'on');
            set(handles.zoomInFocusButton, 'enable', 'off');
            set(handles.zoomOutFocusButton, 'enable', 'off');
    end
    guidata(hObject, handles);
    updatePlots(gcbo, handles);
end

% --------------------------------------------------------------------
function zoomInFocusButton_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to zoomInFocusButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.zoomFocus = handles.zoomFocus / 2;
    guidata(hObject, handles);
    updatePlots(gcbo, handles);
end


% --------------------------------------------------------------------
function zoomOutFocusButton_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to zoomOutFocusButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.zoomFocus = handles.zoomFocus * 2;
    guidata(hObject, handles);
    updatePlots(gcbo, handles);
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
        setState(hObject, 'Ready');
    end
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
