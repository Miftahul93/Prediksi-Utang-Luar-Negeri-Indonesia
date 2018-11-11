clc;clear;close all;warning off all;

%Mengambil Jaringan yang sudah dibuat pada Proses Pelatihan
load net.mat

dataset = xlsread('Book1',1,'B4:G39');
jumlahDataset = size(dataset);
%data = zeros(jumlahDataset(1,1) - 5, 6);
jumlahData = size(dataset);

%Set Dataset ke arsitektur 5 input + 1 Target
for i =1:jumlahData
    for j = 1:6
        if j == 1
            data(i,j) = dataset(i);
        elseif j == 2
            data(i,j) = dataset(i+1);
        elseif j == 3
            data(i,j) = dataset(i+2);
        elseif j == 4
            data(i,j) = dataset(i+3);
        elseif j == 5
            data(i,j) = dataset(i+4);
        elseif j == 6
            data(i,j) = dataset(i+5);
        end
    end
end

maxData = max(max(dataset));
minData = min(min(dataset));

%Normalisasi Interval 0.1-0.9
for i = 1:jumlahData
    for j = 1:6
        data(i,j) = ((0.8 * (data(i,j) - minData)) / (maxData - minData)) + 0.1;
    end
end

    
%Deklarasi Jumlah Input
%jumlahInput = 24;
%jumlahTesting = 12;
jumlahInput = round(70/100 * jumlahData);
jumlahTesting = round(30/100 * jumlahData);
    
%Menentukan Field Input dan Output data Testing
dataUjiInput = data(jumlahInput+1:jumlahData, 1:5);
dataUjiOutput = data(jumlahInput+1:jumlahData, 6);
[m,n] = size(dataUjiInput);

dataUjiInput = dataUjiInput';
dataUjiOutput = dataUjiOutput';

%hasil Prediksi
hasil_uji = sim(net_keluaran,dataUjiInput);
%hasil_uji = ((hasil_uji-0.1)*(max_data-min_data)/0.8)+min_data;

nilai_error = hasil_uji-dataUjiOutput;

%Performance Hasil Prediksi
error_MSE = (1/n)*sum(nilai_error.^2);

%figure,
plotregression(dataUjiOutput,hasil_uji,'Regression')

figure,
plot(hasil_uji,'bo-')
hold on
plot(dataUjiOutput,'ro-')
hold off
grid on
title(strcat(['Grafik Keluaran JST vs Target dengan Nilai MSE = ',...
    num2str(error_MSE)]))
xlabel('Periode ke-')
ylabel('Utang Luar Negeri Indonesia')
legend('Keluaran JST','Target','Location','Best')
