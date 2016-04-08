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
%evalin('base',' clear variables');
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

% Last Modified by GUIDE v2.5 01-Dec-2015 23:56:49

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

%evalin('base', 'load(''matlab.mat'')');
assignin('base', 'use_masks', false);
assignin('base', 'area_button', handles.pushbutton1);
assignin('base', 'strati_button', handles.pushbutton2);
assignin('base', 'well_button', handles.pushbutton3);
assignin('base', 'distri_button', handles.pushbutton4);
assignin('base', 'poro_button', handles.pushbutton5);
assignin('base', 'sub_button', handles.pushbutton6);
assignin('base', 'subana_button', handles.pushbutton7);
%assignin('base', 'well_data', cell(0,10));

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mainwindow wait for user response (see UIRESUME)
% uiwait(handles.figure1);
[im, map, alpha] = imread('basinvislogo.png');
f = imshow(im, 'Parent', handles.axes1);
set(f, 'AlphaData', alpha);

assignin('base','test', handles.axes1);


% --- Outputs from this function are returned to the command line.
function varargout = mainwindow_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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

% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
web('http://cs.brown.edu/~novotny/geologist-lee/basinvis.html');

% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure1_CloseRequestFcn(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1
% logo = imread('basinvislogo.png');
% axes(hObject);
% imshow(logo);

% use_masks = true


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
    assignin('base', 'area_unit',{1 1000 'km'});
end

data = load(openfile, 'strati_assign');
vars = whos('-file', openfile);
if ismember('strati_assign',{vars.name}) && data.strati_assign
    evalin('base', 'load(openfile, ''strati_assign'', ''strati_data'', ''strati_unit'')');
    set(evalin('base', 'well_button'), 'Enable', 'on');
else
    set(evalin('base', 'well_button'), 'Enable', 'off');
    assignin('base', 'strati_assign', 0);
    assignin('base', 'strati_data',{});
    assignin('base', 'strati_sel',[0 0]);
    assignin('base', 'strati_unit',{1 1000000 'MA'});
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


if evalin('base', 'area_assign');
    evalin('base', 'save(savefile, ''area_assign'', ''area_x_dim'', ''area_y_dim'', ''area_z_dim'', ''area_unit'', ''-append'')');
end

if evalin('base', 'strati_assign');
    evalin('base', 'save(savefile, ''strati_assign'', ''strati_data'', ''strati_unit'', ''-append'')');
end

if evalin('base', 'well_assign');
    evalin('base', 'save(savefile, ''well_assign'', ''well_data'', ''well_custom_data'', ''-append'')');
end

if evalin('base', 'poro_assign');
    evalin('base', 'save(savefile, ''poro_assign'', ''poro_data'', ''well_params'', ''well_custom_params'', ''-append'')');
end
