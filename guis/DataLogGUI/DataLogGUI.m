function varargout = DataLogGUI(varargin)
    % DATALOGGUI MATLAB code for DataLogGUI.fig
    %      DATALOGGUI, by itself, creates a new DATALOGGUI or raises the existing
    %      singleton*.
    %
    %      H = DATALOGGUI returns the handle to a new DATALOGGUI or the handle to
    %      the existing singleton*.
    %
    %      DATALOGGUI('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in DATALOGGUI.M with the given input arguments.
    %
    %      DATALOGGUI('Property','Value',...) creates a new DATALOGGUI or raises the
    %      existing singleton*.  Starting from the left, property value pairs are
    %      applied to the GUI before DataLogGUI_OpeningFcn gets called.  An
    %      unrecognized property name or invalid value makes property application
    %      stop.  All inputs are passed to DataLogGUI_OpeningFcn via varargin.
    %
    %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
    %      instance to run (singleton)".
    %
    % See also: GUIDE, GUIDATA, GUIHANDLES

    % Edit the above text to modify the response to help DataLogGUI

    % Last Modified by GUIDE v2.5 12-Oct-2014 20:29:58

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @DataLogGUI_OpeningFcn, ...
                       'gui_OutputFcn',  @DataLogGUI_OutputFcn, ...
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

% --- Executes just before DataLogGUI is made visible.
function DataLogGUI_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to DataLogGUI (see VARARGIN)

    % Choose default command line output for DataLogGUI
    handles.output = hObject;
    
    % Si el singleton ya esta abierto, no hacemos nada
    if ~isfield(handles, 'init')
       handles.init = true;
    else
        return;
    end 


    lid = LIDAR();
    ext = LandmarkExtractor();
    rob = DifferentialRobot();
    rob.dt = 0.01;
    rob.attachLidar(lid, [0.6,0,0]);
    gm = GridMap8b(0.2, [-10 40], [-10 40]);
    
    handles.lid = lid;
    handles.rob = rob;
    handles.ext = ext;
    handles.gm = gm;
    
    
    handles.isFocusiWalker = 0;
    handles.stopTime = 0.0;
    
    handles.laserCount = 0;
    handles.zoomFocus = 10;
    handles.isGridMapUpdated = true;
    
    handles.landmarks = [];
    handles.splitAndMergeInfo = [];
    
    handles.modelName = 'LogModel';   
    handles.state = 'NotReady';
    
    handles.angle = 0;

    setState(handles, 'NotReady');
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
    set( vbf, 'Sizes', [-1.1 -1], 'Spacing', 6 );
   % whitebg([0 0 0]);
    
    %% Init Global Map View
    
    globalMap = axes('Parent', hbf, 'ActivePositionProperty', 'OuterPosition');
    set(globalMap, 'LooseInset', get(globalMap,'TightInset'));
    %set(globalMap, 'OuterPosition', [0. 0. 0. 0.]);
   % set(globalMap,'xtick',[], 'ytick', []);
    
    imgmap = imshow(gm.image, gm.R);%, 'colormap', bone(256));
    hold on; 
    handles.imgmap = imgmap;
    handles.pl = Plotter(globalMap);
    handles.pl.plotRobot(handles.rob.x, 'iWalker', 'r');
    grid on;
    axis xy;
    

    set( hbf, 'Sizes', [-1 -2], 'Spacing', 3 );
    
    initModel(handles);
    
    %% Timer for plots refresh
    t = timer;
    t.Period = 1/5;
    t.StartDelay = 0;
    t.ExecutionMode = 'fixedRate';
    t.TimerFcn = {@updatePlots};
    t.UserData = hObject;
    handles.plotTimer = t;
    
    % Update handles structure
    guidata(hObject, handles);
    
    start(handles.plotTimer);
end


% --- Outputs from this function are returned to the command line.
function varargout = DataLogGUI_OutputFcn(hObject, eventdata, handles) 
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

function updatePlots(t, ~)
    hObject = get(t,'UserData');
    handles = guidata(hObject);
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
    rc = rand();
    pl.plotPoints(p(1,:), p(2,:), 'laseData', [0 rc 1-rc]);
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

function eh = localAddEventListener
    eh = [];
    eh = [eh add_exec_event_listener('LogModel/Sample Time Sync', ...
                                     'PostOutputs', @currentTimeEventListener)];
                        
    eh = [eh add_exec_event_listener('LogModel/URG-04LX Log', ...
                                     'PostOutputs', @laserEventListener)];
    
    eh = [eh add_exec_event_listener('LogModel/iWheels Log', ...
                                     'PostOutputs', @iWheelsEventListener)];
end

% The function to be called when event is registered.
function currentTimeEventListener(rtb, eventdata)
    handles = guidata(get_param(rtb.BlockHandle, 'UserData'));
    t = rtb.CurrentTime;
    a = fix(t);
    b = fix((t - a)*10);
    set(handles.currentTimeText, 'String', [num2str(a) '.' num2str(b)]);
    
    if t > handles.stopTime
       setState(handles, 'Ready'); 
    end   
