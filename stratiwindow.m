function varargout = stratiwindow(varargin)
%STRATIWINDOW M-file for stratiwindow.fig
%      STRATIWINDOW, by itself, creates a new STRATIWINDOW or raises the existing
%      singleton*.
%
%      H = STRATIWINDOW returns the handle to a new STRATIWINDOW or the handle to
%      the existing singleton*.
%
%      STRATIWINDOW('Property','Value',...) creates a new STRATIWINDOW using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to stratiwindow_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      STRATIWINDOW('CALLBACK') and STRATIWINDOW('CALLBACK',hObject,...) call the
%      local function named CALLBACK in STRATIWINDOW.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help stratiwindow

% Last Modified by GUIDE v2.5 31-Aug-2014 23:42:15
setupWsVar('strati_data',{});
setupWsVar('strati_sel',[0 0]);
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @stratiwindow_OpeningFcn, ...
                   'gui_OutputFcn',  @stratiwindow_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before stratiwindow is made visible.
function stratiwindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for stratiwindow
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes stratiwindow wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = stratiwindow_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in button_save.
function button_save_Callback(hObject, eventdata, handles)
% hObject    handle to button_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

assignin('base', 'strati_data', get(handles.uitable2, 'Data'));
uitable2_Saved_Edit(hObject, eventdata, handles);
assignin('base', 'strati_assign', 1);
set(evalin('base', 'well_button'), 'Enable', 'on');

% --- Executes on button press in button_above.
function button_above_Callback(hObject, eventdata, handles)
% hObject    handle to button_above (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

uitable2_Unsaved_Edit(hObject, eventdata, handles);
addUITableRow( handles.uitable2, 'strati_sel', 1 );


% --- Executes during object creation, after setting all properties.
function uitable2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uitable2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'Data', {});
set(hObject, 'ColumnName', {'Unit Name', 'Bottom Age [Ma]', 'Top Age [Ma]'});
set(hObject, 'Data', evalin('base', 'strati_data'));


% --- Executes when entered data in editable cell(s) in uitable2.
function uitable2_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable2 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

uitable2_Unsaved_Edit(hObject, eventdata, handles);

function uitable2_Unsaved_Edit(hObject, eventdata, handles)
assignin('base', 'strati_unsaved', 1);
set(handles.button_save, 'Enable', 'on');
set(handles.button_cancel, 'Enable', 'on');

function uitable2_Saved_Edit(hObject, eventdata, handles)
assignin('base', 'strati_unsaved', 0);
set(handles.button_save, 'Enable', 'off');
set(handles.button_cancel, 'Enable', 'off');

% --- Executes when selected cell(s) is changed in uitable2.
function uitable2_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable2 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)

assignin('base', 'strati_sel', eventdata.Indices);


% --- Executes on button press in button_cancel.
function button_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to button_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data = evalin('base', 'strati_data');
set(handles.uitable2, 'Data', data);

uitable2_Saved_Edit(hObject, eventdata, handles);


% --- Executes on selection change in unit.
function unit_Callback(hObject, eventdata, handles)
% hObject    handle to unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns unit contents as cell array
%        contents{get(hObject,'Value')} returns selected item from unit
assignin('base', 'strati_unsaved', 1);
set(handles.button_save, 'Enable', 'on');
set(handles.button_cancel, 'Enable', 'on');


% --- Executes during object creation, after setting all properties.
function unit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_delete.
function button_delete_Callback(hObject, eventdata, handles)
% hObject    handle to button_delete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uitable2_Unsaved_Edit(hObject, eventdata, handles);
delUITableRow( handles.uitable2, 'strati_sel');


% --- Executes on button press in button_below.
function button_below_Callback(hObject, eventdata, handles)
% hObject    handle to button_below (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uitable2_Unsaved_Edit(hObject, eventdata, handles);
addUITableRow( handles.uitable2, 'strati_sel', 0 );


% --- Executes on button press in button_fill.
function button_fill_Callback(hObject, eventdata, handles)
% hObject    handle to button_fill (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% data = evalin('base', 'strati_data_test');
data = evalin('base', 'strati_data_test_2');
set(handles.uitable2, 'Data', data);
uitable2_Unsaved_Edit(hObject, eventdata, handles);
