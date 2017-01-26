function varargout = areawindow(varargin)
% AREAWINDOW M-file for areawindow.fig
%      AREAWINDOW, by itself, creates a new AREAWINDOW or raises the existing
%      singleton*.
%
%      H = AREAWINDOW returns the handle to a new AREAWINDOW or the handle to
%      the existing singleton*.
%
%      AREAWINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AREAWINDOW.M with the given input arguments.
%
%      AREAWINDOW('Property','Value',...) creates a new AREAWINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before areawindow_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to areawindow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help areawindow

% Last Modified by GUIDE v2.5 27-Sep-2014 21:43:39
setupWsVar('area_edit_flag', 0);
setupWsVar('area_unsaved', 0);
setupWsVar('area_x_dim', '');
setupWsVar('area_y_dim', '');
setupWsVar('area_z_dim', '');
setupWsVar('area_unit',{1 1000 'km'});
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @areawindow_OpeningFcn, ...
                   'gui_OutputFcn',  @areawindow_OutputFcn, ...
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



% --- Executes just before areawindow is made visible.
function areawindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to areawindow (see VARARGIN)

% Choose default command line output for areawindow
handles.output = hObject;


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes areawindow wait for user response (see UIRESUME)
% uiwait(handles.area_ui);


% --- Outputs from this function are returned to the command line.
function varargout = areawindow_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function area_x_edit_Callback(hObject, eventdata, handles)
% hObject    handle to area_x_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of area_x_edit as text
%        str2double(get(hObject,'String')) returns contents of area_x_edit as a double
assignin('base', 'area_x_dim', str2double(get(hObject, 'String')));
area_Unsaved_Edit(hObject, eventdata, handles);
 

% --- Executes during object creation, after setting all properties.
function area_x_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to area_x_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', evalin('base', 'area_x_dim'));


function area_y_edit_Callback(hObject, eventdata, handles)
% hObject    handle to area_y_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of area_y_edit as text
%        str2double(get(hObject,'String')) returns contents of area_y_edit as a double
 assignin('base', 'area_y_dim', str2double(get(hObject, 'String')));
 area_Unsaved_Edit(hObject, eventdata, handles);
 

% --- Executes during object creation, after setting all properties.
function area_y_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to area_y_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', evalin('base', 'area_y_dim'));

% --- Executes on selection change in unit.
function unit_Callback(hObject, eventdata, handles)
% hObject    handle to unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns unit contents as cell array
%        contents{get(hObject,'Value')} returns selected item from unit
unsaved_Edit(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function unit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_save.
function button_save_Callback(hObject, eventdata, handles)
% hObject    handle to button_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~numeric_check(get(handles.area_x_edit, 'String'), 'area_x_dim', 'X');
    return
end
if ~numeric_check(get(handles.area_y_edit, 'String'), 'area_y_dim', 'Y');
    return
end
if ~numeric_check(get(handles.edit_z, 'String'), 'area_z_dim', 'Z');
    return
end

contents = cellstr(get(handles.unit,'String'));
assignin('base','area_unit', {get(handles.unit, 'Value') (1000^(2-get(handles.unit, 'Value'))) contents{get(handles.unit,'Value')}});

update_preview(handles.area_axes, handles.text_preview);
assignin('base', 'area_assign', 1);
set(evalin('base', 'strati_button'), 'Enable', 'on');
saved_Edit(hObject, eventdata, handles);


   
function [pass] = numeric_check (value, fieldname, errorname)
if ~isnan(str2double(value))
    assignin('base', fieldname, str2double(value));
    pass = 1;
else
    errordlg(['Please set a numeric value in field "' errorname '"']);
    pass = 0;
end



function edit_z_Callback(hObject, eventdata, handles)
% hObject    handle to edit_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_z as text
%        str2double(get(hObject,'String')) returns contents of edit_z as a double
 assignin('base', 'area_z_dim', str2double(get(hObject, 'String')));
 area_Unsaved_Edit(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function edit_z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', evalin('base', 'area_z_dim'));


function area_Unsaved_Edit(hObject, eventdata, handles)
assignin('base', 'area_unsaved', 1);
set(handles.button_save, 'Enable', 'on');
set(handles.button_cancel, 'Enable', 'on');
update_preview(handles.area_axes, handles.text_preview);


function update_preview(hAxes, hOverlay)
x = evalin('base', 'area_x_dim');
y = evalin('base', 'area_y_dim');
z = evalin('base', 'area_z_dim');


if isnumeric(x) && isnumeric(y) && isnumeric(z) && ~isnan(x) && ~isnan(y) && ~isnan(z)
    if ishandle(hAxes)
        set(hAxes, 'xlim', [0 x]);
        set(hAxes, 'ylim', [0 y]);
        set(hAxes, 'zlim', [0 z]);

        set(hAxes, 'Visible', 'on');
    end
    
    if ishandle(hOverlay)
        set(hOverlay, 'Visible', 'off');
    end
else
    if ishandle(hOverlay)
        set(hOverlay, 'Visible', 'on');
    end
    if ishandle(hAxes)
        set(hAxes, 'Visible', 'off');
    end
end
if ishandle(hAxes)
    view(3);
end


% --- Executes on button press in button_cancel.
function button_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to button_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.area_x_edit, 'String', evalin('base', 'area_x_dim'));
set(handles.area_y_edit, 'String', evalin('base', 'area_y_dim'));
set(handles.edit_z, 'String', evalin('base', 'area_z_dim'));

assignin('base', 'area_unsaved', 0);

unit = evalin('base','area_unit{1}');
set(handles.unit, 'Value', unit);

set(handles.button_save, 'Enable', 'off');
set(handles.button_cancel, 'Enable', 'off');


% --- Executes on button press in button_fill.
function button_fill_Callback(hObject, eventdata, handles)
% hObject    handle to button_fill (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% set(handles.area_x_edit, 'String', 80);
% set(handles.area_y_edit, 'String', 140);

set(handles.area_x_edit, 'String', 40);
set(handles.area_y_edit, 'String', 60);
set(handles.edit_z, 'String', 6);

assignin('base', 'area_x_dim', 40);
assignin('base', 'area_y_dim', 60);
assignin('base', 'area_z_dim', 6);

update_preview(handles.area_axes, handles.text_preview);
unsaved_Edit(hObject, eventdata, handles);

function unsaved_Edit(hObject, eventdata, handles)
assignin('base', 'area_unsaved', 1);
set(handles.button_save, 'Enable', 'on');
set(handles.button_cancel, 'Enable', 'on');

function saved_Edit(hObject, eventdata, handles)
assignin('base', 'area_unsaved', 0);
set(handles.button_save, 'Enable', 'off');
set(handles.button_cancel, 'Enable', 'off');


% --- Executes during object creation, after setting all properties.
function area_axes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to area_axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate area_axes
update_preview(hObject, -1);


% --- Executes during object creation, after setting all properties.
function text_preview_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_preview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
update_preview(-1, hObject);
