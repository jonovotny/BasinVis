function varargout = subwindow(varargin)
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
setupWsVar('sub_well_ids',{});
% Last Modified by GUIDE v2.5 24-Dec-2018 23:31:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @subwindow_OpeningFcn, ...
                   'gui_OutputFcn',  @subwindow_OutputFcn, ...
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
function subwindow_OpeningFcn(hObject, eventdata, handles, varargin)
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
function varargout = subwindow_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
backstrip(hObject, eventdata, handles);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function uitable1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uitable2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% data = evalin('base', 'sub_data');
colergen = @(color,text) ['<html><table border=0 width=400 bgcolor=',color,'><TR><TD>',text,'</TD></TR> </table></html>'];

strati_data = evalin('base', 'strati_data');

headers = cell(1,size(strati_data,1));
widths = cell(1,size(strati_data,1));
for i = 1:size(strati_data,1)
    top_age = num2str(strati_data{i,3});
    
    head = strcat('<html><center>',top_age,'<br />Ma</center></html>');
    assignin('base', 'top', top_age);
    headers{1,i} = head;
    widths(1,i) = {70};
end
       
set(hObject, 'ColumnName', headers);
set(hObject, 'ColumnWidth', widths);

poro_data = evalin('base', 'poro_data');

rowHeaders = strati_data(:,1);


rowHeaders(size(rowHeaders, 1)+1:size(rowHeaders, 1)+5, 1) = {' '; 'Total Sub';'Total Sub Rate'; 'Tect Sub';'Tect Sub Rate' };
set(hObject, 'RowName', {});
set(hObject, 'RowName', rowHeaders);

sub_data = cell(size(poro_data,1), size(poro_data,1));
%sub_data(:,1:2) = poro_data(:,2:3);
assignin('base', 'sub_data', sub_data);
set(hObject, 'Data', sub_data);





function backstrip(hObject, eventdata, handles)

well_id2 = get(handles.popup_well, 'Value');
%Remove later
sub_well_ids = evalin('base', 'sub_well_ids');
well_id = sub_well_ids(well_id2, 1);
%

backstrip = getBackstrippingData(well_id, true);

well_data = evalin('base',['well_data(' num2str(well_id) ',:)']);

set(handles.label_position, 'String', ['X: ' num2str(well_data{1,2}) '  Y: ' num2str(well_data{1,3})]);

poro_data = evalin('base','poro_data');
if evalin('base', ['well_custom_params(' num2str(well_id) ',1)'])
    poro_data = evalin('base', ['well_params{' num2str(well_id) ',1}']);
end
poro_data = flipud(poro_data);
num_layers = size(poro_data,1);
decomp_data = cell(1,(sum(1:num_layers)+(num_layers*4)));

tops = well_data(1,6:size(well_data,2));
bottoms = well_data(1,5:size(well_data,2)-1);

for i = 1:size(tops,2)-1
    if isempty(tops{1,i}) && ~isempty(bottoms{1,i})
        bottoms{1,i+1} = bottoms{1,i};
        bottoms{1,i} = [];
    end
end

assignin('base','test',tops)

write_to = 1;
dens_water = 1025;
dens_grain = 2847;
dens_mantle = 3300;

strati_data = evalin('base', 'strati_data');
age_diff = cell2mat(strati_data(:,2)) - cell2mat(strati_data(:,3));
age_diff = flipud(age_diff)';

previous_basement = 0;
previous_tectonic = 0;

