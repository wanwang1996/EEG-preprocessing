% 1.FP1; 2.FP2; 3.AF3; 4.AF4; 5.F7; 6.F3; 7.FZ; 8.F4; 9.F8; 10.FC5; 
% 11.FC1; 12.FC2; 13.FC6; 14.T7; 15.C3; 16.CZ; 17.C4; 18.T8; 19.CP5; 20.CP1;
% 21.CP2; 22.CP6; 23.P7; 24.P3; 25.PZ; 26.P4; 27.P8; 28.PO3; 29.PO4; 30.O1; 
% 31.OZ; 32.O2; 33.HEO; 34.VEO; 
% Copyright@ Wan Wang
% Email:wanwang@Outlook.com
% preprocessing for rest state EEG
close all;
clear all;
load('003Data.mat');%% data was 37 channel with two mastoids and one tigger
fs = 1000;
%% Preprocessing
% re-reference
mastoids_mean = mean(data_open([19,24],:));
data_ref = data_open-mastoids_mean;
% notch filter
Wo = 50/(fs/2);  BW = Wo/35;
[b,a] = iirnotch(Wo,BW);
data_notch= filtfilt(b,a,(double(data_ref)));
% band filter
[b,a] = butter(3,[0.3/(fs/2) 70/(fs/2)],'bandpass');
data_bp= filtfilt(b,a,data_notch')';
data_bp = data_bp([1:18,20:23,25:36],:);
L=length(data_bp);t=(0:(L-1))/fs;
%% ICA
level = 32;
[Zica,A,W] = fastica(data_bp([1:32],:),'numOfIC', level);
icaplot(Zica,fs,10);
%% Correlation with EOG recordings
for k=1:(length(Zica(:,1)))
    s=corrcoef(data_bp(33,:)',Zica(k,:)');
    ss1(k) = s(2,1);
    s=corrcoef(data_bp(34,:)',Zica(k,:)');
    ss2(k) = s(2,1);
end
figure;plot(abs(ss1));title('Correlation with HEOG recordings ');
figure;plot(abs(ss2));title('Correlation with VEOG recordings');
%% Recon
rec_no = [1,2,3]; % Change here according to the ICs plot and correlation figure
Zica_del = Zica;
Zica_del(rec_no,:) = 0;
data_clean = A*Zica_del;
figure;plot(t,data_bp(1,:),'k');title('Original EEG ');
figure;plot(t,data_clean(1,:),'k');title('Clean EEG ');
%% Calc MultiScale entropy to test the noise level
% mse1 = MultiScaleEn(data_clean(1,range),100);
% figure;plot(mse1,'r');
% save([OPENPATH,savename],'data_clean');

