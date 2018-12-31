function varargout = comptrendlibwindow(varargin)
% COMPTRENDLIBWINDOW MATLAB code for comptrendlibwindow.fig
%      COMPTRENDLIBWINDOW, by itself, creates a new COMPTRENDLIBWINDOW or raises the existing
%      singleton*.
%
%      H = COMPTRENDLIBWINDOW returns the handle to a new COMPTRENDLIBWINDOW or the handle to
%      the existing singleton*.
%
%      COMPTRENDLIBWINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COMPTRENDLIBWINDOW.M with the given input arguments.
%
%      COMPTRENDLIBWINDOW('Property','Value',...) creates a new COMPTRENDLIBWINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before comptrendlibwindow_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to comptrendlibwindow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help comptrendlibwindow

% Last Modified by GUIDE v2.5 18-Aug-2018 14:42:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @comptrendlibwindow_OpeningFcn, ...
                   'gui_OutputFcn',  @comptrendlibwindow_OutputFcn, ...
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


% --- Executes just before comptrendlibwindow is made visible.
function comptrendlibwindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to comptrendlibwindow (see VARARGIN)

% Choose default command line output for comptrendlibwindow
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes comptrendlibwindow wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = comptrendlibwindow_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function uitable1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
table_data = load('data\CompactionTrendLibrary.mat', 'comptrend_lib');
set(hObject, 'data', table_data.comptrend_lib);
headers = {'Lithology', ...
           'Initial Porosity [%]', ...
           'Coefficient c', ...
           'Reference',};
widths = {130 100 100 170};
formats = {'char' 'char' 'char' 'char'};
editable = [false false false false];
set(hObject, 'ColumnName', headers);
set(hObject, 'ColumnWidth', widths);
set(hObject, 'ColumnFormat', formats);
set(hObject, 'ColumnEditable', editable);
