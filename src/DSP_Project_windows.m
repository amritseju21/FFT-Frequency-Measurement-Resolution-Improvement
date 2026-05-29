%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Description: DSP Project (First Module of Windowing Operation study)
%% Developers: Pramod Kumar (Sr.No.: 24997), Amrit Lal (Sr.No.: 24608) 
%% M.Tech (SP) 2024-26  IISc Bangalore
%% Start Date: 11/10/2024
%% Code Status: Completed
%% Remarks: Nil
%% Start Code
clc;clear all;close all;
%% Cosine function as per given paper
% function w = cosine_window(L)
%     wc=[0.355768  0.487396  0.144232  0.012604]
%     index=[-L/2-1:L/2]
%     for i = 1:L
%         p(i) = wc(1) * cos(2 * pi * 0 * index(i) / L) + wc(2) * cos(2 * pi * 1 * index(i) / L)+ wc(3) * cos(2 * pi * 2 * index(i) / L)+ wc(4) * cos(2 * pi * 3 * index(i) / L);
%         w=p';
%     end
% end
%% Global Parameter
N=32;
fs=20;
L=32;
%% Hanning window implementation for spectrum analysis
% N=32;
% fs=16;
% L=32;

hann_win1=hanning(N,'periodic');
hann_win=hann_win1/sum(hann_win1);


NFFT=L*N;
k=0:NFFT/2-1;
f=k*fs/NFFT;
h1=fft(hann_win,NFFT);
h1=h1(1:NFFT/2);
HdB1=20*log10(abs(h1));
len=length(HdB1);
for i=1:1:len
    if HdB1(i)<-120
        HdB1(i)=-120;
    end
end

figure(1);
plot(2*f,HdB1,'g-.','LineWidth',1.5)
ylabel('Norm. magnitude spectrum [dB]','Fontsize',16)
xlabel('| Normalised frequency |','FontSize',16)
title('Window Magnitude Spectrum')
grid minor;
hold on;
%% Gaussian window implementation for spectrum analysis
% N=32;
alpha=3;
gaus_win1=gausswin(N,alpha);
gaus_win=gaus_win1/sum(gaus_win1);
% 
% fs=16;
% L=32;
NFFT=L*N;
k=0:NFFT/2-1;
f=k*fs/NFFT;
h2=fft(gaus_win,NFFT);
h2=h2(1:NFFT/2);
HdB2=20*log10(abs(h2));
len=length(HdB2);

for i=1:1:len
    if HdB2(i)<-120
        HdB2(i)=-120;
    end
end
figure(1);
plot(2*f,HdB2,'b-.','LineWidth',1.5)
xlim([0 20])
ylim([-120 0])
hold on;
%% Kaiser window implementation for spectrum analysis
% N=32;
kas_win1 = kaiser(N,7);
kas_win = kas_win1/sum(kas_win1);
% fs=16;
% L=32;
NFFT=L*N;
k=0:NFFT/2-1;
f=k*fs/NFFT;
h3=fft(kas_win,NFFT);
h3=h3(1:NFFT/2);
HdB3=20*log10(abs(h3));
len=length(HdB3);

for i=1:1:len
    if HdB3(i)<-120
        HdB3(i)=-120;
    end
end
figure(1);
plot(2*f,HdB3,'r--','LineWidth',1.5)
xlim([0 20])
hold on;
%% Developers: Pramod Kumar (Sr.No.: 24997), Amrit Lal (Sr.No.: 24608) IISc Bangalore
%% Cosine window implementation for spectrum analysis
% L=32;
cos_win1 = cosine_window(N);
cos_win = cos_win1/sum(cos_win1);
% fs=16;
% L=32;
NFFT=L*N;
k=0:NFFT/2-1;
f=k*fs/NFFT;
h4=fft(cos_win,NFFT);
h4=h4(1:NFFT/2);
HdB4=20*log10(abs(h4));
len=length(HdB4);

for i=1:1:len
    if HdB4(i)<-120
        HdB4(i)=-120;
    end
end
figure(1);
plot(2*f,HdB4,'k--','LineWidth',1.5)
xlim([0 20])
hold on;
legend('Hanning','Gaussian','Kaiser','4T1','Fontsize',14,'TextColor','black')
legend('boxoff')
hold off;
%% normalized amplitude graphs
figure(2);
zoom=40;
f2=2*f;
plot(f2(1,1:floor(len/zoom)),h1(1:floor(len/zoom),1),'g--square','LineWidth',1.5)
% xlim([0 16])
grid minor;
hold on;
plot(f2(1,1:floor(len/zoom)),h2(1:floor(len/zoom),1),'b--diamond','LineWidth',1.5)
plot(f2(1,1:floor(len/zoom)),h3(1:floor(len/zoom),1),'r-->','LineWidth',1.5)
plot(f2(1,1:floor(len/zoom)),h4(1:floor(len/zoom),1),'c--pentagram','LineWidth',1.5)
hold off;
ylabel('Main lobe normalized amplitude','Fontsize',16)
xlabel('| Normalised frequency |','FontSize',16)
legend('Hanning','Gaussian','Kaiser','4T1','Fontsize',12,'TextColor','black')
title('Magnitude Main Lobes')
legend('boxoff')
% hold off;
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%  END  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%