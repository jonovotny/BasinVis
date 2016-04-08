function varargout = wellwindow(varargin)
%WELLWINDOW M-file for wellwindow.fig
%      WELLWINDOW, by itself, creates a new WELLWINDOW or raises the existing
%      singleton*.
%
%      H = WELLWINDOW returns the handle to a new WELLWINDOW or the handle to
%      the existing singleton*.
%
%      WELLWINDOW('Property','Value',...) creates a new WELLWINDOW using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to wellwindow_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      WELLWINDOW('CALLBACK') and WELLWINDOW('CALLBACK',hObject,...) call the
%      local function named CALLBACK in WELLWINDOW.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help wellwindow

% Last Modified by GUIDE v2.5 10-Jun-2015 00:07:44
setupWsVar('well_unsaved', 0);
setupWsVar('well_data', {});
setupWsVar('well_custom_data', {});
setupWsVar('well_params', {});
setupWsVar('well_custom_params', []);
setupWsVar('well_sel', [0 0]);
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @wellwindow_OpeningFcn, ...
                   'gui_OutputFcn',  @wellwindow_OutputFcn, ...
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


% --- Executes just before wellwindow is made visible.
function wellwindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for wellwindow
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes wellwindow wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = wellwindow_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in button_above.
function button_above_Callback(hObject, eventdata, handles)
% hObject    handle to button_above (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
unsaved_change(handles, 'well_unsaved');
addUITableRow( handles.uitable1, 'well_sel', 1);


% --- Executes on button press in button_save.
function button_save_Callback(hObject, eventdata, handles)
% hObject    handle to button_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
assignin('base', 'well_data', get(handles.uitable1, 'Data'));
changes_saved(handles, 'well_unsaved');
assignin('base', 'well_assign', 1);
set(evalin('base', 'distri_button'), 'Enable', 'on');
set(evalin('base', 'poro_button'), 'Enable', 'on');

% --- Executes during object creation, after setting all properties.
function uitable1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uitable2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'Data', {});
headers = {'<html><center>Well<br />Name</center></html>', ...
           '<html><center>x<br /></center></html>', ...
           '<html><center>y<br /></center></html>', ...
           '<html><center>Total<br />Depth</center></html>', ...
           '<html><center>Top of<br />Basement</center></html>',};
strati_data = evalin('base', 'strati_data');
widths = {65 50 50 65 65};
formats = {'char' 'numeric' 'numeric' 'numeric' 'numeric'};
editable = [true true true true true];
for i = size(strati_data,1):-1:1
    name = strati_data(i,1);
    head = strcat('<html><center>Top of<br />',name,'</center></html>');
    headers(1,size(strati_data,1)-i+6) = head;
    widths(1,size(strati_data,1)-i+6) = {65};
    formats(1,size(strati_data,1)-i+6) = {'numeric'};
    editable(1,size(strati_data,1)-i+6) = true;
end
set(hObject, 'ColumnName', headers);
set(hObject, 'ColumnWidth', widths);
set(hObject, 'ColumnFormat', formats);
set(hObject, 'ColumnEditable', editable);
data = evalin('base', 'well_data');
set(hObject, 'Data', data);

% --- Executes on button press in button_cancel.
function button_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to button_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = evalin('base', 'well_data');
set(handles.uitable1, 'Data', data);
changes_saved(handles, 'well_unsaved');