for i = 1:size(tops,2)
    last_depth = 0;
    
    dens_column = 0;
    had_layers = 0;
    for j = i:-1:1
        if ~isempty(tops{1,j}) && ~isempty(bottoms{1,j})
            if tops{1,j} ~= bottoms{1,j}
                thickness = decompact(poro_data{j,1}, poro_data{j,2}, tops{1,j}, bottoms{1,j}, last_depth);
                density = layer_density(last_depth, thickness, poro_data{j,1}, poro_data{j,2}, dens_water, poro_data{j,5});
            else
                thickness = 0;
                density = 0;
            end
            
            dens_column = dens_column + density;
            last_depth = last_depth + thickness;
            decomp_data{1,write_to} = last_depth;
            had_layers = 1;
        end
        write_to = write_to + 1;
      
    end
    
    if had_layers == 1 && ~isempty(tops{1,i}) && ~isempty(bottoms{1,i})
        if last_depth == 0
            dens_column = 0;
        else
            dens_column = dens_column/last_depth;
        end
        decomp_data{1,write_to} = dens_column;
        write_to = write_to + 1;
        basement_sub_rate = (last_depth - previous_basement)/age_diff(1,i);
        decomp_data{1,write_to} = basement_sub_rate;
        write_to = write_to + 1;
        
        tectonic_sub = (((dens_mantle - dens_column)/(dens_mantle - dens_water))*last_depth)+poro_data{i,3}-(poro_data{i,4}*(dens_mantle/(dens_mantle - dens_water)));
        decomp_data{1,write_to} = tectonic_sub;
        write_to = write_to + 1;
        
        tectonic_sub_rate = (tectonic_sub - previous_tectonic)/age_diff(1,i);
        decomp_data{1,write_to} = tectonic_sub_rate;
        write_to = write_to + 1;
        
        previous_basement = last_depth;
        previous_tectonic = tectonic_sub;
    else
        if (isempty(tops{1,i}) || isempty(bottoms{1,i})) && i > 1
            decomp_data{1,write_to} = decomp_data{1,write_to-(4+i)};
            write_to = write_to + 1;
            decomp_data{1,write_to} = 0;
            write_to = write_to + 1;
            decomp_data{1,write_to} = decomp_data{1,write_to-(4+i)};
            write_to = write_to + 1;
            decomp_data{1,write_to} = 0;
            write_to = write_to + 1;
        else
            write_to = write_to + 4;
        end
    end
    
end

decomp = cell(num_layers);
sub_block = cell(4,num_layers);

read_pos = 1; 
for i = 1:num_layers
    j = num_layers - i + 1;
    decomp(1:i, num_layers-i+1) = decomp_data(1,read_pos:read_pos+i-1);
    sub_block(1,j) = decomp_data(1,read_pos+i-1);
    sub_block(2:4,j) = decomp_data(1,read_pos+i+1:read_pos+i+3)';
    read_pos = read_pos + i + 4;
end

for i = 1:num_layers
    if decomp{i,1} == 0
        sub_block(1:end, i) = {[];[];[];[]};
    end
end


assignin('base','decomp_data',decomp_data);
sub_data = evalin('base', 'sub_data');

sub_data(1:num_layers,1:num_layers) = decomp;
sub_data(num_layers+2:num_layers+5,1:num_layers) = sub_block;

% new subdata
sub_data(1:num_layers,1:num_layers) = backstrip{5};
sub_data(num_layers+2,1:num_layers) = backstrip{1};
sub_data(num_layers+3,1:num_layers) = backstrip{2};
sub_data(num_layers+4,1:num_layers) = cellfun(@filterCells2, backstrip{3}, 'UniformOutput', false);
sub_data(num_layers+5,1:num_layers) = cellfun(@filterCells2, backstrip{4}, 'UniformOutput', false);



assignin('base', 'sub_data', sub_data);

reload(hObject, eventdata, handles);

well_name = cell2mat(evalin('base', ['well_data(' num2str(well_id) ',1)']));

strati_data = evalin('base','strati_data');
ages = cell2mat(strati_data(:,3))';
ages = [ages strati_data{end,2}];

