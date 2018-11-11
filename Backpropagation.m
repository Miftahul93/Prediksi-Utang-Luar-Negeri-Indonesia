function varargout = Backpropagation(varargin)
% BACKPROPAGATION MATLAB code for Backpropagation.fig
%      BACKPROPAGATION, by itself, creates a new BACKPROPAGATION or raises the existing
%      singleton*.
%
%      H = BACKPROPAGATION returns the handle to a new BACKPROPAGATION or the handle to
%      the existing singleton*.
%
%      BACKPROPAGATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BACKPROPAGATION.M with the given input arguments.
%
%      BACKPROPAGATION('Property','Value',...) creates a new BACKPROPAGATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Backpropagation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Backpropagation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Backpropagation

% Last Modified by GUIDE v2.5 11-Oct-2018 18:59:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Backpropagation_OpeningFcn, ...
                   'gui_OutputFcn',  @Backpropagation_OutputFcn, ...
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




% --- Executes just before Backpropagation is made visible.
function Backpropagation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Backpropagation (see VARARGIN)

% Choose default command line output for Backpropagation
handles.output = hObject;
%hback = axes('unit','normalized','position',[0 0 1 1]);
%uistack(hback, 'bottom');
%[back map] =imread('pb.jpg');
%image(back)
%colormap(map)
%set(hback,'handlevisibility','off','visible','off');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Backpropagation wait for user response (see UIRESUME)
% uiwait(handles.figure1);

axes(handles.axes2);
image(imread('Miftahul-Ulum','jpg'));
grid off;
axis off;

axes(handles.axes4);
image(imread('pbb','jpg'));
grid off;
axis off;

axes(handles.axes5);
image(imread('upb','jpg'));
grid off;
axis off;

axes(handles.axes6);
image(imread('pb1','jpg'));
grid off;
axis off;


% --- Outputs from this function are returned to the command line.
function varargout = Backpropagation_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pelatihanJaringanButton.
function pelatihanJaringanButton_Callback(hObject, eventdata, handles)
jumlahDataTargetLatih = getappdata(0,'jumlahDataTargetLatih');
assignin('base','jumlahDataTargetLatih',jumlahDataTargetLatih);
dataLatihInput = getappdata(0,'dataLatihInput');
dataLatihTarget = getappdata(0,'dataLatihTarget');
neuronHidden = str2num(get(handles.neuronHiddenEdit, 'string'));
neuronOutput = str2num(get(handles.neuronOutputEdit, 'string'));

%pembuatan JST
net = newff(minmax(dataLatihInput),[neuronHidden neuronOutput],{'logsig','purelin'},'traingdx');

%memberikan nilai untuk mempengaruhi proses UIpanel
net.performFcn = 'mse';
net.trainParam.goal = str2double(get(handles.goalEdit, 'string'));
net.trainParam.epochs = str2double(get(handles.epochEdit, 'string'));
net.trainParam.mc = str2double(get(handles.momentumEdit, 'string'));
net.trainParam.lr = str2double(get(handles.learningRateEdit, 'string'));

bobot_awal_hidden = net.IW{1,1};
assignin('base','bobot_awal_hidden',bobot_awal_hidden);
bias_awal_hidden = net.b{1,1};
assignin('base','bias_awal_hidden',bias_awal_hidden);
bobot_awal_keluaran = net.LW{2,1};
assignin('base','bobot_awal_keuaran',bobot_awal_keluaran);
bias_awal_keluaran = net.b{2,1};
assignin('base','bias_awal_keluaran',bias_awal_keluaran);

%Training Data
[net_keluaran,tr,Y,E] = train(net,dataLatihInput, dataLatihTarget);

%Hasil Setelah UIPanel
bobot_hidden = net_keluaran.IW{1,1};
assignin('base','bias_awal_keluaran',bias_awal_keluaran);
bobot_keluaran = net_keluaran.LW{2,1};
assignin('base','bias_awal_keluaran',bias_awal_keluaran);
bias_hidden = net_keluaran.b{1,1};
assignin('base','bias_awal_keluaran',bias_awal_keluaran);
bias_keluaran = net_keluaran.b(2,1);
assignin('base','bias_awal_keluaran',bias_awal_keluaran);

jumlah_iterasi = tr.num_epochs;
nilai_keluaran = Y;
nilai_error = E;
error_MSE = (1/jumlahDataTargetLatih)*sum(nilai_error.^2);

save net.mat net_keluaran;

