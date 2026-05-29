%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Description: DSP Project (RMS)
%% Developers: Pramod Kumar (Sr.No.: 24997), Amrit Lal (Sr.No.: 24608) 
%% M.Tech (SP) 2024-26  IISc Bangalore
%% Start Date: 11/10/2024
%% Code Status: Completed
%% Remarks: Nil
%% Start Code
clc;clear all;close all;
% Parameters
fs = 1000;                  % Sampling frequency (Hz)
T = 1;                      % Duration (s)
A = 1;                      % Amplitude of the sine wave
SNR = 20;                   % Signal-to-noise ratio (dB)
N_fft = 1000;                % Number of points for FFT
freq_under_analysis=100 * fs / N_fft ;
freq_start = freq_under_analysis- fs / (2 * N_fft);  % Start frequency of the sweep (Hz)
freq_end = freq_under_analysis + fs / (2 * N_fft);    % End frequency of the sweep (Hz)
freq_step = 0.02;            % Step size for frequency sweep (Hz)
% Window types
window_types = {'hanning', 'gausswin', 'kaiser', 'cosine'};

%Initial plot conditions
figure(1);hold on;
figure(2);hold on;
figure(3);hold on;
figure(4);hold on;
colors = {'--gsquare','--bdiamond','--r>','--k.'};
colors2 = {'--g.','--b.','--r.','--k.'};
% Time vector
t = 0:1/fs:T-1/fs;

% Frequency vector for FFT output
f = fs * (0:(N_fft/2)) / N_fft;

% Initialize arrays for storing true and estimated frequencies
true_frequencies = freq_start+0.02:freq_step:freq_end-0.02;
estimated_frequencies = zeros(size(true_frequencies));
estimated_frequencies_int = zeros(size(true_frequencies));
estimated_frequencies_int2 = zeros(size(true_frequencies));

% Apply Window using inbuilt/generated functions
for j=1:4
    if j==1
        % N = length(noisy_signal);           % Number of samples
        % window = rectwin(N_fft);
        window =hanning(N_fft,'periodic'); % Generate Hanning window with parameter periodic
    elseif j==2
        window = gausswin(N_fft, 8);   % Generate Gaussian window with parameter alpha=8
    elseif j==3
        window = kaiser(N_fft,7);  % Generate Kaiser window with parameter r=7
    elseif j==4
        window  = cosine_window(N_fft); % Generate Cosine window with parameter 4T1
    end
    % Loop through each frequency in the sweep        
    for idx = 1:length(true_frequencies)
        f_sine = true_frequencies(idx);     % Current frequency in sweep
    
        % Generate sinewave
        signal = A * sin(2 * pi * f_sine * t);
    
        % Add AWGN
        noisy_signal = awgn(signal, SNR, 'measured');
    
    
        % Apply window to the signal
        windowed_signal = noisy_signal(1:N_fft) .* window';
    
        % FFT of the windowed signal with N_fft points
        Y = fft(windowed_signal, N_fft);
        Y = abs(Y / N_fft);                     % Normalize the FFT output
        Y = Y(1:N_fft/2+1);                     % Single-sided spectrum
        Y(2:end-1) = 2 * Y(2:end-1);            % Double amplitude for single-sided
    
        % Convert to decibel scale
        Y_dB = 20 * log10(Y);
    
     
        % Estimate the frequency by finding the peak
        [~, peak_idx] = max(Y);
        estimated_frequencies(idx) = f(peak_idx);

        % Parabolic and gaussian interpolation
        if 2*Y(peak_idx)>Y(peak_idx+1)+Y(peak_idx-1)
            fprintf('Parabolic and Gaussian Interpolation condition is saisfied for %.2f Hz\n', f_sine);
            % Parabolic interpolation
            delta=(Y(peak_idx+1)- Y(peak_idx-1))/(2*(2*Y(peak_idx)-Y(peak_idx+1)-Y(peak_idx-1)));
            peak_idx_int=peak_idx+delta;
            estimated_frequencies_int(idx) = fs*(peak_idx_int-1)/N_fft;
            % fprintf('Parabolic and Gaussian Interpolation condition is saisfied for %.2f Hz\n', f_sine);
            
            % Gaussian interpolation
            delta2=log(Y(peak_idx+1)/Y(peak_idx-1))/(2*log((Y(peak_idx)^2)/(Y(peak_idx+1)*Y(peak_idx-1))));
            peak_idx_int2=peak_idx+delta2;
            estimated_frequencies_int2(idx) = fs*(peak_idx_int2-1)/N_fft;
        else
            disp('Parabolic Interpolation condition is Not saisfied...')
            estimated_frequencies_int(idx) = 0;
            estimated_frequencies_int2(idx) = 0;
        end
    end
