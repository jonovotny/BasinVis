function varargout = sectionwindow(varargin)
%SECTIONWINDOW M-file for sectionwindow.fig
%      SECTIONWINDOW, by itself, creates a new SECTIONWINDOW or raises the existing
%      singleton*.
%
%      H = SECTIONWINDOW returns the handle to a new SECTIONWINDOW or the handle to
%      the existing singleton*.
%
%      SECTIONWINDOW('Property','Value',...) creates a new SECTIONWINDOW using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to sectionwindow_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      SECTIONWINDOW('CALLBACK') and SECTIONWINDOW('CALLBACK',hObject,...) call the
%      local function named CALLBACK in SECTIONWINDOW.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sectionwindow

% Last Modified by GUIDE v2.5 24-Mar-2015 00:22:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sectionwindow_OpeningFcn, ...
                   'gui_OutputFcn',  @sectionwindow_OutputFcn, ...
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


% --- Executes just before sectionwindow is made visible.
function sectionwindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for sectionwindow
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sectionwindow wait for user response (see UIRESUME)
% uiwait(handles.figure1);
update_edit_fields(handles);


% --- Outputs from this function are returned to the command line.
function varargout = sectionwindow_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popup_point1_well.
function popup_point1_well_Callback(hObject, eventdata, handles)
% hObject    handle to popup_point1_well (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_point1_well contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_point1_well
update_edit_fields(handles);

% --- Executes during object creation, after setting all properties.
function popup_point1_well_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_point1_well (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
well_names = evalin('base', 'well_data(:,1)');
well_names(2:end+1) = well_names(1:end);
well_names{1,1} = 'Manual Point';
set(hObject, 'String', well_names);


% --- Executes on button press in button_section.
function button_section_Callback(hObject, eventdata, handles)
% hObject    handle to button_section (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
section_type = get(handles.popup_sectiontype, 'Value');
extend_section = get(handles.chk_border, 'Value');

section_points = evalin('base', 'section_points');

start_point = section_points(1,:);
end_point = section_points(2,:);
if extend_section
    start_point = section_points(3,:);
    end_point = section_points(4,:);
end

step = (end_point - start_point)*0.2/norm(end_point - start_point);
qX = start_point(1,1):step(1,1):end_point(1,1);
qX(1,end+1) = end_point(1,1);
qY = start_point(1,2):step(1,2):end_point(1,2);
qY(1,end+1) = end_point(1,2);

if step(1,1) == 0
    qX = repmat(start_point(1,1), [1 length(qY)]);
end

if step(1,2) == 0
    qY = repmat(start_point(1,2), [1 length(qX)]);
end


qU = 0:0.2:(length(qX)-2)*0.2;
qU(1,end+1) = qU(1,end) + norm([qX(1,end-1) qY(1,end-1)] - end_point);

strati_data = evalin('base', 'strati_data');
layerNames = strati_data(:,1);
layerNames{size(layerNames, 1)+1, 1} = 'BA';

first_plot = true;
fig_title = 'Cross-Section';

figure;
hold all


wellData = evalin('base', 'well_data');
data = cell2mat(cellfun(@filterCells, wellData(:,2:size(wellData,2)), 'UniformOutput', false));
data(:,4:size(data,2)) = fliplr(data(:,4:size(data,2)));
limits = [0 evalin('base', 'area_x_dim'); 0 evalin('base', 'area_y_dim')];
quadsize = [0.4 0.4];

temp_data = data(:,4:end);
temp_data(:,1) = arrayfun(@nan2zero, temp_data(:,1));
diff_data = zeros(size(temp_data, 1), size(temp_data, 2));
diff_data(:, 1:end-1) = temp_data(:, 2:end) - temp_data(:, 1:end-1);

strati_data = evalin('base', 'strati_data');
num_layers = size(strati_data, 1);

cp_type = 'singl';
% if (strcmp(cp_type, 'single'))
%     single_data = data(:,4:end);
%     single_data(:,1) = arrayfun(@nan2zero, single_data(:,1));
%     for l = 2:size(plotSettings,1)
%        %single_data(:,l) = single_data(:,l) - single_data(:,l-1);
%        sublayer = ~isnan(ones(size(single_data,1),1));
%        if l < size(plotSettings,1)
%             sublayer = all(isnan(single_data(:,l+1:end)),2);
%        end
%        sum_dat = single_data(:,1:l-1);
%         if size(sum_dat,2) > 1
%             sum_dat = sum(sum_dat, 2);
%         end
%        single_data(:,l) = arrayfun(@nan2val, single_data(:,l), sum_dat, sublayer);
%     end
%     
%     data(:,4:end) = single_data;
% end




for layer = num_layers+1:-1:1



if (strcmp(cp_type, 'single'))
    [surfaceX, surfaceY, surfaceZ] = getSurfaceData('distri_s', layer, plotSettings(layer,3), data(:,1), data(:,2), data(:,layer+3), limits, quadsize);
    if ~(get(handles.popup4, 'Value') == 2)
        surfaceZ = zeros(size(surfaceZ,1), size(surfaceZ,2));
        for l = 1:layer
            [~, ~, surfaceZ2] = getSurfaceData('distri_s', l, plotSettings(layer,3), data(:,1), data(:,2), data(:,l+3), limits, quadsize);
            surfaceZ = surfaceZ + arrayfun(@pos2zero, surfaceZ2);
        end
    end
else
[surfaceX, surfaceY, surfaceZ] = getSurfaceData('distri', layer, 'TPS', data(:,1), data(:,2), data(:,layer+3), limits, quadsize);
    if (get(handles.popupmenu4, 'Value') == 2)
        [surfaceX, surfaceY, surfaceZ] = getSurfaceData('distri_iso', layer, plotSettings(layer,3), data(:,1), data(:,2), diff_data(:,layer), limits, quadsize);
        %[~, ~, top_z] = getSurfaceData('distri', layer-1, plotSettings(layer-1,3), data(:,1), data(:,2), data(:,layer+2), limits, quadsize);
        %surfaceZ = arrayfun(@pos2zero, top_z) - arrayfun(@pos2zero, surfaceZ);
    end



%l = camlight(0,10);
end

qV = interp2(surfaceX', surfaceY', surfaceZ', qX, qY); 
plot(qU, qV);

end

%fig_title(1, end + 1) = '';
set(gcf,'name', fig_title,'numbertitle','off')

switch section_type
    case 1
        xlabel('Y [km]');%, 'FontSize',20);
    case 2
        xlabel('X [km]');%, 'FontSize',20);
    case 3
        xlabel('Section Path [km]');%, 'FontSize',20);
end
ylabel('Depth [km]');%, 'FontSize',20)
layerNames = fliplr(layerNames');
legend(layerNames, 'Orientation', 'horizontal', 'Location', 'southoutside');

zlim = [-evalin('base', 'area_z_dim') 0];
set(gca, 'YLim', zlim);
xlim = [0 qU(1, end)];
set(gca, 'XLim', xlim);
set(gca, 'DataAspectRatio', [1 0.66 1]);

set(gca, 'LineWidth', 1);
%set(gca, 'FontSize', 20);

hold off





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


% --- Executes on selection change in popup_point2_well.
function popup_point2_well_Callback(hObject, eventdata, handles)
% hObject    handle to popup_point2_well (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_point2_well contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_point2_well
update_edit_fields(handles);

% --- Executes during object creation, after setting all properties.
function popup_point2_well_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_point2_well (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
well_names = evalin('base', 'well_data(:,1)');
well_names(2:end+1) = well_names(1:end);
well_names{1,1} = 'Manual Point';
set(hObject, 'String', well_names);


% --- Executes on selection change in popup_sectiontype.
function popup_sectiontype_Callback(hObject, eventdata, handles)
% hObject    handle to popup_sectiontype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_sectiontype contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_sectiontype
update_edit_fields(handles);

% --- Executes during object creation, after setting all properties.
function popup_sectiontype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_sectiontype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_point1_x_Callback(hObject, eventdata, handles)
% hObject    handle to edit_point1_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_point1_x as text
%        str2double(get(hObject,'String')) returns contents of edit_point1_x as a double
update_edit_fields(handles);

% --- Executes during object creation, after setting all properties.
function edit_point1_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_point1_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
default = evalin('base', 'area_x_dim')/2;
set(hObject, 'String', default);



function edit_point1_y_Callback(hObject, eventdata, handles)
% hObject    handle to edit_point1_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_point1_y as text
%        str2double(get(hObject,'String')) returns contents of edit_point1_y as a double
update_edit_fields(handles);

% --- Executes during object creation, after setting all properties.
function edit_point1_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_point1_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
default = evalin('base', 'area_y_dim')/2;
set(hObject, 'String', default);


function edit_point2_x_Callback(hObject, eventdata, handles)
% hObject    handle to edit_point2_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_point2_x as text
%        str2double(get(hObject,'String')) returns contents of edit_point2_x as a double
update_edit_fields(handles);

% --- Executes during object creation, after setting all properties.
function edit_point2_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_point2_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
default = evalin('base', 'area_x_dim')/2;
set(hObject, 'String', default);


function edit_point2_y_Callback(hObject, eventdata, handles)
% hObject    handle to edit_point2_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_point2_y as text
%        str2double(get(hObject,'String')) returns contents of edit_point2_y as a double
update_edit_fields(handles);

% --- Executes during object creation, after setting all properties.
function edit_point2_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_point2_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
default = evalin('base', 'area_y_dim')/2;
set(hObject, 'String', default);


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4


% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chk_border.
function chk_border_Callback(hObject, eventdata, handles)
% hObject    handle to chk_border (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

update_edit_fields(handles);


function update_edit_fields(handles)
section_type = get(handles.popup_sectiontype, 'Value');
point1_type = get(handles.popup_point1_well, 'Value');
point2_type = get(handles.popup_point2_well, 'Value');

area_x = evalin('base', 'area_x_dim');
area_y = evalin('base', 'area_y_dim');

if point1_type > 1
    well_id = point1_type - 1;
    well_pos = cell2mat(evalin('base', ['well_data(' num2str(well_id) ', 2:3)']));
    set(handles.edit_point1_x, 'String', well_pos(1, 1)); 
    set(handles.edit_point1_y, 'String', well_pos(1, 2));
end

if point2_type > 1
    well_id = point2_type - 1;
    well_pos = cell2mat(evalin('base', ['well_data(' num2str(well_id) ', 2:3)']));
    set(handles.edit_point2_x, 'String', well_pos(1, 1)); 
    set(handles.edit_point2_y, 'String', well_pos(1, 2));
end

set(handles.edit_point1_x, 'String', clamp(str2double(get(handles.edit_point1_x, 'String')), 0, area_x)); 
set(handles.edit_point1_y, 'String', clamp(str2double(get(handles.edit_point1_y, 'String')), 0, area_y));
set(handles.edit_point2_x, 'String', clamp(str2double(get(handles.edit_point2_x, 'String')), 0, area_x)); 
set(handles.edit_point2_y, 'String', clamp(str2double(get(handles.edit_point2_y, 'String')), 0, area_y));

if  ((str2double(get(handles.edit_point1_x, 'String')) == str2double(get(handles.edit_point2_x, 'String'))) && (str2double(get(handles.edit_point1_y, 'String')) == str2double(get(handles.edit_point2_y, 'String'))) && (section_type > 2))
    point1_x = str2double(get(handles.edit_point1_x, 'String'));
    if point1_x < (area_x - 0.1)
        set(handles.edit_point2_x, 'Value', point1_x + 0.1);
    else
        set(handles.edit_point2_x, 'Value', point1_x - 0.1);
    end
    errordlg('Please select two different point locations for Point A and B');
end    

if section_type > 2
    set(handles.popup_point2_well, 'Enable', 'on');
    set(handles.edit_point2_x, 'Enable', 'on');
    set(handles.edit_point2_y, 'Enable', 'on');
else
    set(handles.popup_point2_well, 'Enable', 'off');
    set(handles.edit_point2_x, 'Enable', 'off');
    set(handles.edit_point2_y, 'Enable', 'off');
end

update_markers(handles);


function update_markers(handles)
section_type = get(handles.popup_sectiontype, 'Value');
area_x = evalin('base', 'area_x_dim');
area_y = evalin('base', 'area_y_dim');

point1 = [0 0];
point2 = [0 0];

border1 = [0 0];
border2 = [0 0];

switch (section_type)
    case 1
        point1 = [str2double(get(handles.edit_point1_x, 'String')) 0];
        point2 = [str2double(get(handles.edit_point1_x, 'String')) area_y];
        border1 = point1;
        border2 = point2;
    case 2
        point1 = [0 str2double(get(handles.edit_point1_y, 'String'))];
        point2 = [area_x str2double(get(handles.edit_point1_y, 'String'))];
        border1 = point1;
        border2 = point2;
    case 3
        point1 = [str2double(get(handles.edit_point1_x, 'String')) str2double(get(handles.edit_point1_y, 'String'))];
        point2 = [str2double(get(handles.edit_point2_x, 'String')) str2double(get(handles.edit_point2_y, 'String'))];
end
pos = [point1' point2'];

init_wells(handles);
hold on;
plot(pos(1,:),pos(2,:), 'x-b');
if get(handles.chk_border, 'Value') && (section_type == 3)
    
    diff_y = (point2(1,2)-point1(1,2));
    diff_x = (point2(1,1)-point1(1,1));

    
    
    if diff_y == 0
        border1 = [0 point2(1,2)];
        border2 = [area_x point2(1,2)];        
    else if diff_x == 0
            border1 = [point2(1,1) 0];
            border2 = [point2(1,1) area_x ];  
        else
            a = diff_y/diff_x;
            b = point1(1,2) - a*point1(1,1);
            
            x0 = -b/a;
            border1 = [x0 0];
            if x0 < 0
               border1 = [0 -x0*a]; 
            end
            if x0 > area_x
               border1 = [area_x (area_x-x0)*a]; 
            end
            
            xmax = (area_y-b)/a;
            border2 = [xmax area_y];
            if xmax < 0
               border2 = [0 area_y-(xmax*a)]; 
            end
            if xmax > area_x
               border2 = [area_x area_y-((xmax-area_x)*a)]; 
            end
        end
    end
    
    border_pos = [border1' border2'];
    
    line(border_pos(1,:), border_pos(2,:), 'Color', 'b');


end
hold off;

assignin('base', 'section_points', [point1; point2; border1; border2]);

function init_wells(handles)
axes(handles.axes_map);
cla;
x = cell2mat(evalin('base', 'well_data(:,2)'));
y = cell2mat(evalin('base', 'well_data(:,3)'));

scatter(x', y', 'o', 'MarkerEdgeColor', [0.8 0.8 0.8]);

set(gca, 'XLim', [0 evalin('base', 'area_x_dim')]);
set(gca, 'YLim', [0 evalin('base', 'area_y_dim')]);
set(gca, 'DataAspectRatio', [1 1 1]);


function y = clamp(x,a,b)

y = min(max(x,a),b);
    
