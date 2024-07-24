function varargout = modelshow(varargin)

% Bu dosya modelshow figüre ait fonksiyonları içerir.

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @modelshow_OpeningFcn, ...
                   'gui_OutputFcn',  @modelshow_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function modelshow_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

guidata(hObject, handles);

function varargout = modelshow_OutputFcn(hObject, eventdata, handles)

varargout{1} = handles.output;



% CalcRCS butonuna basıldığında çalışır
function CalcRCS_Callback(hObject, eventdata, handles)

function leftpic_CreateFcn(hObject, eventdata, handles)

axes(findobj('Tag','leftpic'));
a=['pics\10.jpg'];
imshow('pics\10.jpg');

function rightpic_CreateFcn(hObject, eventdata, handles)

axes(findobj('Tag','rightpic'));
a=['pics\11.jpg'];
imshow('pics\11.jpg');