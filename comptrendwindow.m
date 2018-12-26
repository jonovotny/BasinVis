function varargout = comptrendwindow(varargin)
%comptrendwindow M-file for comptrendwindow.fig
%      comptrendwindow, by itself, creates a new comptrendwindow or raises the existing
%      singleton*.
%
%      H = comptrendwindow returns the handle to a new comptrendwindow or the handle to
%      the existing singleton*.
%
%      comptrendwindow('Property','Value',...) creates a new comptrendwindow using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to comptrendwindow_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      comptrendwindow('CALLBACK') and comptrendwindow('CALLBACK',hObject,...) call the
%      local function named CALLBACK in comptrendwindow.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help comptrendwindow

% Last Modified by GUIDE v2.5 08-Jul-2018 23:46:18
setupWsVar('comptrend_unsaved', 0);
setupWsVar('comptrend_data', {});
setupWsVar('comptrend_custom_data', {});
setupWsVar('comptrend_params', {});
setupWsVar('comptrend_custom_params', []);
setupWsVar('comptrend_sel', [0 0]);
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @comptrendwindow_OpeningFcn, ...
                   'gui_OutputFcn',  @comptrendwindow_OutputFcn, ...
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


% --- Executes just before comptrendwindow is made visible.
function comptrendwindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for comptrendwindow
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes comptrendwindow wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = comptrendwindow_OutputFcn(hObject, eventdata, handles)
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
unsaved_change(handles, 'comptrend_unsaved');
addUITableRow( handles.uitable1, 'comptrend_sel', 1);


% --- Executes on button press in button_save.
function button_save_Callback(hObject, eventdata, handles)
% hObject    handle to button_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
assignin('base', 'comptrend_data', get(handles.uitable1, 'Data'));
changes_saved(handles, 'comptrend_unsaved');
assignin('base', 'comptrend_assign', 1);

% --- Executes during object creation, after setting all properties.
function uitable1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uitable2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'Data', {});
headers = {'<html><center>Depth [m]</center></html>', ...
           '<html><center>Porosity [%]</center></html>',};
%strati_data = evalin('base', 'strati_data');
widths = {120 120};
formats = {'numeric' 'numeric'};
editable = [true true];

set(hObject, 'ColumnName', headers);
set(hObject, 'ColumnWidth', widths);
set(hObject, 'ColumnFormat', formats);
set(hObject, 'ColumnEditable', editable);
data = evalin('base', 'comptrend_data');
set(hObject, 'Data', data);

% --- Executes on button press in button_cancel.
function button_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to button_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = evalin('base', 'comptrend_data');
set(handles.uitable1, 'Data', data);
changes_saved(handles, 'comptrend_unsaved');

% --- Executes on button press in button_below.
function button_below_Callback(hObject, eventdata, handles)
% hObject    handle to button_below (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
unsaved_change(handles, 'comptrend_unsaved');
addUITableRow( handles.uitable1, 'comptrend_sel', 0);

% --- Executes on button press in button_delete.
function button_delete_Callback(hObject, eventdata, handles)
% hObject    handle to button_delete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
unsaved_change(handles, 'comptrend_unsaved');
delUITableRow( handles.uitable1, 'comptrend_sel');


% --- Executes on button press in button_fill.
function button_fill_Callback(hObject, eventdata, handles)
% hObject    handle to button_fill (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% [~ , ~, xlsdata] = xlsread('Wells_data_visul.xlsx','Final Depth Data');%evalin('base', 'comptrend_data_test');

[openfile, openpath, ~] = uigetfile('*.xls;*.xlsx', 'Import Data');
openfile = [openpath openfile];
[~ , ~, xlsdata] = xlsread(openfile);

data = xlsdata(2:end,1:2);
data = cellfun(@filterCells2, data, 'UniformOutput', false);

assignin('base', 'comptrend_custom_data', cell(size(data)));

set(handles.uitable1, 'Data', data);

function out = filterCells2(in)
if isnan(in)
    out = [];
else
    out = in;
end


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
assignin('base', 'comptrend_sel', eventdata.Indices);


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
unsaved_change(handles, 'comptrend_unsaved');


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
data_tab = get(handles.uitable1, 'Data');
data = cell2mat(cellfun(@filterCells, data_tab, 'UniformOutput', false));
data(any(isnan(data), 2), :) = [];
data(:,2) = data(:,2);%./100;
[linfit, lingof, ~] = fit(data(:,1),data(:,2), 'poly1');
[expfit, expgof, ~] = fit(data(:,1),data(:,2), 'exp1');
[exp2fit, exp2gof, ~] = fit(data(:,1),data(:,2), 'exp2');

set(handles.edit1,'String',num2str(linfit.p2, '%100.3f'));
set(handles.edit2,'String',-1/linfit.p1);
set(handles.text10,'String',['R²: ' num2str(lingof.rsquare)]);

set(handles.edit3,'String',num2str(expfit.a, '%100.3f'));
set(handles.edit4,'String',-1/expfit.b);
set(handles.text11,'String',['R²: ' num2str(expgof.rsquare)]);

set(handles.edit5,'String',num2str(exp2fit.a, '%1.5f'));
set(handles.edit6,'String',-1/exp2fit.b);
set(handles.edit7,'String',num2str(exp2fit.c, '%1.5f'));
set(handles.edit8,'String',-1/exp2fit.d);
set(handles.text12,'String',['R²: ' num2str(exp2gof.rsquare)]);

figure;
plot(data(:,1),data(:,2),'.', 'Markersize', 10.0);
hold on
plot(linfit,'r');
plot(expfit,'g');
plot(exp2fit,'b');
legend('Data','linear fit','exponential fit 1', 'exponential fit 2', 'Location', 'southeast');
view([90 90]);
ylabel('Porosity [%]');
xlabel('Depth [m]');
hold off
set(gcf,'name', 'Compaction Trend Plot','numbertitle','off');


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



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