% --- Executes on button press in button_below.
function button_below_Callback(hObject, eventdata, handles)
% hObject    handle to button_below (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
unsaved_change(handles, 'well_unsaved');
addUITableRow( handles.uitable1, 'well_sel', 0);

% --- Executes on button press in button_delete.
function button_delete_Callback(hObject, eventdata, handles)
% hObject    handle to button_delete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
unsaved_change(handles, 'well_unsaved');
delUITableRow( handles.uitable1, 'well_sel');


% --- Executes on button press in button_fill.
function button_fill_Callback(hObject, eventdata, handles)
% hObject    handle to button_fill (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% [~ , ~, xlsdata] = xlsread('Wells_data_visul.xlsx','Final Depth Data');%evalin('base', 'well_data_test');

files = get(handles.popupmenu1, 'String');
value = get(handles.popupmenu1, 'Value');


[openfile, openpath, ~] = uigetfile('*.xls;*.xlsx', 'Import Data');
openfile = [openpath openfile];
[~ , ~, xlsdata] = xlsread(openfile);

data = xlsdata(2:end,:);
data(:,2:end) = cellfun(@filterCells2, data(:,2:end), 'UniformOutput', false);
data(:,4:end) = cellfun(@divCells, data(:,4:end), 'UniformOutput', false);

assignin('base', 'well_custom_data', cell(size(data)));

set(handles.uitable1, 'Data', data);

unsaved_change(handles, 'well_unsaved');

function out = filterCells2(in)
if isnan(in)
    out = [];
else
    out = in;
end

function out = divCells(in)
    out = in/1000;



% --- Executes when selected cell(s) is changed in uitable1.
function uitable1_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
% try
% r= eventdata.Indices(1,1);
% c=eventdata.Indices(1,2);
% 
% hObject.Data{r,c}= '12';
% catch ME
% end
assignin('base', 'well_sel', eventdata.Indices);


% --- Executes when entered data in editable cell(s) in uitable1.
function uitable1_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
%hObject.Data{eventdata.Indices(1), eventdata.Indices(2)} = '<html><table border=0 width=400px bgcolor=#DDA0DD><tr><td>20</td></tr></table></html>';
if isnan(eventdata.NewData)
    hObject.Data{eventdata.Indices(1), eventdata.Indices(2)} = [];
end
unsaved_change(handles, 'well_unsaved');


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
files = dir(fullfile('data/*.xlsx')); 
set(hObject, 'String', {files.name});


% --- Executes when uipanel2 is resized.
function uipanel2_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to uipanel2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
wellData = evalin('base', 'well_data');
data = cell2mat(cellfun(@filterCells, wellData(:,2:size(wellData,2)), 'UniformOutput', false));
%data(:,4:size(data,2)) = fliplr(data(:,4:size(data,2)));
quadsize = [0.1 0.1];
limits = [0 evalin('base','area_x_dim');0 evalin('base','area_y_dim')];
strati_data = evalin('base', 'strati_data');
num_layers = size(strati_data,1);
interp_types = get(handles.popupmenu2,'String');

for layer_id = size(strati_data,1):-1:1
    layer = size(strati_data,1) - layer_id + 1;
    [x, y, z] = getSurfaceData('distri', layer_id, interp_types{get(handles.popupmenu2,'Value')}, data(:,1), data(:,2), data(:,layer+3), limits, quadsize);
    for line = 1:size(data,1)
        if(~isempty(wellData{line,5}) && isempty(wellData{line,layer+5}))
        	estimate = -interp2(x',y',z',data(line,1), data(line,2));
            if(layer < num_layers && estimate > data(line,layer+2))
                estimate = data(line,layer+2);
            end
            if(layer > 1 && estimate < max(data(line,layer+4:end)))
                estimate = max(data(line,layer+4:end));
            end
            if ~isnan(estimate)
                wellData{line,layer+5} = estimate;
                set(handles.uitable1, 'Data', wellData);
            end
        end
    end
end
set(handles.uitable1, 'Data', wellData);
unsaved_change(handles, 'well_unsaved');

function out = filterCells(in)
if ~isempty(in)
    out = in;
else
    out = NaN;
end


function out = nan2zero(in)
if isnan(in)
    out = 0;
else
    out = in;
end

function out = nan2val(in, in_upper, in_lower)
if isnan(in)
    if in_lower == true
        out = NaN;
    else
        out = 0;
    end
else
    out = in - in_upper;
end

function out = pos2zero(in)
if in > 0
    out = 0;
else
    out = in;
end
