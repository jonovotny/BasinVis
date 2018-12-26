function varargout = distriwindow(varargin)
%DISTRIWINDOW M-file for distriwindow.fig
%      DISTRIWINDOW, by itself, creates a new DISTRIWINDOW or raises the existing
%      singleton*.
%
%      H = DISTRIWINDOW returns the handle to a new DISTRIWINDOW or the handle to
%      the existing singleton*.
%
%      DISTRIWINDOW('Property','Value',...) creates a new DISTRIWINDOW using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to distriwindow_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      DISTRIWINDOW('CALLBACK') and DISTRIWINDOW('CALLBACK',hObject,...) call the
%      local function named CALLBACK in DISTRIWINDOW.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help distriwindow

% Last Modified by GUIDE v2.5 26-Apr-2015 03:16:48
setupWsVar('plot_data', {});
setupWsVar('cont_data', {});
setupWsVar('distri_mask_data', {});
% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @distriwindow_OpeningFcn, ...
                   'gui_OutputFcn',  @distriwindow_OutputFcn, ...
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




% --- Executes just before distriwindow is made visible.
function distriwindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for distriwindow
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes distriwindow wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = distriwindow_OutputFcn(hObject, eventdata, handles)
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
plot_data = evalin('base', 'plot_data');

strati_data = evalin('base', 'strati_data');
layerNames = strati_data(:,1);
layerNames{size(layerNames, 1)+1, 1} = 'BA';

first_plot = true;
fig_title = 'Stratigraphic Setting (';


try
    fig = evalin('base','distrifig');
catch ex
    fig = figure;
end

if ~ishandle(fig)
    fig = figure;
    assignin('base','distrifig',fig);
end

figure(fig);
clf(fig);
hold on

wellData = evalin('base', 'well_data');
data = cell2mat(cellfun(@filterCells, wellData(:,2:size(wellData,2)), 'UniformOutput', false));
data(:,4:size(data,2)) = fliplr(data(:,4:size(data,2)));
limits = cell2mat(axisSettings(1:2, 2:3));
quadsize = cell2mat(axisSettings(1:2, 6))';

temp_data = data(:,4:end);
temp_data(:,1) = arrayfun(@nan2zero, temp_data(:,1));
diff_data = zeros(size(temp_data, 1), size(temp_data, 2));
diff_data(:, 1:end-1) = temp_data(:, 2:end) - temp_data(:, 1:end-1);


%%%%%%%%%%%%%
% Mask stuff
%%%%%%%%%%%%%


limits = cell2mat(axisSettings(1:2, 2:3));
num_layers = evalin('base', 'length(strati_data) + 1');
masks = cell(1,num_layers);

use_masks = evalin('base', 'use_masks');

