clc;clear;close all;warning off all;

data = xlsread('Dataset',1,'B4:G129')
%data  = xlsread('Book1',3,'B4:G27');
dataset = data
%[a,b] = size(dataset)
%jumlahDataset = size(dataset)
%data = zeros(a,b)
jumlahData = size(data);

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
%jumlahInput = 24
%jumlahTesting = 12
jumlahInput = round(70/100 * jumlahData);
jumlahTesting = round(30/100 * jumlahData);
    
%Menentukan Field Input dan Output data training
dataLatihInput = data(1:jumlahInput,1:5);
dataLatihTarget = data(1:jumlahInput, 6);
[m,n] = size(dataLatihInput);
    
dataLatihInput = dataLatihInput';
dataLatihTarget = dataLatihTarget';
    
a = minmax(dataLatihInput);

%Pembuatan JST
net = newff(minmax(dataLatihInput),[8 1], {'logsig','purelin'},'traingdx');

% Memberikan Nilai Untuk Mempengaruhi Proses Pelatihan
net.performFcn = 'mse';
net.trainParam.goal = 0.0001;
net.trainParam.show = 20;
net.trainParam.epochs = 2000;
net.trainParam.mc = 0.5;
net.trainParam.lr = 0.8;

bobot_awal_hidden = net.IW{1,1};
bias_awal_hidden = net.b{1,1};
bobot_awal_keluaran = net.LW{2,1};
bias_awal_keluaran = net.b{2,1};

%Training Data
[net_keluaran,tr,Y,E] = train(net,dataLatihInput, dataLatihTarget);

%Hasil Setelah Pelatihan
bobot_hidden = net_keluaran.IW{1,1};
bobot_keluaran = net_keluaran.LW{2,1};
bias_hidden = net_keluaran.b{1,1};
bias_keluaran = net_keluaran.b{2,1};

jumlah_iterasi = tr.num_epochs;
nilai_keluaran = Y;
nilai_error = E;
error_MSE = (1/n)*sum(nilai_error.^2);

save net.mat net_keluaran;

hasil_latih = sim(net_keluaran,dataLatihInput);

%Denormalisasi
hasil_latih_denormalisasi = ((hasil_latih-0.1)*(maxData-minData)/0.8)+minData;
    
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