hasil_latih = sim(net_keluaran,dataLatihInput);
assignin('base','hasil_latih',hasil_latih);
assignin('base','dataLatihTarget',dataLatihTarget);
set(handles.prediksiLatihUitable,'data',hasil_latih');

mape = ones(1, jumlahDataTargetLatih);
akurasi = ones(1, jumlahDataTargetLatih);
for i = 1:1
    for j = 1:jumlahDataTargetLatih
        gap = hasil_latih(i,j) - dataLatihTarget(i, j);
        if gap > 0
            mape(i,j) = gap / dataLatihTarget(1, j) * 100;
        else
            mape(i,j) = (gap * -1) / dataLatihTarget(i,j) * 100;
        end
        akurasi(i,j) = 100 - mape(i,j);
    end
end

assignin('base','mape',mape);
assignin('base','akurasi',akurasi);
aveAkurasi = mean(akurasi);
assignin('base','meanAkurasi',aveAkurasi);
set(handles.akurasiLatihText, 'string', aveAkurasi);

%Denormalisasi
%hasil_latih_denormalisasi = ((hasil_latih-0.1)*(maxData-minData)/0.8)+minData;
    
%Performansi hasil Prediksi
figure,
plotregression(dataLatihTarget,hasil_latih,'Regression')

figure,
plotperform(tr)

figure,
plot(hasil_latih,'bo-')
hold on
plot(dataLatihTarget,'ro-')
hold off
grid on
title(strcat(['Grafik Keluaran JST vs Target Dengan Nilai MSE = ',...
    num2str(error_MSE)]))
xlabel('Periode ke-')
ylabel('Utang Luar Negeri Indonesia')
legend('Keluaran JST','Target','Location','Best')

% --- Executes on button press in normalisasiButton.
function normalisasiButton_Callback(hObject, eventdata, handles)
% hObject    handle to normalisasiButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

jumlahData = str2num(get(handles.jumlahDataText,'string'));
data = getappdata(0,'data');
maxData = str2num(get(handles.maxDataText,'string'));
minData = str2num(get(handles.minDataText,'string'));

%Normalisasi Interval 0.1-0.9
for i = 1:jumlahData
    for j = 1:6
        data(i,j) = ((0.8 * (data(i,j) - minData)) / (maxData - minData)) + 0.1;
    end
end

assignin('base','minData',minData);
assignin('base','maxData',maxData);
assignin('base','dataNormalisasi',data);
set(handles.dataNormalisasiUitable,'data',data);
setappdata(0,'dataNormalisasi',data);


% --- Executes on button press in loadDataButton.
function loadDataButton_Callback(hObject, eventdata, handles)
%dataAwal = xlsread('Book1',1,'B4:G39');
%dataset = dataAwal';
dataAwal = xlsread('Dataset',1,'B4:G129');
dataset = dataAwal;
[a, b] = size(dataAwal)
data = ones(a,b)
%jumlahDataset = size(dataset);
%data = ones(jumlahDataset(1,1) - 5, 6);
jumlahData = size(data);

%Set Dataset ke arsitektur 5 input + 1 Target
%for i = 1:jumlahData
%    for j = 1:6
%        if j == 1
%            data(i,j) = dataset(i);
%        elseif j == 2
%            data(i,j) = dataset(i+1);
%        elseif j == 3
%            data(i,j) = dataset(i+2);
%        elseif j == 4
%            data(i,j) = dataset(i+3);
%        elseif j == 5
%            data(i,j) = dataset(i+4);
%        elseif j == 6
%            data(i,j) = dataset(i+5);
%        end
%    end
%end

maxData = max(max(dataset));
minData = min(min(dataset));

setappdata(0,'minData',minData);
setappdata(0,'maxData',maxData);
setappdata(0,'data',dataset);
setappdata(0,'jumlahData',jumlahData);
assignin('base','jumlahData',dataset);
assignin('base','dataAwal',dataset);
assignin('base','minData',minData);
assignin('base','maxData',maxData);
set(handles.dataAwalUitable,'data',dataset);
set(handles.minDataText,'string',minData);
set(handles.maxDataText,'string',maxData);
set(handles.jumlahDataText,'string',jumlahData);


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function goalEdit_Callback(hObject, eventdata, handles)
% hObject    handle to goalEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of goalEdit as text
%        str2double(get(hObject,'String')) returns contents of goalEdit as a double


% --- Executes during object creation, after setting all properties.
function goalEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to goalEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function epochEdit_Callback(hObject, eventdata, handles)
% hObject    handle to epochEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of epochEdit as text
%        str2double(get(hObject,'String')) returns contents of epochEdit as a double


% --- Executes during object creation, after setting all properties.
function epochEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epochEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function momentumEdit_Callback(hObject, eventdata, handles)
% hObject    handle to momentumEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of momentumEdit as text
%        str2double(get(hObject,'String')) returns contents of momentumEdit as a double


% --- Executes during object creation, after setting all properties.
function momentumEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to momentumEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function learningRateEdit_Callback(hObject, eventdata, handles)
% hObject    handle to learningRateEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of learningRateEdit as text
%        str2double(get(hObject,'String')) returns contents of learningRateEdit as a double


% --- Executes during object creation, after setting all properties.
function learningRateEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to learningRateEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function neuronInputEdit_Callback(hObject, eventdata, handles)
% hObject    handle to neuronInputEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of neuronInputEdit as text
%        str2double(get(hObject,'String')) returns contents of neuronInputEdit as a double


% --- Executes during object creation, after setting all properties.
function neuronInputEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to neuronInputEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function neuronHiddenEdit_Callback(hObject, eventdata, handles)
% hObject    handle to neuronHiddenEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of neuronHiddenEdit as text
%        str2double(get(hObject,'String')) returns contents of neuronHiddenEdit as a double


% --- Executes during object creation, after setting all properties.
function neuronHiddenEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to neuronHiddenEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function neuronOutputEdit_Callback(hObject, eventdata, handles)
% hObject    handle to neuronOutputEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of neuronOutputEdit as text
%        str2double(get(hObject,'String')) returns contents of neuronOutputEdit as a double


% --- Executes during object creation, after setting all properties.
function neuronOutputEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to neuronOutputEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function jumlahDataPelatihanEdit_Callback(hObject, eventdata, handles)
% hObject    handle to jumlahDataPelatihanEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of jumlahDataPelatihanEdit as text
%        str2double(get(hObject,'String')) returns contents of jumlahDataPelatihanEdit as a double


% --- Executes during object creation, after setting all properties.
function jumlahDataPelatihanEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to jumlahDataPelatihanEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function jumlahDataPengujianEdit_Callback(hObject, eventdata, handles)
% hObject    handle to jumlahDataPengujianEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of jumlahDataPengujianEdit as text
%        str2double(get(hObject,'String')) returns contents of jumlahDataPengujianEdit as a double


% --- Executes during object creation, after setting all properties.
function jumlahDataPengujianEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to jumlahDataPengujianEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bagiDataButton.
function bagiDataButton_Callback(hObject, eventdata, handles)
%Deklarasi Jumlah Input
data = getappdata(0,'dataNormalisasi');
jumlahData = str2num(get(handles.jumlahDataText,'string'));
dataLatih = str2num(get(handles.jumlahDataPelatihanEdit,'string'));
dataUji = str2num(get(handles.jumlahDataPengujianEdit,'string'));
%jumlahInput = 24;
%jumlahTesting = 12;
jumlahInput = round(dataLatih/100 * jumlahData);
jumlahTesting = round(dataUji/100 * jumlahData);
    
%Menentukan Field Input dan Output data training
dataLatihInput = data(1:jumlahInput,1:5);
dataLatihTarget = data(1:jumlahInput, 6);
dataUjiInput = data(jumlahInput+1:jumlahData, 1:5);
dataUjiOutput = data(jumlahInput+1:jumlahData, 6);
[m,n] = size(dataLatihInput);
[o,p] = size(dataUjiInput);

% Total tabel data latih dan testing
set(handles.dataLatihInputUitable,'data',data(1:jumlahInput,1:6));
%set(handles.dataLatihTargetUitable,'data',dataLatihTarget);
set(handles.dataUjiInputUitable,'data',data(jumlahInput+1:jumlahData, 1:6));
%set(handles.dataUjiTargetUitable,'data',dataUjiOutput);

%pembagian data latih dan testing
set(handles.jumlahDataLatihText,'string',m);
set(handles.jumlahDataUjiText,'string',o);

set(handles.targetLatihUitable,'data',dataLatihTarget);
set(handles.targetUjiUitable,'data',dataUjiOutput);

dataLatihInput = dataLatihInput';
dataLatihTarget = dataLatihTarget';
dataUjiInput = dataUjiInput';
dataUjiOutput = dataUjiOutput';

assignin('base','dataLatihInput',dataLatihInput);
assignin('base','dataLatihTarget',dataLatihTarget);
assignin('base','dataUjiInput',dataUjiInput);
assignin('base','dataUjiTarget',dataUjiOutput);
setappdata(0,'dataLatihInput',dataLatihInput);
setappdata(0,'dataLatihTarget',dataLatihTarget);
setappdata(0,'dataUjiInput',dataUjiInput);
setappdata(0,'dataUjiOutput',dataUjiOutput);
setappdata(0,'jumlahDataTargetLatih',m);
setappdata(0,'jumlahDataTargetUji',o);


% --- Executes on button press in pengujianJaringanButton.
function pengujianJaringanButton_Callback(hObject, eventdata, handles)
load net.mat

dataUjiInput = getappdata(0,'dataUjiInput');
dataUjiTarget = getappdata(0,'dataUjiOutput');
jumlahDataTargetUji = getappdata(0,'jumlahDataTargetUji');

%hasil Prediksi
hasil_uji = sim(net_keluaran,dataUjiInput);

%hasil_latih = ((hasil_latih-0.1)*(maxData-minData)/0.8)+minData;
set(handles.prediksiUjiUitable,'data',hasil_uji');

assignin('base','hasil_uji',hasil_uji);
assignin('base','dataUjiTarget',dataUjiTarget);
nilai_error = hasil_uji - dataUjiTarget;

%Performansi hasil prediksi
error_MSE = (1/jumlahDataTargetUji)*sum(nilai_error.^2);

mape = ones(1, jumlahDataTargetUji);
akurasi = ones(1, jumlahDataTargetUji);
for i = 1:1
    for j = 1:jumlahDataTargetUji
        gap = hasil_uji(i,j) - dataUjiTarget(i, j );
        if gap > 0
            mape(i,j) = gap / dataUjiTarget(i, j) * 100;
        else
            mape(i,j) = (gap * -1) / dataUjiTarget(i, j ) * 100;
        end
        akurasi(i,j) = 100 - mape(i,j);
    end
end

assignin('base','mapeUji',mape);
assignin('base','akurasiUji',akurasi);
aveAkurasi = mean(akurasi);
assignin('base','meanAkurasiUji',aveAkurasi);
set(handles.akurasiUjiText, 'string', aveAkurasi);

%figure,
%plotregression(dataUjiTarget,hasil_uji,'Regression')

figure,
plot(hasil_uji,'bo-')
hold on
plot(dataUjiTarget,'ro-')
hold off
grid on
title(strcat(['Grafik Keluaran JST vs Target dengan Nilai MSE = ',...
    num2str(error_MSE)]))
xlabel('Periode ke-')
ylabel('Utang Luar Negeri Indonesia')
legend('Keluaran JST','Target','Location','Best')


% --------------------------------------------------------------------
function menuHome_Callback(hObject, eventdata, handles)
set(handles.panelHome,'visible','on');
set(handles.panelPersiapanData,'visible','off');
set(handles.panelPrediksi,'visible','off');
set(handles.panelBiodata,'visible','off');
set(handles.panelBantuan,'visible','off');


% --------------------------------------------------------------------
function menuPersiapanData_Callback(hObject, eventdata, handles)
set(handles.panelHome,'visible','off');
set(handles.panelPersiapanData,'visible','on');
set(handles.panelPrediksi,'visible','off');
set(handles.panelBiodata,'visible','off');
set(handles.panelBantuan,'visible','off');


% --------------------------------------------------------------------
function menuPrediksi_Callback(hObject, eventdata, handles)
set(handles.panelHome,'visible','off');
set(handles.panelPersiapanData,'visible','off');
set(handles.panelPrediksi,'visible','on');
set(handles.panelBiodata,'visible','off');
set(handles.panelBantuan,'visible','off');


% --------------------------------------------------------------------
function menuBiodata_Callback(hObject, eventdata, handles)
set(handles.panelHome,'visible','off');
set(handles.panelPersiapanData,'visible','off');
set(handles.panelPrediksi,'visible','off');
set(handles.panelBiodata,'visible','on');
set(handles.panelBantuan,'visible','off');


% --------------------------------------------------------------------
function menuBantuan_Callback(hObject, eventdata, handles)
set(handles.panelHome,'visible','off');
set(handles.panelPersiapanData,'visible','off');
set(handles.panelPrediksi,'visible','off');
set(handles.panelBiodata,'visible','off');
set(handles.panelBantuan,'visible','on');


% --------------------------------------------------------------------
function menuKeluar_Callback(hObject, eventdata, handles)
pilihan = questdlg('Apakah anda ingin menutup Program?', ...
    'Menutup Program', ...
    'Ya','Tidak','Tidak');
%Handle Response
switch pilihan
    case 'Ya'
        close(Backpropagation);
    case 'Tidak'
        return;
end

% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton21.
function pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit22 as text
%        str2double(get(hObject,'String')) returns contents of edit22 as a double


% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton22.
function pushbutton22_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to jumlahDataPelatihanEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of jumlahDataPelatihanEdit as text
%        str2double(get(hObject,'String')) returns contents of jumlahDataPelatihanEdit as a double


% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to jumlahDataPelatihanEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit24_Callback(hObject, eventdata, handles)
% hObject    handle to jumlahDataPengujianEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of jumlahDataPengujianEdit as text
%        str2double(get(hObject,'String')) returns contents of jumlahDataPengujianEdit as a double


% --- Executes during object creation, after setting all properties.
function edit24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to jumlahDataPengujianEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bagiDataButton.
function pushbutton23_Callback(hObject, eventdata, handles)
% hObject    handle to bagiDataButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in normalisasiButton.
function pushbutton24_Callback(hObject, eventdata, handles)
% hObject    handle to normalisasiButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in loadDataButton.
function pushbutton25_Callback(hObject, eventdata, handles)
% hObject    handle to loadDataButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton27.
function pushbutton27_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton26.
function pushbutton26_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit25_Callback(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit25 as text
%        str2double(get(hObject,'String')) returns contents of edit25 as a double


% --- Executes during object creation, after setting all properties.
function edit25_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit26_Callback(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit26 as text
%        str2double(get(hObject,'String')) returns contents of edit26 as a double


% --- Executes during object creation, after setting all properties.
function edit26_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit27_Callback(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit27 as text
%        str2double(get(hObject,'String')) returns contents of edit27 as a double


% --- Executes during object creation, after setting all properties.
function edit27_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit28_Callback(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit28 as text
%        str2double(get(hObject,'String')) returns contents of edit28 as a double


% --- Executes during object creation, after setting all properties.
function edit28_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit29_Callback(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit29 as text
%        str2double(get(hObject,'String')) returns contents of edit29 as a double


% --- Executes during object creation, after setting all properties.
function edit29_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit30_Callback(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit30 as text
%        str2double(get(hObject,'String')) returns contents of edit30 as a double


% --- Executes during object creation, after setting all properties.
function edit30_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit31_Callback(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit31 as text
%        str2double(get(hObject,'String')) returns contents of edit31 as a double


% --- Executes during object creation, after setting all properties.
function edit31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit32_Callback(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit32 as text
%        str2double(get(hObject,'String')) returns contents of edit32 as a double


% --- Executes during object creation, after setting all properties.
function edit32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit33_Callback(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit33 as text
%        str2double(get(hObject,'String')) returns contents of edit33 as a double


% --- Executes during object creation, after setting all properties.
function edit33_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit34_Callback(hObject, eventdata, handles)
% hObject    handle to edit34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit34 as text
%        str2double(get(hObject,'String')) returns contents of edit34 as a double


% --- Executes during object creation, after setting all properties.
function edit34_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton28.
function pushbutton28_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit35_Callback(hObject, eventdata, handles)
% hObject    handle to edit35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit35 as text
%        str2double(get(hObject,'String')) returns contents of edit35 as a double


% --- Executes during object creation, after setting all properties.
function edit35_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit36_Callback(hObject, eventdata, handles)
% hObject    handle to edit36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit36 as text
%        str2double(get(hObject,'String')) returns contents of edit36 as a double


% --- Executes during object creation, after setting all properties.
function edit36_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit37_Callback(hObject, eventdata, handles)
% hObject    handle to edit37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit37 as text
%        str2double(get(hObject,'String')) returns contents of edit37 as a double


% --- Executes during object creation, after setting all properties.
function edit37_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit38_Callback(hObject, eventdata, handles)
% hObject    handle to edit38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit38 as text
%        str2double(get(hObject,'String')) returns contents of edit38 as a double


% --- Executes during object creation, after setting all properties.
function edit38_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit39_Callback(hObject, eventdata, handles)
% hObject    handle to edit39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit39 as text
%        str2double(get(hObject,'String')) returns contents of edit39 as a double


% --- Executes during object creation, after setting all properties.
function edit39_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit40_Callback(hObject, eventdata, handles)
% hObject    handle to edit40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit40 as text
%        str2double(get(hObject,'String')) returns contents of edit40 as a double


% --- Executes during object creation, after setting all properties.
function edit40_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit41_Callback(hObject, eventdata, handles)
% hObject    handle to edit41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit41 as text
%        str2double(get(hObject,'String')) returns contents of edit41 as a double


% --- Executes during object creation, after setting all properties.
function edit41_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit42_Callback(hObject, eventdata, handles)
% hObject    handle to edit42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit42 as text
%        str2double(get(hObject,'String')) returns contents of edit42 as a double


% --- Executes during object creation, after setting all properties.
function edit42_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit43_Callback(hObject, eventdata, handles)
% hObject    handle to edit43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit43 as text
%        str2double(get(hObject,'String')) returns contents of edit43 as a double


% --- Executes during object creation, after setting all properties.
function edit43_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit44_Callback(hObject, eventdata, handles)
% hObject    handle to edit44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit44 as text
%        str2double(get(hObject,'String')) returns contents of edit44 as a double


% --- Executes during object creation, after setting all properties.
function edit44_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pengujianJaringanButton.
function pushbutton30_Callback(hObject, eventdata, handles)
% hObject    handle to pengujianJaringanButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pelatihanJaringanButton.
function pushbutton29_Callback(hObject, eventdata, handles)
% hObject    handle to pelatihanJaringanButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit45_Callback(hObject, eventdata, handles)
% hObject    handle to neuronInputEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of neuronInputEdit as text
%        str2double(get(hObject,'String')) returns contents of neuronInputEdit as a double


% --- Executes during object creation, after setting all properties.
function edit45_CreateFcn(hObject, eventdata, handles)
% hObject    handle to neuronInputEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit46_Callback(hObject, eventdata, handles)
% hObject    handle to neuronHiddenEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of neuronHiddenEdit as text
%        str2double(get(hObject,'String')) returns contents of neuronHiddenEdit as a double


% --- Executes during object creation, after setting all properties.
function edit46_CreateFcn(hObject, eventdata, handles)
% hObject    handle to neuronHiddenEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit47_Callback(hObject, eventdata, handles)
% hObject    handle to neuronOutputEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of neuronOutputEdit as text
%        str2double(get(hObject,'String')) returns contents of neuronOutputEdit as a double


% --- Executes during object creation, after setting all properties.
function edit47_CreateFcn(hObject, eventdata, handles)
% hObject    handle to neuronOutputEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit48_Callback(hObject, eventdata, handles)
% hObject    handle to edit48 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit48 as text
%        str2double(get(hObject,'String')) returns contents of edit48 as a double


% --- Executes during object creation, after setting all properties.
function edit48_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit48 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit49_Callback(hObject, eventdata, handles)
% hObject    handle to edit49 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit49 as text
%        str2double(get(hObject,'String')) returns contents of edit49 as a double


% --- Executes during object creation, after setting all properties.
function edit49_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit49 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit50_Callback(hObject, eventdata, handles)
% hObject    handle to edit50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit50 as text
%        str2double(get(hObject,'String')) returns contents of edit50 as a double


% --- Executes during object creation, after setting all properties.
function edit50_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit51_Callback(hObject, eventdata, handles)
% hObject    handle to goalEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of goalEdit as text
%        str2double(get(hObject,'String')) returns contents of goalEdit as a double


% --- Executes during object creation, after setting all properties.
function edit51_CreateFcn(hObject, eventdata, handles)
% hObject    handle to goalEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit52_Callback(hObject, eventdata, handles)
% hObject    handle to epochEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of epochEdit as text
%        str2double(get(hObject,'String')) returns contents of epochEdit as a double


% --- Executes during object creation, after setting all properties.
function edit52_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epochEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit53_Callback(hObject, eventdata, handles)
% hObject    handle to momentumEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of momentumEdit as text
%        str2double(get(hObject,'String')) returns contents of momentumEdit as a double


% --- Executes during object creation, after setting all properties.
function edit53_CreateFcn(hObject, eventdata, handles)
% hObject    handle to momentumEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit54_Callback(hObject, eventdata, handles)
% hObject    handle to learningRateEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of learningRateEdit as text
%        str2double(get(hObject,'String')) returns contents of learningRateEdit as a double


% --- Executes during object creation, after setting all properties.
function edit54_CreateFcn(hObject, eventdata, handles)
% hObject    handle to learningRateEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