end

% The function to be called when event is registered.
function laserEventListener(rtb, eventdata)
    hObject = get_param(rtb.BlockHandle, 'UserData');
    handles = guidata(hObject);
    lid = handles.lid;
    gm = handles.gm;
    ext = handles.ext;
    
%     Q = [lid.p; zeros(1,682)];
    lid.setRangeData(double(rtb.OutputPort(1).Data)'/1000);
%     P = [lid.p; zeros(1,682)];
%     [TR, TT] = icp(Q,P);
%     angle = atan2d(TR(2,1),TR(1,1));
%     handles.angle = handles.angle + angle;
%     [angle, handles.angle, rad2deg(handles.rob.x(3))]
%     handles.rob.x(3) = 0.5* handles.rob.x(3) +0.5* deg2rad(handles.angle);
    T = lid.globalTransform;
    p = pTransform(lid.p, T);
    r =  lid.range;
    
    
    
    [landmarks, info] = ext.extract(r, p);
    handles.landmarks = landmarks;
    handles.splitAndMergeInfo = info;
    
    handles.laserCount = mod(handles.laserCount + 1, 1);
    if handles.laserCount == 0
        %disp('GridMap update');
        %tic;
        xs = pTransform([0;0], T);
        rlim = [0.02 3.8];
        gm.update(xs, p, r, rlim);
        handles.isGridMapUpdated = true;
        %toc
    end
    guidata(hObject, handles);
end

% The function to be called when event is registered.
function iWheelsEventListener(rtb, eventdata)
    handles = guidata(get_param(rtb.BlockHandle, 'UserData'));
    %disp(rtb.OutputPort(1).Data);
    data = fliplr(rtb.OutputPort(1).Data');
    rph = data(1:2);
    odo = handles.rob.updateDifferential(rph);
end




function setState(handles, state)  
    modelName = handles.modelName;
    switch upper(state)
        case 'NOTREADY'
            set(handles.stateText, 'string', 'Not Ready');
            set(handles.stateText, 'backgroundcolor', 'r');
            set(handles.runButton, 'enable', 'off');
            set(handles.runButton, 'string', 'Run');
        case 'READY'
            set(handles.stateText, 'string', 'Ready');
            set(handles.stateText, 'backgroundcolor', 'b');
            set(handles.runButton, 'enable', 'on');
            set(handles.runButton, 'string', 'Run');
            set_param( modelName, 'SimulationCommand', 'stop');
        case 'RUN'
            set(handles.stateText, 'string', 'Running');
            set(handles.stateText, 'backgroundcolor', 'g');
            set(handles.runButton, 'enable', 'on');
            set(handles.runButton, 'string', 'Stop');
            set_param( modelName, 'SimulationCommand', 'start');
        otherwise
            set(handles.stateText, 'string', 'BAD STATE');
            set(handles.stateText, 'backgroundcolor', 'r');
    end
end

function initModel(handles)
    try
     %% Open and set model
         modelName = handles.modelName;
         load_system(modelName); % change for load_system for not open the model window

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

function setupModel(handles, dlog)
    modelName = handles.modelName;
%   Setup URG-04LX log block
    stl = dlog.laserLog.TimeInfo.Increment;
    set_param([modelName '/URG-04LX Log'], ...
                'SampleTime', num2str(stl),...
                'VariableName', 'log.laserLog', ...
                'UserData', gcbo);

    % Setup iWheels block
    stw = dlog.iWheelsLog.TimeInfo.Increment;
    set_param([modelName '/iWheels Log'], ...
                'SampleTime', num2str(stw),...
                'VariableName', 'log.iWheelsLog', ...
                'UserData', gcbo);
    % Setup Sample Tyme Sync block
    set_param([modelName '/Sample Time Sync'], ...
                'SampleTime', num2str(stw), ...
                'UserData', gcbo);
            
    handles.stopTime = max(dlog.iWheelsLog.TimeInfo.End, ...
                           dlog.laserLog.TimeInfo.End);
    set(handles.stopTimeText, 'string', handles.stopTime);
    guidata(gcbo, handles);
end

% --- Executes when user attempts to close mainWindow.
function mainWindow_CloseRequestFcn(hObject, eventdata, handles)
    % hObject    handle to mainWindow (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: delete(hObject) closes the figure
    modelName = handles.modelName;
    try       
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
       setState(handles, 'Run');       
    else
        setState(handles, 'Ready');        
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
            setState(handles, 'Ready');
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
end

% --------------------------------------------------------------------
function zoomInFocusButton_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to zoomInFocusButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.zoomFocus = handles.zoomFocus / 2;
    guidata(hObject, handles);
end


% --------------------------------------------------------------------
function zoomOutFocusButton_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to zoomOutFocusButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.zoomFocus = handles.zoomFocus * 2;
    guidata(hObject, handles);
end
