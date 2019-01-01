function varargout = mainwindow(varargin)
% MAINWINDOW M-file for mainwindow.fig
%      MAINWINDOW, by itself, creates a new MAINWINDOW or raises the existing
%      singleton*.
%
%      H = MAINWINDOW returns the handle to a new MAINWINDOW or the handle to
%      the existing singleton*.
%
%      MAINWINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINWINDOW.M with the given input arguments.
%
%      MAINWINDOW('Property','Value',...) creates a new MAINWINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mainwindow_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mainwindow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

%#ok<*DEFNU>
%#ok<*INUSL>
%#ok<*INUSD>
evalin('base','addpath(''datamanagement/'')');

setupWsVar('area_assign', 0);
setupWsVar('strati_assign', 0);
setupWsVar('well_assign', 0);
setupWsVar('distri_assign', 0);
setupWsVar('poro_assign', 0);
setupWsVar('sub_assign', 0);
setupWsVar('subana_assign', 0);
setupWsVar('project_name', 'new_project');

initializeCaches();

% Edit the above text to modify the response to help mainwindow

% Last Modified by GUIDE v2.5 01-Jan-2019 19:08:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mainwindow_OpeningFcn, ...
                   'gui_OutputFcn',  @mainwindow_OutputFcn, ...
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


% --- Executes just before mainwindow is made visible.
function mainwindow_OpeningFcn(hObject, eventdata, handles, varargin) 
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mainwindow (see VARARGIN)

% Choose default command line output for mainwindow

assignin('base', 'use_masks', false);
assignin('base', 'area_button', handles.pushbutton1);
assignin('base', 'strati_button', handles.pushbutton2);
assignin('base', 'well_button', handles.pushbutton3);
assignin('base', 'distri_button', handles.pushbutton4);
assignin('base', 'poro_button', handles.pushbutton5);
assignin('base', 'poro2_button', handles.pushbutton18);
assignin('base', 'sub_button', handles.pushbutton6);
assignin('base', 'subana_button', handles.pushbutton7);

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mainwindow wait for user response (see UIRESUME)
% uiwait(handles.figure1);
[im, ~, alpha] = imread('basinvislogo.png');
f = imshow(im, 'Parent', handles.axes1);
set(f, 'AlphaData', alpha);


% --- Outputs from this function are returned to the command line.
function varargout = mainwindow_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles) 
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
areawindow;

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stratiwindow;

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
wellwindow;

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
distriwindow;

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
porowindow;

% --- Executes on button press in pushbutton2.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
subwindow;

% --- Executes on button press in pushbutton3.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
submapwindow;

% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
web('http://cs.brown.edu/~novotny/geologist-lee/basinvis.html');

% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure1_CloseRequestFcn(hObject, eventdata, handles);

% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles) 
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
porowindow;

% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
comptrendlibwindow;

% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
comptrendwindow;

% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sedprofilewindow;

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
%delete(hObject);
evalin('base','clear variables');
closereq;

% --------------------------------------------------------------------
function uipushtoolopen_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[openfile, openpath, ~] = uigetfile('*.mat', 'Open Project');
openfile = [openpath openfile];
assignin('base', 'openfile', openfile);

data = load(openfile, 'area_assign');
vars = whos('-file', openfile);
if ismember('area_assign',{vars.name}) && data.area_assign
    evalin('base', 'load(openfile, ''area_assign'', ''area_x_dim'', ''area_y_dim'', ''area_z_dim'', ''area_unit'')');
    set(evalin('base', 'strati_button'), 'Enable', 'on');
else
    set(evalin('base', 'strati_button'), 'Enable', 'off');
    assignin('base', 'area_assign', 0);
    assignin('base', 'area_edit_flag', 0);
    assignin('base', 'area_unsaved', 0);
    assignin('base', 'area_x_dim', '');
    assignin('base', 'area_y_dim', '');
    assignin('base', 'area_z_dim', '');
end

data = load(openfile, 'strati_assign');
vars = whos('-file', openfile);
if ismember('strati_assign',{vars.name}) && data.strati_assign
    evalin('base', 'load(openfile, ''strati_assign'', ''strati_data'')');
    set(evalin('base', 'well_button'), 'Enable', 'on');
else
    set(evalin('base', 'well_button'), 'Enable', 'off');
    assignin('base', 'strati_assign', 0);
    assignin('base', 'strati_data',{});
    assignin('base', 'strati_sel',[0 0]);
end

data = load(openfile, 'well_assign');
vars = whos('-file', openfile);
if ismember('well_assign',{vars.name}) && data.well_assign
    evalin('base', 'load(openfile, ''well_assign'', ''well_data'', ''well_custom_data'', ''well_params'', ''well_custom_params'')');
    set(evalin('base', 'distri_button'), 'Enable', 'on');
    set(evalin('base', 'poro_button'), 'Enable', 'on');
else
    set(evalin('base', 'distri_button'), 'Enable', 'off');
    set(evalin('base', 'poro_button'), 'Enable', 'off');
    assignin('base', 'well_assign', 0);
    assignin('base', 'well_unsaved', 0);
    assignin('base', 'well_data', {});
    assignin('base', 'well_custom_data', {});
    assignin('base', 'well_params', {});
    assignin('base', 'well_custom_params', []);
    assignin('base', 'well_sel', [0 0]);
end

data = load(openfile, 'poro_assign');
vars = whos('-file', openfile);
if ismember('poro_assign',{vars.name}) && data.poro_assign
    evalin('base', 'load(openfile, ''poro_assign'', ''poro_data'', ''well_params'', ''well_custom_params'')');
    set(evalin('base', 'distri_button'), 'Enable', 'on');
    set(evalin('base', 'poro_button'), 'Enable', 'on');
    set(evalin('base', 'sub_button'), 'Enable', 'on');
    set(evalin('base', 'subana_button'), 'Enable', 'on');
else
    set(evalin('base', 'distri_button'), 'Enable', 'off');
    set(evalin('base', 'poro_button'), 'Enable', 'off');
    assignin('base', 'poro_assign', 0);
    assignin('base', 'poro_unsaved', 0);
    assignin('base', 'well_params', {});
    assignin('base', 'well_custom_params', []);
end

% --------------------------------------------------------------------
function uipushtoolsave_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename = [evalin('base', 'project_name') '.mat'];
[putfile, putpath, ~] = uiputfile(filename, 'Save Project As...');
assignin('base', 'savefile', [putpath putfile]);
evalin('base', 'save(savefile, ''project_name'')');

if evalin('base', 'area_assign')
    evalin('base', 'save(savefile, ''area_assign'', ''area_x_dim'', ''area_y_dim'', ''area_z_dim'', ''area_unit'', ''-append'')');
end

if evalin('base', 'strati_assign')
    evalin('base', 'save(savefile, ''strati_assign'', ''strati_data'', ''-append'')');
end

if evalin('base', 'well_assign')
    evalin('base', 'save(savefile, ''well_assign'', ''well_data'', ''well_custom_data'', ''-append'')');
end

if evalin('base', 'poro_assign')
    evalin('base', 'save(savefile, ''poro_assign'', ''poro_data'', ''well_params'', ''well_custom_params'', ''-append'')');
end