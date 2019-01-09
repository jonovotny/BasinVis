function varargout = submapwindow(varargin)
%submapwindow M-file for submapwindow.fig
%      submapwindow, by itself, creates a new submapwindow or raises the existing
%      singleton*.
%
%      H = submapwindow returns the handle to a new submapwindow or the handle to
%      the existing singleton*.
%
%      submapwindow('Property','Value',...) creates a new submapwindow using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to submapwindow_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      submapwindow('CALLBACK') and submapwindow('CALLBACK',hObject,...) call the
%      local function named CALLBACK in submapwindow.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
setupWsVar('sub_plot_data', {});
setupWsVar('sub_wells',{});
setupWsVar('submap_well_ids',{});
% Edit the above text to modify the response to help submapwindow

% Last Modified by GUIDE v2.5 26-Apr-2015 03:15:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @submapwindow_OpeningFcn, ...
                   'gui_OutputFcn',  @submapwindow_OutputFcn, ...
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


% --- Executes just before submapwindow is made visible.
function submapwindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for submapwindow
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes submapwindow wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = submapwindow_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in button_reload.
function button_reload_Callback(hObject, eventdata, handles)
% hObject    handle to button_reload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plotSettings = get(handles.tab_mapping, 'Data');
axisSettings = get(handles.tab_axes, 'Data');
contSettings = get(handles.uitable3, 'Data');
poro_data = evalin('base','poro_data');
num_ages = size(poro_data, 1);

test_type = get(handles.popup_plottype, 'Value');
strati_data = evalin('base', 'strati_data');
layerNames = strati_data(:,1);
layerNames{size(layerNames, 1)+1, 1} = 'BA';

first_plot = true;
fig_title = 'Subsidence Model (';


sel_wells = get(handles.uitable4, 'Data');
sel_well_names = evalin('base', 'submap_well_ids');
data_bs = [];
data_ts = [];
data_bsr = [];
data_tsr = [];

for well = 1:size(sel_wells, 1);
   if sel_wells(well)
       processing = sel_well_names(well)

       backstrip = getBackstrippingData(sel_well_names(well), true);
       line = backstrip{1,1};
       data_bs(size(data_bs,1)+1, 1:2) = cell2mat(evalin('base',['well_data(' num2str(sel_well_names(well)) ',2:3)']));
       data_bs(size(data_bs,1), 3:num_ages+2) = cell2mat(line); 
       
       line = backstrip{1,2};
       data_bsr(size(data_bsr,1)+1, 1:2) = cell2mat(evalin('base',['well_data(' num2str(sel_well_names(well)) ',2:3)']));
       data_bsr(size(data_bsr,1), 3:num_ages+2) = cell2mat(line); 
       
       line = backstrip{1,3};
       data_ts(size(data_ts,1)+1, 1:2) = cell2mat(evalin('base',['well_data(' num2str(sel_well_names(well)) ',2:3)']));
       data_ts(size(data_ts,1), 3:num_ages+2) = cell2mat(line); 
       
       line = backstrip{1,4};
       data_tsr(size(data_tsr,1)+1, 1:2) = cell2mat(evalin('base',['well_data(' num2str(sel_well_names(well)) ',2:3)']));
       data_tsr(size(data_tsr,1), 3:num_ages+2) = cell2mat(line); 
   end
end

data_unpacked = {data_bs data_bsr data_ts data_tsr };



try
    fig = evalin('base','subfig');
catch ex
    fig = figure;
end

if ~ishandle(fig)
    fig = figure;
    assignin('base','subfig',fig);
end

figure(fig);
clf(fig);
hold on



for layer = 1:size(plotSettings,1)
quadsize = cell2mat(axisSettings(1:2, 6))';
    
limits = cell2mat(axisSettings(1:2, 2:3));
zlimit = [-axisSettings{3, 3} axisSettings{3, 2}];
linespec = [cell2mat(plotSettings(layer, 6:7)) '-'];
levels = axisSettings{3, 2}:-plotSettings{layer,10}:-axisSettings{3, 3};
aspectRatio = cell2mat(axisSettings(:, 5))';
%cmap = evalin('base','cmap7');color = plotSettings{layer,3};
color = plotSettings{layer,4};
climit = [-axisSettings{3, 3} 0];
plot = [plotSettings{layer,2} plotSettings{layer,5} plotSettings{layer,8}];
shading = 'none';
contourcolor = plotSettings{layer,9};


