function varargout = settingwindow(varargin)
% settingWINDOW MATLAB code for settingwindow.fig
%      settingWINDOW, by itself, creates a new settingWINDOW or raises the existing
%      singleton*.
%
%      H = settingWINDOW returns the handle to a new settingWINDOW or the handle to
%      the existing singleton*.
%
%      settingWINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in settingWINDOW.M with the given input arguments.
%
%      settingWINDOW('Property','Value',...) creates a new settingWINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before settingwindow_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to settingwindow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help settingwindow

% Last Modified by GUIDE v2.5 22-Mar-2015 18:23:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @settingwindow_OpeningFcn, ...
                   'gui_OutputFcn',  @settingwindow_OutputFcn, ...
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

% --- Executes just before settingwindow is made visible.
function settingwindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to settingwindow (see VARARGIN)

% Choose default command line output for settingwindow
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using settingwindow.

% UIWAIT makes settingwindow wait for user response (see UIRESUME)
% uiwait(handles.figure1);
update_plots(handles);


% --- Outputs from this function are returned to the command line.
function varargout = settingwindow_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;





% --- Executes on selection change in popup_well1.
function popup_well1_Callback(hObject, eventdata, handles)
% hObject    handle to popup_well1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popup_well1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_well1
% update_markers(handles);
update_plots(handles);

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




function update_plots(handles)

well_data = evalin('base', ['well_data(' num2str(get(handles.popup_well1, 'Value')) ', 5:end)']);
well_data = fliplr(cell2mat(cellfun(@empty2nan, well_data, 'UniformOutput', false)));

strati_data = evalin('base','strati_data');
ages = cell2mat(strati_data(:,3))';

age_start = cell2mat(strati_data(:,2))';
age_end = cell2mat(strati_data(:,3))';
age_plot = [age_end(1) age_start]
agediff = age_start - age_end;

axes(handles.axes1);
plot(age_plot,well_data, '.-');
set(gca,'Ydir','reverse');
ylabel('Depth [m]');
xlabel('Age [Ma]');


thickness = well_data(2:end)-well_data(1:end-1);
thickness_stairs = reshape(repmat(thickness,2,1),1,[]);
depth_stairs = reshape(repmat(well_data,2,1),1,[]);

axes(handles.axes2);
plot(thickness_stairs,depth_stairs(2:end-1), '.-');
set(gca,'Ydir','reverse');
ylabel('Depth [m]');
xlabel('Thickness [m]');
xlim([0 max(thickness_stairs)*1.05]);


sed_rate = thickness./agediff;
sed_rate_stairs = reshape(repmat(sed_rate,2,1),1,[]);
axes(handles.axes3);
plot(sed_rate_stairs,depth_stairs(2:end-1), '.-');
set(gca,'Ydir','reverse');
ylabel('Depth [m]');
xlabel('Sed. Rate [m/Ma]');
xlim([0 max(sed_rate_stairs)*1.05]);

age_stairs = [age_end(1) reshape(repmat(age_start,2,1),1,[])];
axes(handles.axes4);
plot(thickness_stairs,age_stairs(1:end-1), '.-');
set(gca,'Ydir','reverse');
ylabel('Age [Ma]');
xlabel('Thickness [m]');
xlim([0 max(thickness_stairs)*1.05]);

axes(handles.axes5);
plot(sed_rate_stairs,age_stairs(1:end-1), '.-');
set(gca,'Ydir','reverse');
ylabel('Age [Ma]');
xlabel('Sed. Rate [m/Ma]');
xlim([0 max(sed_rate_stairs)*1.05]);


function out = empty2nan(in)
if isempty(in)
    out = nan;
else
    out = in;
end
