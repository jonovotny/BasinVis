function varargout = dipslipwindow(varargin)
% DIPSLIPWINDOW MATLAB code for dipslipwindow.fig
%      DIPSLIPWINDOW, by itself, creates a new DIPSLIPWINDOW or raises the existing
%      singleton*.
%
%      H = DIPSLIPWINDOW returns the handle to a new DIPSLIPWINDOW or the handle to
%      the existing singleton*.
%
%      DIPSLIPWINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DIPSLIPWINDOW.M with the given input arguments.
%
%      DIPSLIPWINDOW('Property','Value',...) creates a new DIPSLIPWINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dipslipwindow_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dipslipwindow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dipslipwindow

% Last Modified by GUIDE v2.5 22-Mar-2015 18:23:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dipslipwindow_OpeningFcn, ...
                   'gui_OutputFcn',  @dipslipwindow_OutputFcn, ...
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

% --- Executes just before dipslipwindow is made visible.
function dipslipwindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dipslipwindow (see VARARGIN)

% Choose default command line output for dipslipwindow
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using dipslipwindow.

update_popup2(handles)

% UIWAIT makes dipslipwindow wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = dipslipwindow_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in button_dipslip.
function button_dipslip_Callback(hObject, eventdata, handles)
% hObject    handle to button_dipslip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

well1_bstrip = getBackstrippingData(get(handles.popup_well1, 'Value'));
well2_userdata = get(handles.popup_well2, 'UserData');
well2_bstrip = getBackstrippingData(well2_userdata(get(handles.popup_well2, 'Value')));

well1_sub = cell2mat(well1_bstrip{1,1});
well2_sub = cell2mat(well2_bstrip{1,1});

strati_data = evalin('base','strati_data');
ages = cell2mat(strati_data(:,3))';
%ages = [ages];% strati_data{end,2}];

well_diffs = well1_sub - well2_sub;

dipslip = well_diffs(1:(size(well_diffs, 2)-1)) - well_diffs(2:size(well_diffs, 2));
age_start = ages(2:(size(ages,2)));
age_end = ages(1:(size(ages,2)-1));
agediff = age_start - age_end;

dipslip_rate = dipslip./agediff;

dipslip_plot = zeros((size(dipslip_rate,2)*3) + 1, 2);
for i = 0:size(dipslip_rate,2)-1
    off = i * 3;
    dipslip_plot(off + 1, :) = [0 age_end(i+1)];
    dipslip_plot(off + 2, :) = [dipslip_rate(i+1) age_end(i+1)];
    dipslip_plot(off + 3, :) = [dipslip_rate(i+1) age_start(i+1)];
end

dipslip_plot((size(dipslip_rate,2)*3) + 1, :) = [0 age_start(size(age_start,2))];

figure();
plot(dipslip_plot(:,1)', dipslip_plot(:,2)');
%# vertical line
yL = get(gca, 'ylim');
yL(1,2) = age_start(end);
set(gca, 'ylim', yL);
set(gca,'YDir','Reverse')
line([0 0], ylim, 'Color', 'k');
xlabel('Vertical Displacement Rate [km/Ma]');%, 'FontSize',20);
ylabel('Geologic Age [Ma]');

names = get(handles.popup_well1, 'String');
well1_name = names{get(handles.popup_well1, 'Value'),1};
names = get(handles.popup_well2, 'String');
well2_name = names{get(handles.popup_well2, 'Value'),1};
set(gcf, 'Name', ['Dip-Slip Fault Backstripping (' well1_name ' - ' well2_name ')']);
set(gcf, 'NumberTitle', 'off');






% --- Executes on selection change in popup_well1.
function popup_well1_Callback(hObject, eventdata, handles)
% hObject    handle to popup_well1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popup_well1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_well1
% update_markers(handles);
update_popup2(handles)

% --- Executes during object creation, after setting all properties.
function popup_well1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_well1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end
well_ids = evalin('base', 'well_data(:,1)');
set(hObject, 'String', well_ids);


% --- Executes on selection change in popup_well2.
function popup_well2_Callback(hObject, eventdata, handles)
% hObject    handle to popup_well2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_well2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_well2
update_markers(handles);


% --- Executes during object creation, after setting all properties.
function popup_well2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_well2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', {'Step plot', 'Line plot'});


function init_wells(handles)
axes(handles.axes_map);
cla;
x = cell2mat(evalin('base', 'well_data(:,2)'));
y = cell2mat(evalin('base', 'well_data(:,3)'));

scatter(x', y', 'o', 'MarkerEdgeColor', [0.8 0.8 0.8]);

set(gca, 'XLim', [0 evalin('base', 'area_x_dim')]);
set(gca, 'YLim', [0 evalin('base', 'area_y_dim')]);
set(gca, 'DataAspectRatio', [1 1 1]);



function update_markers(handles)
well1_id = get(handles.popup_well1, 'Value');

well_pos = cell2mat(evalin('base', ['well_data(:, 2:3)']));
well1_pos = well_pos(well1_id, :);


well2_ids = get(handles.popup_well2, 'UserData');
well2_id = well2_ids(get(handles.popup_well2, 'Value'));
well2_pos = well_pos(well2_id, :);

pos = [well1_pos' well2_pos'];

init_wells(handles);
hold on;
scatter(well_pos(well2_ids,1),well_pos(well2_ids,2), 'bx');
plot(pos(1,:),pos(2,:), 'o-r');
hold off;

% --- Executes during object creation, after setting all properties.
function axes_map_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_map (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_map

function update_popup2(handles)
num_layers = evalin('base','length(strati_data)') + 1;

well1_id = get(handles.popup_well1, 'Value');

well2_options = evalin('base', ['well_data(:, [2:3 5:' num2str(num_layers + 4) '])']);
well2_options = cell2mat(cellfun(@empty2nan, well2_options, 'UniformOutput', false));
well2_names = evalin('base', 'well_data(:,1)');

well1_data = well2_options(well1_id, :);

index = true(size(well2_options, 1), 1);
index(well1_id, 1) = false;

for i = 1:size(well2_options, 1)
    if ~isequal(isnan(well1_data), isnan(well2_options(i,:)))
        index(i, 1) = false;
    else
        isnan(well2_options(i,:))
    end
end

strings = well2_names(index, 1);
ids = find(index);

set(handles.popup_well2, 'String', strings);
set(handles.popup_well2, 'UserData', ids');
set(handles.popup_well2, 'Value', 1);


update_markers(handles);





function out = empty2nan(in)
if isempty(in)
    out = nan;
else
    out = in;
end