%%%%%%%%%%%%%
% Mask stuff
%%%%%%%%%%%%%

use_masks = evalin('base', 'use_masks');

if use_masks
    limits = cell2mat(axisSettings(1:2, 2:3));
    num_layers = evalin('base', 'length(strati_data) + 1');
    masks = cell(1,num_layers);
    files = {'7_PA', '6_SA', '5_UBA', '4_LBA', '3_UKA', '2_LKA', '1_EO', '0_basement'};
    for i = 1:num_layers
        im_mask = imrotate(imread(['mask\' files{1,i} '.jpg']),-90);
        im_mask = imresize(im_mask, [(limits(1,2)/quadsize(1,1))+1 (limits(2,2)/quadsize(1,2))+1] ,'cubic');
        bw_mask = im2bw(im_mask, 0.8);
        nan_mask = ones(size(bw_mask));
        nan_mask(~bw_mask) = NaN;
        masks{1,i} = nan_mask;
    end
end




if (plot(1,1) || plot(1,2) || plot(1,3) || layer == find(ismember(layerNames,contSettings{1,2})))
    if(first_plot)
       first_plot = false; 
    else
        fig_title = [fig_title, ', '];
    end
    fig_title = [fig_title, layerNames{layer, 1}];
end

data = data_unpacked{1, test_type};

   
if plot(1,2)
    [x, y, z] = getSurfaceData(['subsi_' num2str(test_type)], layer, 'none', data(:,1), data(:,2), data(:, layer+2), limits, quadsize);
    
    x = x';
    y = y';
    z = z';
    plotq = quiver3(x,y,zeros(1,size(x,2)),zeros(1,size(x,2)),zeros(1,size(x,2)),z,0,linespec,'markersize',3,'linewidth',1.0);
end

if plot(1,1)
    [surfaceX, surfaceY, surfaceZ] = getSurfaceData(['subsi_' num2str(test_type)], layer, plotSettings(layer,3), data(:,1), data(:,2), data(:,layer+2), limits, quadsize);
        
%     if (strcmp(cp_type, 'single'))
%         if ~(get(handles.popup_plottype, 'Value') == 2)
%             surfaceZ = zeros(size(surfaceZ,1), size(surfaceZ,2));
%             for l = 1:layer
%                 [~, ~, surfaceZ2] = getSurfaceData('distri_s', l, plotSettings(layer,3), data(:,1), data(:,2), data(:,l+3), limits, quadsize);
%                 surfaceZ = surfaceZ + arrayfun(@pos2zero, surfaceZ2);
%             end
%         end
%     else
%     [surfaceX, surfaceY, surfaceZ] = getSurfaceData('distri', layer, plotSettings(layer,3), data(:,1), data(:,2), data(:,layer+3), limits, quadsize);
%         if (layer > 1 && get(handles.popup_plottype, 'Value') == 2)
%             [~, ~, top_z] = getSurfaceData('distri', layer-1, plotSettings(layer-1,3), data(:,1), data(:,2), data(:,layer+2), limits, quadsize);
%             surfaceZ = surfaceZ - top_z;
%         end
    if use_masks
        surfaceZ = surfaceZ .* masks{1,layer};
    end

    plots = surf(surfaceX, surfaceY, surfaceZ, 'FaceColor', 'interp' ...%  color ...
                                      , 'FaceLighting', shading ...
                                      , 'LineStyle',    'none' ...
                                  ,'SpecularColorReflectance', 0);
    colormap(color);

    
end

if plot(1,3)
%     if (strcmp(cp_type, 'single'))
%         [surfaceX, surfaceY, surfaceZ] = getSurfaceData('distri_s', layer, plotSettings(layer,3), data(:,1), data(:,2), data(:,layer+3), limits, quadsize);
%         if ~(get(handles.popup_plottype, 'Value') == 2)
%             surfaceZ = zeros(size(surfaceZ,1), size(surfaceZ,2));
%             for l = 1:layer
%                 [~, ~, surfaceZ2] = getSurfaceData('distri_s', l, plotSettings(layer,3), data(:,1), data(:,2), data(:,l+3), limits, quadsize);
%                 surfaceZ = surfaceZ + arrayfun(@pos2zero, surfaceZ2);
%             end
%         end
%     else
%         [surfaceX, surfaceY, surfaceZ] = getSurfaceData('distri', layer, plotSettings(layer,3), data(:,1), data(:,2), data(:,layer+3), limits, quadsize);
%         if (layer > 1 && get(handles.popup_plottype, 'Value') == 2)
%             [~, ~, top_z] = getSurfaceData('distri', layer-1, plotSettings(layer-1,3), data(:,1), data(:,2), data(:,layer+2), limits, quadsize);
%             surfaceZ = surfaceZ - top_z;
%         end
%     end
    [surfaceX, surfaceY, surfaceZ] = getSurfaceData(['subsi_' num2str(test_type)], layer, plotSettings(layer,3), data(:,1), data(:,2), data(:,layer+2), limits, quadsize);
    if use_masks
        surfaceZ = surfaceZ .* masks{1,layer};
    end
    plotc = contour3(surfaceX, surfaceY, surfaceZ, levels, contourcolor); % contourplot color 'w' - white 'k' - black
end

set(gca,'DataAspectRatio', aspectRatio); %[1 1 1]);
set(gca,'XLim', (limits(1,:)));
set(gca,'YLim', (limits(2,:)));
set(gca,'ZLim', zlimit);
set(gca,'CameraPosition',  [-30 -30 20]);
set(gca,'Color', 'white', 'XColor', 'black', 'YColor', 'black', 'ZColor', 'black'); %axis and axisbackground color



end

ztype = {'Subsidence: ', 'Subsidence: '};
if(test_type == 2 || test_type == 4)
    ztype{1,1} = 'Rate: ';
end

if ~strcmp(contSettings{1,1}, 'none')
    layerNames = get(handles.tab_mapping, 'RowName');
    layer = find(ismember(layerNames,contSettings{1,2}));
    
    test_type = contSettings{1,1};

    switch test_type
        case 'Total Subsidence'
            test_type = 1;
        case 'Total Subsidence Rate'
            test_type = 2;
        case 'Tectonic Subsidence'
            test_type = 3;
        case 'Tectonic Subsidence Rate'
            test_type = 4;
    end
    
    data = data_unpacked{1, test_type};

    [surfaceX, surfaceY, surfaceZ] = getSurfaceData(['subsi_' num2str(test_type)], layer, contSettings(1,3), data(:,1), data(:,2), data(:,layer+2), limits, quadsize);
     %[x, y, z] = getSurfaceData('distri', layer, 'none', data(:,1), data(:,2), data(:,layer+3), limits, quadsize);
    
    levels2 = axisSettings{3, 2}:-contSettings{1,5}:min(min(surfaceZ));
    slice_offset = contSettings{1,7}; %2.5 *2.5;
    
    if use_masks
        surfaceZ = surfaceZ .* masks{1,layer};
    end
    
    surfaceX = repmat(surfaceX', [1 1 2]);
    surfaceY = repmat(surfaceY', [1 1 2]);
    surfaceV = repmat(surfaceZ', [1 1 2]);
    assignin('base','surfaceV', surfaceV);
    %[plotcont, h] = contourf(surfaceX, surfaceY, surfaceZ, levels, contourcolor);
    surfaceZ = zeros(size(surfaceX, 1), size(surfaceX, 2), 2);
    surfaceZ(:,:,1) = -axisSettings{3,3}-slice_offset;
    surfaceZ(:,:,2) = -axisSettings{3,3}-slice_offset-1;
    
    if (~strcmp(contSettings{1,6}, 'none'))
        h = slice(surfaceX, surfaceY, surfaceZ, surfaceV, [], [], -axisSettings{3,3}-slice_offset);
        set(h, 'FaceColor', contSettings{1,6});%'interp';
        set(h, 'EdgeColor', 'none');
        %colormap(contSettings{1,6});
    end
    h = contourslice(surfaceX, surfaceY, surfaceZ, surfaceV, [], [], -axisSettings{3,3}-slice_offset, levels2);
    set(h, 'EdgeColor', contSettings{1,4});

    
    set(gca,'ZLim', zlimit - [slice_offset 0]);
end

fig_title(1, end + 1) = ')';
set(gcf,'name', fig_title,'numbertitle','off')

set(gca,'CLim', climit);
set(gca,'Box','on','XGrid', 'on', 'YGrid', 'on', 'ZGrid', 'on');
xlabel('X [km]');%, 'FontSize',20)
ylabel('Y [km]');%, 'FontSize',20)
zlabel('Depth [km]');%, 'FontSize',20);
view(-20,40);
colorbar;

%if(test_type == 2 || test_type == 4)
%    ztype{1,2} = 'Rate: ';
%end
ztype = {'Depth: ', 'Depth: ', 'm', 'm'};
if(test_type == 2 || test_type == 4)
    ztype{1,2} = 'Rate: ';
    ztype{1,4} = 'm/Ma';
end
set(gca, 'UserData', ztype);

dcm_obj = datacursormode(fig);
set(dcm_obj, 'UpdateFcn', @datatip);


hold off


function out = filterCells(in)
if ~isempty(in)
    out = in;
else
    out = NaN;
end

% --- Executes on button press in button_export.
function button_export_Callback(hObject, eventdata, handles)
% hObject    handle to button_export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when entered data in editable cell(s) in tab_mapping.
function tab_mapping_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to tab_mapping (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected cell(s) is changed in tab_mapping.
function tab_mapping_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to tab_mapping (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function tab_mapping_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tab_mapping (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

try
    data = evalin('base', 'sub_plot_data');
catch ex
    data = {};
end

strati_data = evalin('base', 'strati_data');
if size(data,1) ~= size(strati_data,1)
    data = cell(size(strati_data,1),1);
    data(:,1) = strati_data(:,3);
    assignin('base', 'sub_plot_data', data);
end

rowHeaders = strati_data(:,1);

cmaps = {'Jet' 'HSV' 'Hot' 'Cool' 'Spring' 'Summer' 'Autumn' 'Winter' 'Gray' 'Bone' 'Copper' 'Pink' 'Lines'};
interpols = {'linear', 'natural', 'cubic', 'kriging', 'TPS'};
colors = {'r' 'g' 'b' 'c' 'm' 'y' 'k' 'w'};
symbols = {'+' 'o' '*' '.' 'x' 's' 'd' '^' 'v' '>' '<' 'p' 'h'};
lines = {'-' '--' ':' '-.'};

for i = 1:size(data,1);
    data{i,2} = false;
    data{i,3} = 'kriging';
    data{i,4} = 'Jet'; %getDefChoice(i,colors);
    data{i,5} = false;
    data{i,6} = getDefChoice(i,symbols);
    data{i,7} = getDefChoice(i+1,colors);
    data{i,8} = false;
    data{i,9} = 'k';
    data{i,10} = 0.5;
end

set(hObject, ...
    'ColumnName', {'<html><center>Unit<br />End Age</center></html>'; 'Surface'; '<html><center>Inter-<br />polation</center></html>';'<html><center>Surface<br />Colormap</center></html>'; '<html><center>Well<br />Location</center></html>'; '<html><center>Well<br />Symbol</center></html>'; '<html><center>Well<br />Color</center></html>'; 'Contours'; '<html><center>Contour<br />Color</center></html>'; '<html><center>Contour<br />Interval</center></html>' }, ...
    'ColumnFormat', {'char' 'logical' interpols cmaps 'logical' symbols colors 'logical' colors 'numeric'}, ...
    'ColumnWidth', {70 60 70 70 60 50 50 60 50 75}, ...
    'RowName',rowHeaders, ...
    'ColumnEditable', [true true true true true true true true true true true true], ...
    'Data', data);

assignin('base', 'tab', get(hObject, 'Data'));


function [value] = getDefChoice(index, values)
if index > size(values,2)
   index = mod(index-1, size(values,2))+1;  
end
value = values{1,index};

% --- Executes when selected cell(s) is changed in tab_axes.
function tab_axes_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to tab_axes (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when entered data in editable cell(s) in tab_axes.
function tab_axes_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to tab_axes (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function tab_axes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tab_axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
data = cell(3,6);
data(1,:) = {'X' 0 evalin('base', 'area_x_dim') 'km' 1 0.4};
data(2,:) = {'Y' 0 evalin('base', 'area_y_dim') 'km' 1 0.4};
data(3,:) = {'Z' 0 evalin('base', 'area_z_dim') 'km' 0.5 ''};

data(1,:) = {'X' 0 evalin('base', 'area_x_dim') 'km' 1 100};
data(2,:) = {'Y' 0 evalin('base', 'area_y_dim') 'km' 1 100};

set(hObject, 'Data', data);


% --- Executes on button press in button_section.
function button_section_Callback(hObject, eventdata, handles)
% hObject    handle to button_section (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sectionwindow;


% --- Executes on selection change in popup_plottype.
function popup_plottype_Callback(hObject, eventdata, handles)
% hObject    handle to popup_plottype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_plottype contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_plottype
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function uitable3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uitable3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


try
    cont_data = evalin('base', 'sub_cont_data');
catch ex
    cont_data = {};
end
set(hObject, 'Data', cont_data);

cmaps = {'none' 'Jet' 'HSV' 'Hot' 'Cool' 'Spring' 'Summer' 'Autumn' 'Winter' 'Gray' 'Bone' 'Copper' 'Pink' 'Lines'};
interpols = {'linear', 'natural', 'cubic', 'TPS', 'kriging'};
colors = {'r' 'g' 'b' 'c' 'm' 'y' 'k' 'w'};
none_colors = {'none' 'r' 'g' 'b' 'c' 'm' 'y' 'k' 'w'};
symbols = {'+' 'o' '*' '.' 'x' 's' 'd' '^' 'v' '>' '<' 'p' 'h'};
lines = {'-' '--' ':' '-.'};
types = {'none', 'Total Subsidence', 'Total Subsidence Rate', 'Tectonic Subsidence', 'Tectonic Subsidence Rate'};
strati_data = evalin('base', 'strati_data');

rowHeaders = strati_data(:,1);
rowHeaders{size(rowHeaders, 1)+1, 1} = 'BA';
rowHeaders = rowHeaders';


cont_data{1,1} = 'none';
cont_data{1,2} = strati_data{1,1};
cont_data{1,3} = 'kriging';
cont_data{1,4} = 'k';
cont_data{1,5} = 500;
cont_data{1,6} = 'none';
cont_data{1,7} = 10000;


set(hObject, ...
   'ColumnName', {'<html><center>Type</center></html>'; 'Unit'; 'Interpolation';'<html><center>Contour Color</center></html>'; '<html><center>Contour Interval [m]</html>' ; 'Color'; 'Offset [m]'}, ...
   'ColumnFormat', {types rowHeaders interpols none_colors 'numeric' none_colors}, ...
   'ColumnWidth', {160 80 80 80 80 80 80}, ...
   'ColumnEditable', [true true true true true true true], ...
   'Data', cont_data ...
);

assignin('base', 'sub_cont_data', get(hObject, 'Data'));


% --- Executes during object creation, after setting all properties.
function uitable4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uitable4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
try
    sub_well_data = evalin('base', 'sub_well_data');
catch ex
    sub_well_data = {};
end
set(hObject, 'Data', sub_well_data);

well_names = evalin('base', 'well_data(:,1)');
well_data = evalin('base', 'well_data(:, 5:end)');
well_data = cell2mat(cellfun(@filterCells, well_data, 'UniformOutput', false));
%well_data = sum(well_data, 2);
well_names = well_names(find(~isnan(well_data(:,1))));
well_ids = find(~isnan(well_data(:,1)));
assignin('base', 'submap_well_ids', well_ids);
sub_well_data = repmat([true], [size(well_names, 1) 1]);
sub_well_data = mat2cell(sub_well_data, size(well_names, 1),1);
sub_well_data = sub_well_data{1,1};



cmaps = {'none' 'Jet' 'HSV' 'Hot' 'Cool' 'Spring' 'Summer' 'Autumn' 'Winter' 'Gray' 'Bone' 'Copper' 'Pink' 'Lines'};
interpols = {'linear', 'natural', 'cubic', 'TPS', 'kriging'};
colors = {'none' 'r' 'g' 'b' 'c' 'm' 'y' 'k' 'w'};
symbols = {'+' 'o' '*' '.' 'x' 's' 'd' '^' 'v' '>' '<' 'p' 'h'};
lines = {'-' '--' ':' '-.'};
types = {'none', 'Subsidence', 'Rate'};

rowHeaders = well_names;
%rowHeaders = rowHeaders';



set(hObject, ...
   'ColumnName', {'<html><center>Enabled</center></html>'}, ...
   'RowName', rowHeaders, ...
   'ColumnFormat', {'logical'}, ...
   'ColumnWidth', {55}, ...
   'ColumnEditable', [true], ...
   'Data', sub_well_data ...
);

assignin('base', 'sub_well_data', get(hObject, 'Data'));


% function out = filterCells(in)
% if ~isempty(in)
%     out = in;
% else
%     out = NaN;
% end


% --- Executes during object creation, after setting all properties.
function popup_plottype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_plottype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