sub_block2 = zeros(4, size(ages, 2));
sub_block2(:, 1:end-1) = cell2mat(cellfun(@filterCells, sub_block, 'UniformOutput', false));
figure;
hold on;
wdepths = cell2mat(poro_data(:,3));
b = bar(fliplr(ages), [0 wdepths'], 'histc');
plots = get(gca, 'Children');
delete(plots(1));
set(b, 'LineStyle', 'none');
set(b, 'FaceColor', [135/255 206/255 250/255])

bsdata = [cell2mat(backstrip{1}) 0];
bsdata(2, :) = [cell2mat(backstrip{3}) 0];
if (isprop(gca,'ColorOrderIndex')) %Matlab2014a workaround
    set(gca,'ColorOrderIndex',1);
end
plot(ages, bsdata);
eros = cell2mat(poro_data(:,6))';
hasErosion = (sum(abs(eros)) ~= 0);
eros = repmat([0 fliplr(eros)], 2, 1);

if (hasErosion)
    if (isprop(gca,'ColorOrderIndex')) %Matlab2014a 
        set(gca,'ColorOrderIndex',1);
    end
    plot(ages, bsdata + eros, '--');
end



set(gca,'XDir', 'reverse');
set(gca,'YDir', 'reverse');
xlabel('Geologic Age (Ma)');
ylabel('Depth (m)');
legend('Water Depth', 'Total Subsidence', 'Tectonic Subsidence');

set(gcf,'name', ['Subsidence (' well_name ')'],'numbertitle','off');
xlimits = xlim;
hold off;

midages = ages - [0 ages(:, 1:end-1)];
midages = midages/2;
midages = midages + [midages(1,1) ages(:, 1:end-1)];
midages = [midages strati_data{end,2}];

erosrates = fliplr(cell2mat(poro_data(:,6))');
erosrates = [0 erosrates] - [erosrates 0];
erosrates = erosrates(1:end-1)./ages(2:end);
erosrates = repmat([0 erosrates 0], 2, 1);

bsdata = [cell2mat(backstrip{2}) 0];
bsdata(2, :) = [cell2mat(backstrip{4}) 0];

first_val = 1;
for i = 1:num_layers
    if decomp{i,1} == 0
        first_val = i+1; 
    else
        break
    end
end

% if first_val ~= 1
%     midages(1,first_val) = strati_data{first_val-1,2};
%     sub_block2(2, first_val-1) = 0;
%     sub_block2(4, first_val-1) = 0;
% end

figure;
hold on;
if (isprop(gca,'ColorOrderIndex')) %Matlab2014a 
    set(gca,'ColorOrderIndex',1);
end
plot(midages, [[0; 0] bsdata]);
if (hasErosion)
    if (isprop(gca,'ColorOrderIndex')) %Matlab2014a 
        set(gca,'ColorOrderIndex',1);
    end
    plot(midages, [[0; 0] bsdata]+erosrates, '--');
end
xline = plot(xlimits,[0 0],'k');
xline.Color(4) = 0.25;

set(gca,'XDir', 'reverse');
xlabel('Geologic Age (Ma)');
ylabel('Rate (m/Ma)');
legend('Rate Total Sub', 'Rate Tectonic Sub');
set(gcf,'name', ['Subsidence Rates (' well_name ')'],'numbertitle','off')
hold off;


function reload(hObject, eventdata, handles)

data = evalin('base', 'sub_data');
%colors = {'#FFF0F5' '#DCDCDC' '#DDA0DD' '#AFEEEE' '#FFA07A' '#FFF0F5' '#DCDCDC'};
colors = {'#EC5f67' '#F99157' '#FAC863' '#99C794' '#5FB3B3' '#6699CC' '#C594C5'};% '#AB7967'};

for i = 1:size(data, 2)
   for j = 1:size(data, 2)+1-i
      data(i,j) = {colergen(getDefChoice((i+j-1), colors),data{i,j})};
   end
end

set(handles.uitable1, 'Data', data);


function [string] = colergen (color,text) 
text = num2str(text);
string = ['<html><table border=0 width=400 bgcolor=',color,'><TR><TD>',text,'</TD></TR> </table></html>'];
    
function [value] = getDefChoice(index, values)
if index > size(values,2)
   index = mod(index-1, size(values,2))+1;  
end
value = values{1,index};

% --- Executes on selection change in popup_well.
function popup_well_Callback(hObject, eventdata, handles)
% hObject    handle to popup_well (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_well contents as cell array
%        contents{get(hObject,'Value')} returns selected item from
%        popup_well
backstrip(hObject, eventdata, handles);



% --- Executes during object creation, after setting all properties.
function popup_well_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_well (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
well_ids = evalin('base', 'well_data(:,1)');

%
well_names = evalin('base', 'well_data(:,1)');
well_data = evalin('base', 'well_data(:, 5:end)');
well_data = cell2mat(cellfun(@filterCells, well_data, 'UniformOutput', false));
%well_data = sum(well_data, 2);
well_names = well_names(find(~isnan(well_data(:,1))));
well_ids = find(~isnan(well_data(:,1)));

assignin('base', 'sub_well_ids', well_ids);
set(hObject, 'String', well_names);
%

% Change to all well ids
%set(hObject, 'String', well_ids);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
backstrip(hObject, eventdata, handles);

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
backstrip(hObject, eventdata, handles);

% --- Executes on button press in button_dipslip.
function button_dipslip_Callback(hObject, eventdata, handles)
% hObject    handle to button_dipslip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dipslipwindow;


function out = filterCells(in)
    if ~isempty(in)
        out = in;
    else
        out = NaN;
    end

function out = filterCells2(in)
    if ~isnan(in)
        out = in;
    else
        out = [];
    end
