function varargout = landmark_extraction(varargin)
    % LANDMARK_EXTRACTION MATLAB code for landmark_extraction.fig
    %      LANDMARK_EXTRACTION, by itself, creates a new LANDMARK_EXTRACTION or raises the existing
    %      singleton*.
    %
    %      H = LANDMARK_EXTRACTION returns the handle to a new LANDMARK_EXTRACTION or the handle to
    %      the existing singleton*.
    %
    %      LANDMARK_EXTRACTION('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in LANDMARK_EXTRACTION.M with the given input arguments.
    %
    %      LANDMARK_EXTRACTION('Property','Value',...) creates a new LANDMARK_EXTRACTION or raises the
    %      existing singleton*.  Starting from the left, property value pairs are
    %      applied to the GUI before landmark_extraction_OpeningFcn gets called.  An
    %      unrecognized property name or invalid value makes property application
    %      stop.  All inputs are passed to landmark_extraction_OpeningFcn via varargin.
    %
    %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
    %      instance to run (singleton)".
    %
    % See also: GUIDE, GUIDATA, GUIHANDLES
    
    % Edit the above text to modify the response to help landmark_extraction
    
    % Last Modified by GUIDE v2.5 20-Aug-2014 23:39:35
    
    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
        'gui_Singleton',  gui_Singleton, ...
        'gui_OpeningFcn', @landmark_extraction_OpeningFcn, ...
        'gui_OutputFcn',  @landmark_extraction_OutputFcn, ...
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

% --- Executes just before landmark_extraction is made visible.
function landmark_extraction_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to landmark_extraction (see VARARGIN)
    
    % Choose default command line output for landmark_extraction
    handles.output = hObject;
    
    %% Undock the window
    set(hObject, 'WindowStyle', 'normal');
    
    %% Create objects
    lid = LIDAR();
    ext = LandmarkExtractor();
    rob = DifferentialRobot();
    rob.attachLidar(lid, [0.6,0,0]);
    pl = Plotter(gca);
    
    %% Save changes
    handles.lid = lid;
    handles.rob = rob;
    handles.ext = ext;
    handles.pl = pl;
    handles.dlog = [];
    handles.timer = [];
    
    % Update handles structure
    guidata(hObject, handles);
    
    %% For debug only
    loadData('laser_essai.mat', hObject, handles);
    
    
    % UIWAIT makes landmark_extraction wait for user response (see UIRESUME)
    % uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = landmark_extraction_OutputFcn(hObject, eventdata, handles)
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Get default command line output from handles structure
    varargout{1} = handles.output;
end

% --- Executes during object creation, after setting all properties.
function slider_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to slider (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
end

% --- Executes during object creation, after setting all properties.
function guifig_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to guifig (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: place code in OpeningFcn to populate guifig
    
    hold on;
    axis equal;
    axis([-4 4 -4 4]);
    axis manual;
    whitebg([0 0 0]);
    grid on;
    set(hObject, 'XColor', [0.5 0.5 0.5], 'YColor', [0.5 0.5 0.5]);
    dch = datacursormode;
    dch.updateFcn = {@customDataCursorUpdate};
end

% --- Executes on slider movement.
function slider_Callback(hObject, eventdata, handles)
    % hObject    handle to slider (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'Value') returns position of slider
    %        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    
    sliderLabel = handles.sliderLabel;
    slider = handles.slider;
    
    index = floor(get(slider, 'value'));
    set(sliderLabel, 'String', num2str(index));
    processData(handles, index);
    
    
end


function loadData(path, hObject, handles)
    
    %% Create the DataLog with the data
    dlog = DataLog(path);
    
    %% Set the robot dt
    handles.rob.dt = dlog.wheels.dt;
    
    
    %% Set the slider range
    len = dlog.laser.length;
    slider = handles.slider;
    set(slider, 'Min', 1);
    set(slider, 'Max', len);
    set(slider, 'value', 1);
    set(slider, 'SliderStep', [1/len 1/len] );
    set(slider, 'Enable', 'On');
    
    %% Save the changes
    handles.dlog = dlog;
    guidata(hObject, handles);
    
    processData(handles, 1);
end

function processData(handles, i)
    tic;
    dlog = handles.dlog;
    lid = handles.lid;
    ext = handles.ext;
    rob = handles.rob;
    slider = handles.slider;
    pl = handles.pl;
    
    if nargin < 2
        i =  floor(get(slider, 'value'));
    end
    
    %% Recovery plot flags
    fplotRob = get(handles.checkbox_robot, 'Value');
    fplotPoints = get(handles.checkbox_points, 'Value');
    fplotLines = get(handles.checkbox_lines, 'Value');
    fplotEndpoints = get(handles.checkbox_endpoints, 'Value');
    fplotVertices = get(handles.checkbox_vertices, 'Value');
    fplotClusters = get(handles.checkbox_clusters, 'Value');
    
    %% Recovery parameters
    ext.maxClusterDist = str2double( get(handles.input_clusterDist, 'String'));
    ext.splitDist = str2double( get(handles.input_splitDist, 'String'));
    ext.angularTolerance = str2double( get(handles.input_angularTolerance, 'String'));
    
    
    
    [data, timestamp] = dlog.getData('laser',i);
    lid.setRangeData(double(data)/1000, timestamp);

    [lands, Res] = ext.extract(lid.range, lid.p);
    
    
    %% Plots
    axes(handles.guifig);
    cla;
    
    if ~isempty(lands)
        lands.plot();
    end
    if fplotRob
        pl.plotRobot(rob.x, 'robot.x');
        pl.plotTrace(rob.x_hist, 'robot.hist', 'r');
        %%rob.plot();
    end
    
    p = Res.p;
    
    
    if ~isempty(lands)
        for li = 1: length(lands)
            pl.plotLandmark(lands(li), ['landmark_', num2str(li)]);
        end
    end

   if fplotClusters
       cl = Res.clusters;
       for k = 1: size(cl, 2)
           X = p(1, cl(1,k):cl(2,k));
           Y = p(2, cl(1,k):cl(2,k));
           scatter(X, Y, 10, 'o');
       end
   end
    
    if fplotPoints
        scatter(p(1,:), p(2,:), 1, [0.0 0.7 0.4], 'g.');
    end
       
    if fplotLines || fplotEndpoints
        L = Res.edges;
        for i = 1: size(L,2)
            X = p(1, L(:,i));
            Y = p(2, L(:,i));
            if fplotLines
                line(X, Y, 'Color', 'r', 'LineWidth', 1);
            end
            if fplotEndpoints
                scatter(X, Y, 50, 'co');
            end
        end
    end
    
    if fplotVertices
        V = Res.vertices;
        scatter(p(1,V), p(2,V), 50, 'ro', 'fill');
    end
  
    axis([rob.x(1)-1 rob.x(1)+4.5 rob.x(2)-2.5 rob.x(2)+2.5]);
    
    toc
end



% --- Executes on button press in checkbox_clusters.
function checkboxplot_Callback(hObject, eventdata, handles)
    % hObject    handle to checkbox_clusters (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hint: get(hObject,'Value') returns toggle state of checkbox_clusters
    processData(handles);
end



function inputdouble_Callback(hObject, eventdata, handles)
    % hObject    handle to input_clusterDist (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of input_clusterDist as text
    %        str2double(get(hObject,'String')) returns contents of input_clusterDist as a double
    value = str2double(get(hObject,'String'));
    if isnan(value)
        set(hObject,'String', '0.5')
    end
    processData(handles);
end




%%%%%%%%%%%%%%%%%%%%%%%%%% Play and Stop %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function runSimulation(handles)
    %% Disable panels and slider
    set(findall(handles.panel_plot, '-property', 'enable'), 'enable', 'off');
    set(findall(handles.panel_params, '-property', 'enable'), 'enable', 'off');
    % set(handles.slider, 'Enable', 'off');
    
    %% Start the timer
    handles.timer = makeTimer(handles);
    start(handles.timer);
    
    %% Update data
    guidata(gcbo, handles);
end

function stopSimulation(handles)
    %% Enable panels and slider
    set(findall(handles.panel_plot, '-property', 'enable'), 'enable', 'on');
    set(findall(handles.panel_params, '-property', 'enable'), 'enable', 'on');
    set(handles.slider, 'Enable', 'on');
    
    %% Stop the timer
    stop(handles.timer)
    
    %% Update data
    guidata(gcbo, handles);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%% TIMER %%%%%%%%%%%%%%%%
function t = makeTimer(handles)
    t = timer;
    t.Period = handles.dlog.laser.dt;
    t.StartDelay = handles.dlog.laser.dt;
    t.ExecutionMode = 'fixedRate';
    t.TimerFcn = {@runTimer};
    t.StopFcn = {@stopTimer};
    t.UserData = handles;
end
function runTimer(timer, ~)
    
    handles = timer.UserData;
    slider = handles.slider;
    sliderLabel = handles.sliderLabel;

    
  
    
    i = floor(get(slider, 'value'));
    if i+1 < get(slider, 'Max')
        set(slider, 'value', i+1);
        set(sliderLabel, 'String', num2str(i));
    else
        set(handles.toggle_play, 'State', 'off');
    end
    processData(handles, i);
end

function stopTimer(timer, ~)
    delete(timer);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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




%%%%%%%%%%%%%%%%%%%% Toolsrip Buttons %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --------------------------------------------------------------------
function toggle_play_OnCallback(hObject, eventdata, handles)
    % hObject    handle to toggle_play (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    runSimulation(handles);
end


% --------------------------------------------------------------------
function toggle_play_OffCallback(hObject, eventdata, handles)
    % hObject    handle to toggle_play (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    stopSimulation(handles);
end

% --------------------------------------------------------------------
function button_load_ClickedCallback(hObject, eventdata, handles)
    % hObject    handle to button_load (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    %% try to load the data
    path =  uigetfile();
    if path ~= 0
        try
            loadData(path, hObject, handles);
        catch 
            errordlg('Bad format data', 'Load error');
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