% Labeling the plot
% figure(1);
% xlabel('Frequency (Hz)');
% ylabel('Magnitude (dB)');
% title('Magnitude Spectrum of Windowed Noisy Signal (dB Scale) for Frequency Sweep');
% legend;

% Calculate RMS error
frequency_errors = true_frequencies - estimated_frequencies;
rms_error = sqrt(mean(frequency_errors.^2));

% Calculate RMS error for interpolated peak in case of parabolic
frequency_errors1 = true_frequencies - estimated_frequencies_int;
rms_error1 = sqrt(mean(frequency_errors1.^2));

% Calculate RMS error for interpolated peak in case of gaussian
frequency_errors2 = true_frequencies - estimated_frequencies_int2;
rms_error2 = sqrt(mean(frequency_errors2.^2));

% Display RMS error value
fprintf('RMS Error of Frequency Estimation: %.2f Hz\n', rms_error);
fprintf('RMS Error of Interpolated Frequency Estimation: %.2f Hz\n', rms_error1);
fprintf('Bin Size: %.4f Hz\n', fs/N_fft);

% Plot frequency estimation error for normal FFT
figure(1);
% analysis freq is normalized to correlate results with paper results %pramod
plot(true_frequencies-freq_under_analysis,  abs(frequency_errors), colors{j}, 'DisplayName', sprintf('%s (Parabolic Interpolation)', window_types{j}), 'LineWidth', 1);
xlabel('True Frequency (Hz)');
ylabel('Absolute Frequency Estimation Error (Hz)');
title('Frequency Estimation Error Across Frequency Sweep for SNR 20dB (Normal FFT)');

% Plot frequency estimation error for parabolic
figure(2);
plot(true_frequencies-freq_under_analysis,  abs(frequency_errors1), colors{j}, 'DisplayName', sprintf('%s (Parabolic Interpolation)', window_types{j}), 'LineWidth', 1);
xlabel('True Frequency (Hz)');
ylabel('Absolute Frequency Estimation Error (Hz)');
title('Frequency Estimation Error Across Frequency Sweep for SNR 20dB (Parabolic Interpolation)');


% Plot frequency estimation error for gaussian
figure(3);
plot(true_frequencies-freq_under_analysis,  abs(frequency_errors2), colors{j}, 'DisplayName', sprintf('%s (Gaussian Interpolation)', window_types{j}), 'LineWidth', 1);
xlabel('True Frequency (Hz)');
ylabel('Absolute Frequency Estimation Error (Hz)');
title('Frequency Estimation Error Across Frequency Sweep for SNR 20dB (Gaussian Interpolation)');


% Windows plots
figure(4);
plot(window, colors2{j});
xlabel('Window Index');
ylabel('Window Weights');
title('Windowing function (Prior to FFT)');
end
figure (1);
legend('Hannaing Window','Gaussian Window','Kaiser window','Cosine window');
grid minor;
figure (2);
legend('Hannaing Window','Gaussian Window','Kaiser window','Cosine window');
grid minor;
figure (3);
legend('Hannaing Window','Gaussian Window','Kaiser window','Cosine window');
grid minor;
figure (4);
legend('Hannaing Window','Gaussian Window','Kaiser window','Cosine window');
grid minor;