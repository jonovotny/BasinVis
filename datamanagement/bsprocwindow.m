function varargout = bsprocwindow(varargin)
% BSPROCWINDOW MATLAB code for bsprocwindow.fig
%      BSPROCWINDOW, by itself, creates a new BSPROCWINDOW or raises the existing
%      singleton*.
%
%      H = BSPROCWINDOW returns the handle to a new BSPROCWINDOW or the handle to
%      the existing singleton*.
%
%      BSPROCWINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BSPROCWINDOW.M with the given input arguments.
%
%      BSPROCWINDOW('Property','Value',...) creates a new BSPROCWINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before bsprocwindow_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to bsprocwindow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

setupWsVar('bsproc_cancel', false);
% Edit the above text to modify the response to help bsprocwindow

% Last Modified by GUIDE v2.5 30-Nov-2014 19:12:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @bsprocwindow_OpeningFcn, ...
                   'gui_OutputFcn',  @bsprocwindow_OutputFcn, ...
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


% --- Executes just before bsprocwindow is made visible.
function bsprocwindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to bsprocwindow (see VARARGIN)

% Choose default command line output for bsprocwindow
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes bsprocwindow wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = bsprocwindow_OutputFcn(hObject, eventdata, handles) 
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