if use_masks
    files = {'7_PA', '6_SA', '5_UBA', '4_LBA', '3_UKA', '2_LKA', '1_EO', '0_basement'};
    for i = 1:num_layers
        im_mask = imrotate(imread(['mask\' files{1,i} '.jpg']),-90);
        im_mask = imresize(im_mask, [(limits(1,2)/quadsize(1,1))+1 (limits(2,2)/quadsize(1,2))+1] ,'cubic');
        bw_mask = im2bw(im_mask, 0.8);
        nan_mask = ones(size(bw_mask));
        nan_mask(~bw_mask) = NaN;
        masks{1,i} = nan_mask;
    end
    assignin('base', 'distri_mask_data', masks);
end




cp_type = 'singl';
if (strcmp(cp_type, 'single'))
    single_data = data(:,4:end);
    single_data(:,1) = arrayfun(@nan2zero, single_data(:,1));
    for l = 2:size(plotSettings,1)
       %single_data(:,l) = single_data(:,l) - single_data(:,l-1);
       sublayer = ~isnan(ones(size(single_data,1),1));
       if l < size(plotSettings,1)
            sublayer = all(isnan(single_data(:,l+1:end)),2);
       end
       sum_dat = single_data(:,1:l-1);
        if size(sum_dat,2) > 1
            sum_dat = sum(sum_dat, 2);
        end
       single_data(:,l) = arrayfun(@nan2val, single_data(:,l), sum_dat, sublayer);
    end
    
    data(:,4:end) = single_data;
end


for layer = size(plotSettings,1):-1:1


    
limits = cell2mat(axisSettings(1:2, 2:3));
zlimit = [-axisSettings{3, 3} axisSettings{3, 2}];
linespec = ['-' fliplr(cell2mat(plotSettings(layer, 6:7))) ];
contourcolor = plotSettings{layer,9};
shading = 'none';
levels = axisSettings{3, 2}:-plotSettings{layer,10}:-axisSettings{3, 3};
aspectRatio = cell2mat(axisSettings(:, 5))';
color = plotSettings{layer,4};
climit = [-axisSettings{3, 3} 0];
plot = [plotSettings{layer,2} plotSettings{layer,5} plotSettings{layer,8}];
masks = evalin('base', 'distri_mask_data');

if (plot(1,1) || plot(1,2) || plot(1,3) || layer == find(ismember(layerNames,contSettings{1,2})))
    if(first_plot)
       first_plot = false; 
    else
        fig_title = [fig_title, ', '];
    end
    fig_title = [fig_title, layerNames{layer, 1}];
    
        if (get(handles.popup_plottype, 'Value') == 1)
            [surfaceX, surfaceY, surfaceZ] = getSurfaceData('distri', layer, plotSettings(layer,3), data(:,1), data(:,2), data(:,layer+3), limits, quadsize);
            [x, y, z] = getSurfaceData('distri', layer, 'none', data(:,1), data(:,2), data(:,layer+3), limits, quadsize);
            
        elseif (get(handles.popup_plottype, 'Value') == 2)
            [surfaceX, surfaceY, surfaceZ] = getSurfaceData('distri_iso', layer, plotSettings(layer,3), data(:,1), data(:,2), diff_data(:,layer), limits, quadsize);
            [x, y, z] = getSurfaceData('distri_iso', layer, 'none', data(:,1), data(:,2), diff_data(:,layer), limits, quadsize);
            %[~, ~, top_z] = getSurfaceData('distri', layer-1, plotSettings(layer-1,3), data(:,1), data(:,2), data(:,layer+2), limits, quadsize);
            %surfaceZ = arrayfun(@pos2zero, top_z) - arrayfun(@pos2zero, surfaceZ);
        elseif (get(handles.popup_plottype, 'Value') == 3)
            poro_data = evalin('base','poro_data');
            poro_data = cell2mat(cellfun(@empty2nan, poro_data, 'UniformOutput', false));

            poro_data = flipud(poro_data)';
            decomp_data = nan(size(data,1),1);

            for well = 1:size(data,1)
               decomp_data (well,1) = decompact(poro_data(1,layer), poro_data(2,layer), data(well,layer+3), data(well,layer+4), 0);
            end
            [surfaceX, surfaceY, surfaceZ] = getSurfaceData('distri_decomp_iso', layer, plotSettings(layer,3), data(:,1), data(:,2), decomp_data, limits, quadsize);
            [x, y, z] = getSurfaceData('distri_decomp_iso', layer, 'none', data(:,1), data(:,2), decomp_data, limits, quadsize);
            
            %[~, ~, top_z] = getSurfaceData('distri', layer-1, contSettings{1,3}, data(:,1), data(:,2), data(:,layer+2), limits, quadsize);
            %surfaceZ = arrayfun(@pos2zero, top_z)- arrayfun(@pos2zero, surfaceZ);
        elseif (get(handles.popup_plottype, 'Value') == 4)
            strati_data = evalin('base','strati_data');
            age_start = cell2mat(strati_data(:,2))';
            age_end = cell2mat(strati_data(:,3))';
            agediff = age_start - age_end;      
            
            if layer > size(agediff, 2)
                [surfaceX, surfaceY, surfaceZ] = getSurfaceData('distri_rate', layer, plotSettings(layer,3), data(:,1), data(:,2), diff_data(:,layer).*0, limits, quadsize);
                [x, y, z] = getSurfaceData('distri_rate', layer, 'none', data(:,1), data(:,2), diff_data(:,layer).*0, limits, quadsize);
                
            else
                [surfaceX, surfaceY, surfaceZ] = getSurfaceData('distri_rate', layer, plotSettings(layer,3), data(:,1), data(:,2), diff_data(:,layer)./agediff(1,layer), limits, quadsize);
                [x, y, z] = getSurfaceData('distri_rate', layer, 'none', data(:,1), data(:,2), diff_data(:,layer)./agediff(1,layer), limits, quadsize);
                
            end
        elseif (get(handles.popup_plottype, 'Value') == 5)
            strati_data = evalin('base','strati_data');
            age_start = cell2mat(strati_data(:,2))';
            age_end = cell2mat(strati_data(:,3))';
            agediff = age_start - age_end;      
            
            if layer > size(agediff, 2)
                [surfaceX, surfaceY, surfaceZ] = getSurfaceData('distri_rate', layer, plotSettings(layer,3), data(:,1), data(:,2), diff_data(:,layer).*0, limits, quadsize);
                [x, y, z] = getSurfaceData('distri_rate', layer, 'none', data(:,1), data(:,2), diff_data(:,layer).*0, limits, quadsize);
                
            else
                poro_data = evalin('base','poro_data');
                poro_data = cell2mat(cellfun(@empty2nan, poro_data, 'UniformOutput', false));

                poro_data = flipud(poro_data)';
                decomp_data = nan(size(data,1),1);

                for well = 1:size(data,1)
                   decomp_data (well,1) = decompact(poro_data(1,layer), poro_data(2,layer), data(well,layer+3), data(well,layer+4), 0);
                end
                [surfaceX, surfaceY, surfaceZ] = getSurfaceData('distri_decomp_iso', layer, plotSettings(layer,3), data(:,1), data(:,2), decomp_data./agediff(1,layer), limits, quadsize);
                [x, y, z] = getSurfaceData('distri_decomp_iso', layer, 'none', data(:,1), data(:,2), decomp_data./agediff(1,layer), limits, quadsize);
                %[~, ~, top_z] = getSurfaceData('distri', layer-1, contSettings{1,3}, data(:,1), data(:,2), data(:,layer+2), limits, quadsize);
                %surfaceZ = arrayfun(@pos2zero, top_z)- arrayfun(@pos2zero, surfaceZ);
            end
        end
    
end

if plot(1,2)
%      if (strcmp(cp_type, 'single'))
%         sum_data = data(:,4:layer+3);
%         if size(sum_data,2) > 1
%             sum_data = sum(sum_data, 2);
%         end
%         [x, y, z] = getSurfaceData('distri_s', layer, 'none', data(:,1), data(:,2), sum_data, limits, quadsize);
%         if (layer > 1 && get(handles.popup_plottype, 'Value') == 2)
%             [x, y, z] = getSurfaceData('distri_s_iso', layer, 'none', data(:,1), data(:,2), data(:,layer+3), limits, quadsize);
%         end
%      else
%     [x, y, z] = getSurfaceData('distri', layer, 'none', data(:,1), data(:,2), data(:,layer+3), limits, quadsize);
%     if (get(handles.popup_plottype, 'Value') == 2)
%         [x, y, z] = getSurfaceData('distri_iso', layer, 'none', data(:,1), data(:,2), diff_data(:,layer), limits, quadsize);
%         %[~, ~, top_z] = getSurfaceData('distri', layer-1, 'none', data(:,1), data(:,2), data(:,layer+2), limits, quadsize);
%         %z = arrayfun(@pos2zero, top_z) - arrayfun(@pos2zero, z);
%     end
     %end
    x = x';
    y = y';
    z = z';
    plotq = quiver3(x,y,zeros(1,size(x,2)),zeros(1,size(x,2)),zeros(1,size(x,2)),z,0,linespec,'markersize',20,'linewidth',1.0,'marker','.');
end

if plot(1,1)
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
    
    
%    end
    surfaceZfin = surfaceZ;
    if use_masks
        surfaceZfin = surfaceZfin .* masks{1,layer};
    end
    
    plots = surf(surfaceX, surfaceY, surfaceZfin, 'FaceColor', 'interp' ...
                                      , 'FaceLighting', shading ...
                                      , 'LineStyle',    'none' ...
                                  ,'SpecularColorReflectance', 0 ...  
                              );
    colormap(color);
end


if plot(1,3)
%     if (strcmp(cp_type, 'single'))
%         [surfaceX, surfaceY, surfaceZ] = getSurfaceData('distri_s', layer, plotSettings(layer,3), data(:,1), data(:,2), data(:,layer+3), limits, quadsize);
%         if ~(get(handles.popup_plottype, 'Value') == 2)
%             surfaceZ = zeros(size(surfaceZ,1), size(surfaceZ,2));
%             for l = 1:layer
%                 %[surfaceX, surfaceY, surfaceZ] = getSurfaceData('distri_iso', layer-1, plotSettings(layer-1,3), data(:,1), data(:,2), diff_data(:,layer-1), limits, quadsize);
%                 [~, ~, surfaceZ2] = getSurfaceData('distri_s', l, plotSettings(layer,3), data(:,1), data(:,2), data(:,l+3), limits, quadsize);
%                 surfaceZ = surfaceZ + arrayfun(@pos2zero, surfaceZ2);
%             end
%         end
%     else
%         [surfaceX, surfaceY, surfaceZ] = getSurfaceData('distri', layer, plotSettings(layer,3), data(:,1), data(:,2), data(:,layer+3), limits, quadsize);
%         
%         if (get(handles.popup_plottype, 'Value') == 2)
%             [surfaceX, surfaceY, surfaceZ] = getSurfaceData('distri_iso', layer, plotSettings(layer,3), data(:,1), data(:,2), diff_data(:,layer), limits, quadsize);
%             %[~, ~, top_z] = getSurfaceData('distri', layer-1, plotSettings(layer-1,3), data(:,1), data(:,2), data(:,layer+2), limits, quadsize);
%             %surfaceZ = arrayfun(@pos2zero, top_z) - arrayfun(@pos2zero, surfaceZ);
%         end
%         
%          if (get(handles.popup_plottype, 'Value') == 3)
%             poro_data = evalin('base','poro_data');
%             poro_data = cell2mat(cellfun(@empty2nan, poro_data, 'UniformOutput', false));
% 
%             poro_data = flipud(poro_data)';
%             decomp_data = nan(size(data,1),1);
% 
%             for well = 1:size(data,1)
%                decomp_data (well,1) = decompact(poro_data(1,layer), poro_data(2,layer), data(well,layer+3), data(well,layer+4), 0);
%             end
%             [surfaceX, surfaceY, surfaceZ] = getSurfaceData('distri_decomp_iso', layer, plotSettings(layer,3), data(:,1), data(:,2), decomp_data, limits, quadsize);
%             %[~, ~, top_z] = getSurfaceData('distri', layer-1, contSettings{1,3}, data(:,1), data(:,2), data(:,layer+2), limits, quadsize);
%             %surfaceZ = arrayfun(@pos2zero, top_z)- arrayfun(@pos2zero, surfaceZ);
%         end
%         if (get(handles.popup_plottype, 'Value') == 4)
%             strati_data = evalin('base','strati_data');
%             age_start = cell2mat(strati_data(:,2))';
%             age_end = cell2mat(strati_data(:,3))';
%             agediff = age_start - age_end;      
%             
%             if layer > size(agediff, 2)
%                 [surfaceX, surfaceY, surfaceZ] = getSurfaceData('distri_rate', layer, plotSettings(layer,3), data(:,1), data(:,2), diff_data(:,layer).*0, limits, quadsize);
%             else
%                 [surfaceX, surfaceY, surfaceZ] = getSurfaceData('distri_rate', layer, plotSettings(layer,3), data(:,1), data(:,2), diff_data(:,layer)./agediff(1,layer), limits, quadsize);
%             end
%         end
%         if (get(handles.popup_plottype, 'Value') == 5)
%             strati_data = evalin('base','strati_data');
%             age_start = cell2mat(strati_data(:,2))';
%             age_end = cell2mat(strati_data(:,3))';
%             agediff = age_start - age_end;      
%             
%             if layer > size(agediff, 2)
%                 [surfaceX, surfaceY, surfaceZ] = getSurfaceData('distri_rate', layer, plotSettings(layer,3), data(:,1), data(:,2), diff_data(:,layer).*0, limits, quadsize);
%             else
%                 poro_data = evalin('base','poro_data');
%                 poro_data = cell2mat(cellfun(@empty2nan, poro_data, 'UniformOutput', false));
% 
%                 poro_data = flipud(poro_data)';
%                 decomp_data = nan(size(data,1),1);
% 
%                 for well = 1:size(data,1)
%                    decomp_data (well,1) = decompact(poro_data(1,layer), poro_data(2,layer), data(well,layer+3), data(well,layer+4), 0);
%                 end
%                 [surfaceX, surfaceY, surfaceZ] = getSurfaceData('distri_decomp_iso', layer, contSettings{1,3}, data(:,1), data(:,2), decomp_data./agediff(1,layer), limits, quadsize);
%                 %[~, ~, top_z] = getSurfaceData('distri', layer-1, contSettings{1,3}, data(:,1), data(:,2), data(:,layer+2), limits, quadsize);
%                 %surfaceZ = arrayfun(@pos2zero, top_z)- arrayfun(@pos2zero, surfaceZ);
%             end
%         end
%         
%    end
    surfaceZfin = surfaceZ;
    if use_masks
        surfaceZfin = surfaceZfin .* masks{1,layer};
    end
    plotc = contour3(surfaceX, surfaceY, surfaceZfin, levels, contourcolor); % contourplot color 'w' - white 'k' - black
end


set(fig,'Color','white'); %figure background color

set(gca,'DataAspectRatio', aspectRatio); %[1 1 1]);
set(gca,'XLim', (limits(1,:)));
set(gca,'YLim', (limits(2,:)));
set(gca,'ZLim', zlimit);

set(gca,'Color', 'white', 'XColor', 'black', 'YColor', 'black', 'ZColor', 'black'); %axis and axisbackground color
end

if ~strcmp(contSettings{1,1}, 'none')
    layerNames = get(handles.tab_mapping, 'RowName');
    layer = find(ismember(layerNames,contSettings{1,2}));
    
    if (strcmp(cp_type, 'single'))
        [surfaceX, surfaceY, surfaceZ] = getSurfaceData('distri_s', layer, contSettings{1,3}, data(:,1), data(:,2), data(:,layer+3), limits, quadsize);
        if ~(strcmp(contSettings{1,1}, 'Isopach'))
            surfaceZ = zeros(size(surfaceZ,1), size(surfaceZ,2));
            for l = 1:layer
                [~, ~, surfaceZ2] = getSurfaceData('distri_s', l, contSettings{1,3}, data(:,1), data(:,2), data(:,l+3), limits, quadsize);
                surfaceZ = surfaceZ + arrayfun(@pos2zero, surfaceZ2);
            end
        end
    else
        if (strcmp(contSettings{1,1}, 'Depth'))
            [surfaceX, surfaceY, surfaceZ] = getSurfaceData('distri', layer, contSettings{1,3}, data(:,1), data(:,2), data(:,layer+3), limits, quadsize);
        end
        if (strcmp(contSettings{1,1}, 'Isopach'))
            [surfaceX, surfaceY, surfaceZ] = getSurfaceData('distri_iso', layer, contSettings{1,3}, data(:,1), data(:,2), diff_data(:,layer), limits, quadsize);
            %[~, ~, top_z] = getSurfaceData('distri', layer-1, contSettings{1,3}, data(:,1), data(:,2), data(:,layer+2), limits, quadsize);
            %surfaceZ = arrayfun(@pos2zero, top_z)- arrayfun(@pos2zero, surfaceZ);
        end
        if (strcmp(contSettings{1,1}, 'Decomp. Isopach'))
            poro_data = evalin('base','poro_data');
            poro_data = cell2mat(cellfun(@empty2nan, poro_data, 'UniformOutput', false));

            poro_data = flipud(poro_data)';
            decomp_data = nan(size(data,1),1);

            for well = 1:size(data,1)
               decomp_data (well,1) = decompact(poro_data(1,layer), poro_data(2,layer), data(well,layer+3), data(well,layer+4), 0);
            end
            [surfaceX, surfaceY, surfaceZ] = getSurfaceData('distri_decomp_iso', layer, contSettings{1,3}, data(:,1), data(:,2), decomp_data, limits, quadsize);
            %[~, ~, top_z] = getSurfaceData('distri', layer-1, contSettings{1,3}, data(:,1), data(:,2), data(:,layer+2), limits, quadsize);
            %surfaceZ = arrayfun(@pos2zero, top_z)- arrayfun(@pos2zero, surfaceZ);
        end
        if (strcmp(contSettings{1,1}, 'Rate'))
            strati_data = evalin('base','strati_data');
            age_start = cell2mat(strati_data(:,2))';
            age_end = cell2mat(strati_data(:,3))';
            agediff = age_start - age_end;      
            
            if layer > size(agediff, 2)
                [surfaceX, surfaceY, surfaceZ] = getSurfaceData('distri_rate', layer, contSettings{1,3}, data(:,1), data(:,2), diff_data(:,layer).*0, limits, quadsize);
            else
                [surfaceX, surfaceY, surfaceZ] = getSurfaceData('distri_rate', layer, contSettings{1,3}, data(:,1), data(:,2), diff_data(:,layer)./agediff(1,layer), limits, quadsize);
            end
        end
        if (strcmp(contSettings{1,1}, 'Decomp. Rate'))
            strati_data = evalin('base','strati_data');
            age_start = cell2mat(strati_data(:,2))';
            age_end = cell2mat(strati_data(:,3))';
            agediff = age_start - age_end;      
            
            if layer > size(agediff, 2)
                [surfaceX, surfaceY, surfaceZ] = getSurfaceData('distri_rate', layer, contSettings{1,3}, data(:,1), data(:,2), diff_data(:,layer).*0, limits, quadsize);
            else
                poro_data = evalin('base','poro_data');
                poro_data = cell2mat(cellfun(@empty2nan, poro_data, 'UniformOutput', false));

                poro_data = flipud(poro_data)';
                decomp_data = nan(size(data,1),1);

                for well = 1:size(data,1)
                   decomp_data (well,1) = decompact(poro_data(1,layer), poro_data(2,layer), data(well,layer+3), data(well,layer+4), 0);
                end
                [surfaceX, surfaceY, surfaceZ] = getSurfaceData('distri_decomp_iso', layer, contSettings{1,3}, data(:,1), data(:,2), decomp_data./agediff(1,layer), limits, quadsize);
                %[~, ~, top_z] = getSurfaceData('distri', layer-1, contSettings{1,3}, data(:,1), data(:,2), data(:,layer+2), limits, quadsize);
                %surfaceZ = arrayfun(@pos2zero, top_z)- arrayfun(@pos2zero, surfaceZ);
            end
        end
    end
    
    
    %[x, y, z] = getSurfaceData('distri', layer, 'none', data(:,1), data(:,2), data(:,layer+3), limits, quadsize);
    
    levels2 = axisSettings{3, 2}:-contSettings{1,5}:min(min(surfaceZ));
    slice_offset = contSettings{1,7};%10; %2.5 *2.5;
    
    if use_masks
        surfaceZ = surfaceZ .* masks{1,layer};
    end
    surfaceX = repmat(surfaceX', [1 1 2]);
    surfaceY = repmat(surfaceY', [1 1 2]);
    surfaceV = repmat(surfaceZ', [1 1 2]);
    assignin('base','surfaceV', surfaceV);
    %[plotcont, h] = contourf(surfaceX, surfaceY, surfaceZ, levels, contourcolor);
    surfaceZ = zeros(size(surfaceX, 1), size(surfaceX, 2), 2);
    
    zticks = get(gca,'ZTick');
    set(gca,'ZTick', zticks);
    
    surfaceZ(:,:,1) = -axisSettings{3,3}-slice_offset;
    surfaceZ(:,:,2) = -axisSettings{3,3}-slice_offset-1;
    
    if (~strcmp(contSettings{1,6}, 'none'))
        h = slice(surfaceX, surfaceY, surfaceZ, surfaceV, [], [], -axisSettings{3,3}-slice_offset);
        set(h, 'FaceColor', contSettings{1,6});%'interp';
        set(h, 'EdgeColor', 'none');
        %colormap(contSettings{1,6});
    end
    if (~strcmp(contSettings{1,4}, 'none'))
        h = contourslice(surfaceX, surfaceY, surfaceZ, surfaceV, [], [], -axisSettings{3,3}-slice_offset, levels2);
        set(h, 'EdgeColor', contSettings{1,4});
    end
    
    set(gca,'ZLim', zlimit - [slice_offset 0]);
end

fig_title(1, end + 1) = ')';
set(gcf,'name', fig_title,'numbertitle','off')

set(gca,'CLim', climit);

xlabel('X [m]');
ylabel('Y [m]');
zlabel('Depth [m]');


%set(gca,'ZTick', [-6000 -4000 -2000 0]);
ax = gca;
%% TODO: fix exponent in Matlab2015a
%ax.XAxis.Exponent = 0;
%ax.YAxis.Exponent = 0;
%ax.ZAxis.Exponent = 0;
set(gca,'Box','on','XGrid', 'on', 'YGrid', 'on', 'ZGrid', 'on');

view(-48,35);
%view(0,90);
fontsize = 10;
set(gca, 'FontSize', fontsize);
%colorbar;

ztype = {'Depth: ', 'Depth: ', 'm', 'm'};
if(get(handles.popup_plottype, 'Value') == 2)
    ztype{1,1} = 'Thickness: ';
end
if(strcmp(contSettings{1,1}, 'Isopach') || strcmp(contSettings{1,1}, 'Decomp. Isopach'))
    ztype{1,2} = 'Thickness: ';
end
if(strcmp(contSettings{1,1}, 'Rate') || strcmp(contSettings{1,1}, 'Decomp. Rate'))
    ztype{1,2} = 'Rate: ';
    ztype{1,4} = 'm/Ma';
end
set(gca, 'UserData', ztype);

dcm_obj = datacursormode(fig);
set(dcm_obj, 'UpdateFcn', @datatip);

hold off;


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
    data = evalin('base', 'plot_data');
catch ex
    data = {};
end

strati_data = evalin('base', 'strati_data');
if size(data,1) ~= size(strati_data,1)
    data = cell(size(strati_data,1),4);
    data(:,1) = strati_data(:,1);
    data{size(data,1)+1, 1} = 'Basement';
    assignin('base', 'distri_plot_data', data);
end

rowHeaders = strati_data(:,1);
rowHeaders{size(rowHeaders, 1)+1, 1} = 'BA';

cmaps = {'Jet' 'HSV' 'Hot' 'Cool' 'Spring' 'Summer' 'Autumn' 'Winter' 'Gray' 'Bone' 'Copper' 'Pink' 'Lines'};
interpols = {'linear', 'natural', 'cubic', 'TPS', 'kriging'};
colors = {'r' 'g' 'b' 'c' 'm' 'y' 'k' 'w'};
symbols = {'+' 'o' '*' '.' 'x' 's' 'd' '^' 'v' '>' '<' 'p' 'h'};
lines = {'-' '--' ':' '-.'};

for i = 1:size(data,1);
    data{i,2} = false;
    data{i,3} = 'TPS';
    data{i,4} = 'Jet'; %getDefChoice(i,colors);
    data{i,5} = false;
    data{i,6} = getDefChoice(i,symbols);
    data{i,7} = getDefChoice(i+1,colors);
    data{i,8} = false;
    data{i,9} = 'k';
    data{i,10} = 500;
end

set(hObject, ...
    'ColumnName', {'<html><center>Unit<br />Name</center></html>'; 'Surface'; '<html><center>Inter-<br />polation</center></html>';'<html><center>Surface<br />Colormap</center></html>'; '<html><center>Well<br />Location</center></html>'; '<html><center>Well<br />Symbol</center></html>'; '<html><center>Well<br />Color</center></html>'; 'Contours'; '<html><center>Contour<br />Color</center></html>'; '<html><center>Contour<br />Interval [m]</center></html>' }, ...
    'ColumnFormat', {'char' 'logical' interpols cmaps 'logical' symbols colors 'logical' colors 'numeric'}, ...
    'ColumnWidth', {70 60 70 70 60 50 50 60 50 75}, ...
    'RowName',rowHeaders, ...
    'ColumnEditable', [true true true true true true true true true true true true], ...
    'Data', data);

assignin('base', 'tab', get(hObject, 'Data'));
%  'ColumnEditable', {1 1 1 1 1 1 1}, ...
% '-' '--' ':' '-.'
% '+' 'o' '*' '.' 'x' 's' 'd' '^' 'v' '>' '<' 'p' 'h'
% 'r' 'g' 'b' 'c' 'm' 'y' 'k' 'w'
% 'Jet' 'HSV' 'Hot' 'Cool' 'Spring' 'Summer' 'Autumn' 'Winter' 'Gray'
% 'Bone' 'Copper' 'Pink' 'Lines'

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
data(3,:) = {'Z' 0 evalin('base', 'area_z_dim') 'km' 0.25 ''};

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


% --- Executes during object creation, after setting all properties.
function uitable3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uitable3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


try
    cont_data = evalin('base', 'distri_cont_data');
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
types = {'none', 'Depth', 'Isopach', 'Decomp. Isopach', 'Rate', 'Decomp. Rate'};
strati_data = evalin('base', 'strati_data');

rowHeaders = strati_data(:,1);
rowHeaders{size(rowHeaders, 1)+1, 1} = 'BA';
rowHeaders = rowHeaders';


cont_data{1,1} = 'Depth';
cont_data{1,2} = strati_data{1,1};
cont_data{1,3} = 'TPS';
cont_data{1,4} = 'k';
cont_data{1,5} = 500;
cont_data{1,6} = 'none';
cont_data{1,7} = 10000;


set(hObject, ...
   'ColumnName', {'<html><center>Type</center></html>'; 'Unit'; 'Interpolation';'<html><center>Contour Color</center></html>'; '<html><center>Contour Interval</html>' ; 'Color'; 'Offset'}, ...
   'ColumnFormat', {types rowHeaders interpols none_colors 'numeric' none_colors}, ...
   'ColumnWidth', {95 95 95 95 115 95 95}, ...
   'ColumnEditable', [true true true true true true true], ...
   'Data', cont_data ...
);

assignin('base', 'distri_cont_data', get(hObject, 'Data'));


function out = empty2nan(in)
if isempty(in)
    out = nan;
else
    out = in;
end
