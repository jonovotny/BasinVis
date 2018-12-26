function varargout = porowindow(varargin)
%POROWINDOW M-file for porowindow.fig
%      POROWINDOW, by itself, creates a new POROWINDOW or raises the existing
%      singleton*.
%
%      H = POROWINDOW returns the handle to a new POROWINDOW or the handle to
%      the existing singleton*.
%
%      POROWINDOW('Property','Value',...) creates a new POROWINDOW using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to porowindow_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      POROWINDOW('CALLBACK') and POROWINDOW('CALLBACK',hObject,...) call the
%      local function named CALLBACK in POROWINDOW.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help porowindow

% Last Modified by GUIDE v2.5 14-Jun-2015 20:41:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @porowindow_OpeningFcn, ...
                   'gui_OutputFcn',  @porowindow_OutputFcn, ...
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


% --- Executes just before porowindow is made visible.
function porowindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for porowindow
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes porowindow wait for user response (see UIRESUME)
% uiwait(handles.figure1);
update_popupmenu1(handles);


% --- Outputs from this function are returned to the command line.
function varargout = porowindow_OutputFcn(hObject, eventdata, handles)
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
well_id = get(handles.popupmenu1, 'Value');
if well_id == 1
    assignin('base', 'poro_data', get(handles.uitable2, 'Data'));
else
    well_id = well_id - 1;
    if ~isequal(get(handles.uitable2, 'Data'), evalin('base', 'poro_data'))
        well_params = evalin('base', 'well_params'); 
        well_params{well_id, 1} = [];
        well_params{well_id, 1} = get(handles.uitable2, 'Data');
        assignin('base', 'well_params', well_params);
        evalin('base', ['well_custom_params(' num2str(well_id) ',1) = true;']);
    else
        if evalin('base', ['well_custom_params(' num2str(well_id) ',1)'])
           evalin('base', ['well_custom_params(' num2str(well_id) ',1) = false;']); 
           evalin('base', ['well_params{' num2str(well_id) ',1} = []']);
        end
    end
end
update_popupmenu1(handles);
assignin('base', 'poro_unsaved', 0);
assignin('base', 'poro_assign', 1);
set(evalin('base', 'sub_button'), 'Enable', 'on');
set(evalin('base', 'subana_button'), 'Enable', 'on');






% --- Executes on button press in button_cancel.
function button_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to button_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = evalin('base', 'poro_data');
set(handles.uitable2, 'Data', data);
assignin('base', 'poro_unsaved', 0);


% --- Executes during object creation, after setting all properties.
function uitable2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uitable2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
try
    data = evalin('base', 'poro_data');
catch ex
    data = {};
end
strati_data = evalin('base', 'strati_data');
if size(data,1) ~= size(strati_data,1)
    data = cell(size(strati_data,1),6);
    assignin('base', 'poro_data', data);
end
rownames = strati_data(:,1);

set(hObject, 'Data', data);
set(hObject, 'ColumnName', {'Init. Porosity', 'c', 'Waterdepth', 'Sealevel', 'Grain Density', 'Uplift'});
set(hObject, 'ColumnWidth', {90 70 70 70 90 70});
set(hObject, 'ColumnEditable', [true true true true true true]);
set(hObject, 'ColumnFormat', {'numeric' 'numeric' 'numeric'  'numeric' 'numeric' 'numeric'});
set(hObject, 'RowName', rownames);


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
assignin('base', 'poro_unsaved', 1);
set(handles.button_save, 'Visible', 'on');
set(handles.button_cancel, 'Visible', 'on');


% --- Executes on button press in button_fill.
function button_fill_Callback(hObject, eventdata, handles)
% hObject    handle to button_fill (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = get(handles.uitable2, 'Data');
pdata = evalin('base', 'poro_data_test');
data(1:size(pdata,1), 1:size(pdata,2)) = pdata;
set(handles.uitable2, 'Data', data);
uitable2_Unsaved_Edit(hObject, eventdata, handles);


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

well_id = get(hObject, 'Value');

if well_id == 1
    data(:, :) = evalin('base', 'poro_data');
else
    well_id = well_id -1;
    if evalin('base', ['well_custom_params(' num2str(well_id) ',1)'])
        data = evalin('base', ['well_params{' num2str(well_id) ',1}']);
    else
        data(:, :) = evalin('base', 'poro_data');
    end
end

        
set(handles.uitable2, 'Data', data);


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




function update_popupmenu1(handles)
update_data();
well_ids = evalin('base', 'well_data(:,1)');
manual_params = evalin('base', 'find(well_custom_params(:,1))');
for i = 1:size(manual_params, 1)
    well_ids{manual_params(i,1)} = [well_ids{manual_params(i, 1)} ' [e]']; 
end

well_ids(2:end+1, 1) = well_ids(1:end, 1);
well_ids{1,1} = 'Default';
set(handles.popupmenu1, 'String', well_ids);


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
evalin('base', 'well_custom_params = 0;');
evalin('base', 'well_params = 0;');
evalin('base', 'poro_data = 0;');
evalin('base', 'load(''poro_temp.mat'',''well_custom_params'', ''well_params'', ''poro_data'');');

data = get(handles.uitable2, 'Data');
poro_data = evalin('base', 'poro_data');
data(1:size(poro_data,1), 1:size(poro_data,2)) = poro_data;
update_popupmenu1(handles);
set(handles.uitable2, 'Data', data);
uitable2_Unsaved_Edit(hObject, eventdata, handles);


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
evalin('base','save(''poro_temp.mat'',''well_custom_params'', ''well_params'', ''poro_data'');');


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[openfile, openpath, ~] = uigetfile('*.xls;*.xlsx', 'Import Data');
openfile = [openpath openfile];
[~ , ~, xlsdata] = xlsread(openfile);

new_ids = xlsdata(2:end,1);
new_data = xlsdata(2:end, 4:end);
cur_ids = evalin('base', 'well_data(:,1)');
well_custom_params = zeros(size(cur_ids));
poro_data = evalin('base','poro_data');
well_params = evalin('base','well_params');
for i = 1:size(new_ids, 1);
    idx = find(strcmp(cur_ids,new_ids{i,1}));
    
    %Handle duplicate indices
    for j = 1:size(idx,1)
        subidx = idx(j,1);
         if well_custom_params(subidx,1)
            wp = well_params{subidx,1};
         else
            wp = poro_data;
         end
         wp(:,3) = fliplr(new_data(i,:))';
         well_params{subidx,1} = wp;
         well_params{subidx,2} = new_ids{i,1};
         well_custom_params(subidx,1) = true;
    end
end
assignin('base','well_params', well_params);
assignin('base', 'well_custom_params', well_custom_params);
update_popupmenu1(handles); 


function update_data()

cur_ids = evalin('base', 'well_data(:,1)');
well_custom_params = evalin('base', 'well_custom_params');
well_params = evalin('base','well_params');

new_custom_params = zeros(size(cur_ids));
new_params = cell(size(cur_ids, 1), 2);

if ~isempty(well_custom_params)
    for i = 1:size(cur_ids, 1)
        idx = find(strcmp(cur_ids{i,1},well_params(:,2)));
        if ~isempty(idx)
            idx = idx(1,1);
            wp = well_params{idx,1};
            new_params{i,1} = wp;
            new_params{i,2} = well_params{idx,2};
            new_custom_params(i,1) = true;
        end
    end
end

assignin('base', 'well_params', new_params);
assignin('base', 'well_custom_params', new_custom_params);
