function varargout = settingsiWalkerGUI(varargin)
% SETTINGSIWALKERGUI MATLAB code for settingsiWalkerGUI.fig
%      SETTINGSIWALKERGUI, by itself, creates a new SETTINGSIWALKERGUI or raises the existing
%      singleton*.
%
%      H = SETTINGSIWALKERGUI returns the handle to a new SETTINGSIWALKERGUI or the handle to
%      the existing singleton*.
%
%      SETTINGSIWALKERGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SETTINGSIWALKERGUI.M with the given input arguments.
%
%      SETTINGSIWALKERGUI('Property','Value',...) creates a new SETTINGSIWALKERGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before settingsiWalkerGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to settingsiWalkerGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help settingsiWalkerGUI

% Last Modified by GUIDE v2.5 16-Oct-2014 17:12:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @settingsiWalkerGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @settingsiWalkerGUI_OutputFcn, ...
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
% --- Executes just before settingsiWalkerGUI is made visible.
function settingsiWalkerGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to settingsiWalkerGUI (see VARARGIN)

% Choose default command line output for settingsiWalkerGUI
handles.output = hObject;



if length(varargin) ~= 9
    error('bad vararing size');
end

handles.odometrySampleTime = varargin(1);
handles.imuSampleTime = varargin(2);
handles.forcesSampleTime = varargin(3);
handles.laserSampleTime = varargin(4);
handles.portNumber = varargin(5);
handles.leftLambda = varargin(6);
handles.rightLambda = varargin(7);
handles.leftNu = varargin(8);
handles.rightNu = varargin(9);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes settingsiWalkerGUI wait for user response (see UIRESUME)
 uiwait(handles.figure1);

end

% --- Outputs from this function are returned to the command line.
function varargout = settingsiWalkerGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
delete(hObject);
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
    loadPorts(handles);
end

function loadPorts(handles)
    info = instrhwinfo('serial');
    ports = info.AvailableSerialPorts;
    if isempty(ports)
        set(handles.laserCOMInput, 'String', '-');
    else
        set(handles.laserCOMInput, 'String', ports);
        handles.portNumber = strrep(ports{1}, 'COM', '');
        setState(handles, 'Ready');
    end
end

% --- Executes on button press in okButton.
function okButton_Callback(hObject, eventdata, handles)
% hObject    handle to okButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    uiresume(hObject);
end

% --- Executes on button press in cancelButton.
function cancelButton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

end