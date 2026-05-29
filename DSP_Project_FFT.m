%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Description: DSP Project (Second Module of frequency resolution 
%% improvement for using parabolic and gaussian interpolation)
%% Developers: Pramod Kumar (Sr.No.: 24997), Amrit Lal (Sr.No.: 24608) 
%% M.Tech (SP) 2024-26  IISc Bangalore
%% Start Date: 11/10/2024
%% Code Status: Completed
%% Remarks: Nil
%% Start Code
clc;clear all;close all;
% Parameters
fs = 1000;              % Sampling frequency (Hz)
T = 1;                  % Duration (s)
A = 1;                  % Amplitude of the sine wave
SNR = 20;               % Signal-to-noise ratio (dB)
N_fft = 512;            % Number of points for FFT
freq_start = 100;        % Start frequency of the sweep (Hz)
freq_end = 200;         % End frequency of the sweep (Hz)
freq_step = 10;         % Step size for frequency sweep (Hz)

% Time vector
t = 0:1/fs:T-1/fs;

% Frequency vector for FFT output
f = fs * (0:(N_fft/2)) / N_fft;

% Initialize arrays for storing true and estimated frequencies
true_frequencies = freq_start:freq_step:freq_end;
estimated_frequencies = zeros(size(true_frequencies));
estimated_frequencies_int = zeros(size(true_frequencies));
estimated_frequencies_int2 = zeros(size(true_frequencies));

figure(1);
hold on;
grid minor;

% Loop through each frequency in the sweep
for idx = 1:length(true_frequencies)
    f_sine = true_frequencies(idx);     % Current frequency in sweep
    
    % Generate sinewave
    signal = A * sin(2 * pi * f_sine * t);
    
    % Add AWGN
    noisy_signal = awgn(signal, SNR, 'measured');
    
    % Apply Window using inbuilt/generated functions
    % N = length(noisy_signal);           % Number of samples
    % window = rectwin(N_fft);
    % window =hanning(N_fft,'periodic'); % Generate Hanning window with parameter periodic
    window = gausswin(N_fft, 8);   % Generate Gaussian window with parameter alpha=8
    % window = kaiser(N_fft,7);  % Generate Kaiser window with parameter r=7
     % window  = cosine_window(N_fft); % Generate Cosine window with parameter 4T1
         
     % Apply window to the signal
    windowed_signal = noisy_signal(1:N_fft) .* window';
    
    % FFT of the windowed signal with N_fft points
    Y = fft(windowed_signal, N_fft);
    Y = abs(Y / N_fft);                     % Normalize the FFT output
    Y = Y(1:N_fft/2+1);                     % Single-sided spectrum
    Y(2:end-1) = 2 * Y(2:end-1);            % Double amplitude for single-sided
    
    % Convert to decibel scale
    Y_dB = 20 * log10(Y);
    
    % Plot the FFT in dB scale for each frequency in the sweep
    figure(1);
    plot(f, Y_dB, 'DisplayName', sprintf('%d Hz', f_sine));
    
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
        disp('Parabolic and Gaussian Interpolation condition is Not saisfied...')
        estimated_frequencies_int(idx) = 0;
    end
end
% Labeling the plot
figure(1);
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title('Magnitude Spectrum of Windowed Noisy Signal (dB Scale) for Frequency Sweep');
legend;
hold off;

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
fprintf('Bin Size: %.4f Hz\n', fs/N_fft);
fprintf('RMS Error of Frequency Estimation: %.2f Hz\n', rms_error);
fprintf('RMS Error of Parabolic Interpolated Frequency Estimation: %.2f Hz\n', rms_error1);
fprintf('RMS Error of Gaussian Interpolated Frequency Estimation: %.2f Hz\n', rms_error2);

% Plot frequency estimation error
figure(2);
hold on;
plot(true_frequencies, abs(frequency_errors), '-ro',LineWidth=2);
plot(true_frequencies, abs(frequency_errors1), '-b^',LineWidth=2);
plot(true_frequencies, abs(frequency_errors2), '-g^',LineWidth=2);
xlabel('True Frequency (Hz)');
ylabel('Absolute Frequency Estimation Error (Hz)');
title('Frequency Estimation Error Across Frequency Sweep');
grid minor;
legend('FFT Estimation','FFT Parabolic Interpolation','FFT Parabolic Gaussian' );
hold off;

% Plot frequency estimation error
figure(3);
plot(window, 'r',LineWidth=2);
xlabel('Window Index');
ylabel('Window Weights');
title('Windowing function (Prior to FFT)');
grid minor;
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%  END  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%