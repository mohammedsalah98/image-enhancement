function varargout = project2(varargin)
% PROJECT2 MATLAB code for project2.fig
%      PROJECT2, by itself, creates a new PROJECT2 or raises the existing
%      singleton*.
%
%      H = PROJECT2 returns the handle to a new PROJECT2 or the handle to
%      the existing singleton*.
%
%      PROJECT2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROJECT2.M with the given input arguments.
%s
%      PROJECT2('Property','Value',...) creates a new PROJECT2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before project2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to project2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help project2

% Last Modified by GUIDE v2.5 14-Dec-2019 16:42:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @project2_OpeningFcn, ...
                   'gui_OutputFcn',  @project2_OutputFcn, ...
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


% --- Executes just before project2 is made visible.
function project2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to project2 (see VARARGIN)

% Choose default command line output for project2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes project2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = project2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in selectImage.
function selectImage_Callback(hObject, eventdata, handles)
% hObject    handle to selectImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global toGray;
[file,path]= uigetfile({'*.*'});
imageLocation = fullfile(path,file);    
RGB = imread(imageLocation);
axes(handles.axes1);
imshow(RGB);
toGray = rgb2gray(RGB);
subplot(2,1,1)
imshow(toGray)
subplot(2,1,2)
imhist(toGray,100)



% --- Executes on selection change in chooseHist.
function chooseHist_Callback(hObject, eventdata, handles)
% hObject    handle to chooseHist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global toGray ;
global HistogramEq;
global Histogram;
Choice = get(handles.chooseHist,'Value');

switch Choice 
    case 2
        X = toGray;
        X = histeq(X);
        HistogramEq = X;
    case 3 
        Z = toGray;
        a = min(Z(:));  %minimum pixel of image X
        b = max(Z(:));  %maximum pixel of image X
        Z= (Z-a).*(255/(b-a));
        Histogram = Z;
    otherwise
        disp(' You Did Not make any choice Yet')
        
end

if isequal(Choice,1)
    imshow(toGray);
elseif isequal(Choice,2)
    axes(handles.axes2);
    imshow(HistogramEq)
    axes(handles.axes6);
    imhist(HistogramEq,64)
else
    axes(handles.axes3);
    imshow(Histogram)
   axes(handles.axes7);
    imhist(Histogram,64)
    end


% Hints: contents = cellstr(get(hObject,'String')) returns chooseHist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from chooseHist


% --- Executes during object creation, after setting all properties.
function chooseHist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chooseHist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in filterStMenu.
function filterStMenu_Callback(hObject, eventdata, handles)
% hObject    handle to filterStMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Histogram ;

Choice = get(handles.filterStMenu,'Value');

switch Choice 
    case 2 
        Filter = filter2(fspecial('average',3),Histogram)/255; %Avarage
    case 3 
        Filter = medfilt2(Histogram);
    case 4 
        F1 =fspecial('average',11); % low pass filter
        Filter = filter2(F1, Histogram ,'same')/255;
    case 5
        A = double(Histogram);      
        A = A./max(max(max(A)));
        F1 =fspecial('average',11); % low pass filter
        F2 = filter2(F1, A ,'same');
        Filter = A - F2;
        
        
        
    otherwise
        disp(' You Did Not CHoose Any Noise Yet')
        
end
axes(handles.axes7);
if isequal(Choice,1)
    imshow(Histogram);
else
    imshow(Filter);
end

% Hints: contents = cellstr(get(hObject,'String')) returns filterStMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from filterStMenu


% --- Executes during object creation, after setting all properties.
function filterStMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filterStMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in noiseStMenu.
function noiseStMenu_Callback(hObject, eventdata, handles)
% hObject    handle to noiseStMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Histogram;
Choice = get(handles.noiseStMenu,'Value');

switch Choice 
    case 2 
        Noise = imnoise(Histogram ,'salt & pepper')
    case 3 
        Noise = imnoise(Histogram ,'speckle')
    case 4 
        LEN = 25;
        THETA = 180;
        motionBlur = fspecial('motion', LEN, THETA);
        Noise = imfilter(Histogram, motionBlur, 'conv', 'circular');
        
    otherwise
        disp(' You Did Not CHoose Any Noise Yet')
        
end
axes(handles.axes7);
if isequal(Choice,1)
    imshow(Histogram);
else
    imshow(Noise);
end


% Hints: contents = cellstr(get(hObject,'String')) returns noiseStMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from noiseStMenu


% --- Executes during object creation, after setting all properties.
function noiseStMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noiseStMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in noiseEqMenu.
function noiseEqMenu_Callback(hObject, eventdata, handles)
% hObject    handle to noiseEqMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global HistogramEq ; 
Choice = get(handles.noiseEqMenu,'Value');

switch Choice 
    case 2 
        Noise = imnoise(HistogramEq ,'salt & pepper')
    case 3 
        Noise = imnoise(HistogramEq ,'speckle')
    case 4 
        LEN = 21;
        THETA = 11;
        motionBlur = fspecial('motion', LEN, THETA);
        Noise = imfilter(HistogramEq, motionBlur, 'conv', 'circular');
        
    otherwise
        disp(' You Did Not CHoose Any Noise Yet')
        
end
axes(handles.axes6);
if isequal(Choice,1)
    imshow(HistogramEq)
    
else  
    imshow(Noise)
end

% Hints: contents = cellstr(get(hObject,'String')) returns noiseEqMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from noiseEqMenu


% --- Executes during object creation, after setting all properties.
function noiseEqMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noiseEqMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global HistogramEq ; 
Choice = get(handles.popupmenu5,'Value');

switch Choice 
    case 2 
        Filter = filter2(fspecial('average',3),HistogramEq)/255; %Avarage
    case 3 
        Filter = medfilt2(HistogramEq);
    case 4 
        F1 =fspecial('average',11); % low pass filter
        Filter = filter2(F1, HistogramEq ,'same')/255;
    case 5
        A = double(HistogramEq);
        A = A./max(max(max(A)));
        F1 =fspecial('average',11); % low pass filter
        F2 = imfilter(A, F1 ,'same');
        Filter = A - F2;
        
        
        
    otherwise
        disp(' You Did Not CHoose Any Noise Yet')
        
end
axes(handles.axes6);
if isequal(Choice,1)
    imshow(HistogramEq);
else
    imshow(Filter);
end

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5


% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes2);
cla(handles.axes2,'reset');
