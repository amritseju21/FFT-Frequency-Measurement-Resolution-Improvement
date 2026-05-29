%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Description: DSP Project (Main Algo. Code for testing using test wrapper for algo evaluation)
%% Developers: Pramod Kumar (Sr.No.: 24997), Amrit Lal (Sr.No.: 24608) 
%% M.Tech (SP) 2024-26  IISc Bangalore
%% Start Date: 11/10/2024
%% Code Status: Completed
%% Remarks: Windowing option 1. hanning 2. gausswin 3. kaiser 4.cosine 4T1
%% Noise option: 1. without AWGN 2. with specified AWGN
%% Start Code
clc;clear all;close all;
%% Test Case 1: 200X4=800 Test Signals (Sweeping signal Frequency without noise)
for win =1:4
    fs = 1000;              % Sampling frequency (Hz)
    SNR = 20;               % Signal-to-noise ratio (dB)
    N_fft = 512;            % Number of points for FFT
    freq_start = 100;        % Start frequency of the sweep (Hz)
    freq_end = 110;         % End frequency of the sweep (Hz)
    freq_step = 0.05;         % Step size for frequency sweep (Hz)
    % win=2;
    Noise=1; %1 for without noise
    DSP_Interpolation(fs,SNR,N_fft,freq_start,freq_end,freq_step,win,Noise)
    input('Press Enter to continue...','s');
end

%% Test Case 2: 4x100x4=1600 Test Signals (Sweeping signal Frequency with noise)
SNR_val = [20, 10, 6, 3]; % Signal-to-noise ratio (dB)
Noise=2; %1 for without noise, 2 for with AWGN 
for win =1:4
    for SNR = SNR_val
        fs = 1000;              % Sampling frequency (Hz)
        N_fft = 512;            % Number of points for FFT
        freq_start = 100;        % Start frequency of the sweep (Hz)
        freq_end = 105;         % End frequency of the sweep (Hz)
        freq_step = 0.05;         % Step size for frequency sweep (Hz)
        DSP_Interpolation(fs,SNR,N_fft,freq_start,freq_end,freq_step,win,Noise)
        input('Press Enter to continue...','s');
    end
end
%% Test Case 3: 100x4x3=1200 Test Signals (Sweeping signal Frequency with noise)
N_fft_val = [128, 256, 512]; % Signal-to-noise ratio (dB)
for win =1:4
    for N_fft = N_fft_val   % Number of points for FFT
        fs = 1000;              % Sampling frequency (Hz)
        SNR = 20;               % Signal-to-noise ratio (dB)
        freq_start = 100;        % Start frequency of the sweep (Hz)
        freq_end = 120;         % End frequency of the sweep (Hz)
        freq_step = 0.1;         % Step size for frequency sweep (Hz)
        % win=2;
        Noise=2; %1 for with noise
        DSP_Interpolation(fs,SNR,N_fft,freq_start,freq_end,freq_step,win,Noise)
        input('Press Enter to continue...','s');
    end
end

%% Test Case 4: 60x2x5=600 Test Signals (Sweeping second signal values near
% to primary signal with 0.7 amplitude)
freq2_values = [104, 105, 106, 107, 108, 118]; % Second signal
Noise=2; %1 for without noise, 2 for with AWGN 
for win =1:2
    for freq2 = freq2_values
        fs = 1000;              % Sampling frequency (Hz)
        SNR = 20;               % Signal-to-noise ratio (dB)
        N_fft = 512;            % Number of points for FFT
        freq_start = 100;        % Start frequency of the sweep (Hz)
        freq_end = 103;         % End frequency of the sweep (Hz)
        freq_step = 0.05;         % Step size for frequency sweep (Hz)
        DSP_Interpolation2(fs,SNR,N_fft,freq_start,freq_end,freq_step,win,Noise,freq2)
        input('Press Enter to continue...','s');
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 