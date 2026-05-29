%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Description: DSP Project (Third Module of percentage error analysis for 
%% improvement using parabolic and gaussian interpolation for vasious 
%% windowing operations)
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

% Time vector
t = 0:1/fs:T-1/fs;
% Frequency vector for FFT output
f = fs * (0:(N_fft/2)) / N_fft;

% Initialize arrays for storing true and estimated frequencies
true_frequencies = freq_start+0.02:freq_step:freq_end-0.02;
estimated_frequencies = zeros(size(true_frequencies));
estimated_frequencies_int = zeros(size(true_frequencies));
estimated_frequencies_int2 = zeros(size(true_frequencies));

% Window types
window_types = {'hanning', 'gausswin', 'kaiser', 'cosine'};

%Initial plot conditions
figure(1);hold on;
figure(2);hold on;
figure(3);hold on;
figure(4);hold on;
colors = {'--gsquare','--bdiamond','--r>','--k.'};
colors2 = {'--g.','--b.','--r.','--k.'};
% Loop for different window types
for j = 1:4
    % Select window function
    switch window_types{j}
        case 'hanning'
            window = hanning(N_fft, 'periodic');
        case 'gausswin'
            window = gausswin(N_fft, 8);
        case 'kaiser'
            window = kaiser(N_fft, 7);
        case 'cosine'
           window  = cosine_window(N_fft); % Generate Cosine window with parameter 4T1
    end
    
    % Loop through each frequency in the sweep
    for idx = 1:length(true_frequencies)
        f_sine = true_frequencies(idx);     % Current frequency in sweep
        
        % Generate sinewave
        signal = A * sin(2 * pi * f_sine * t);
        
        % Add AWGN
        % noisy_signal = awgn(signal, SNR, 'measured');% AWGN by-passed for results study similar to paper resutls 
        noisy_signal = signal;
        
        % Apply window to the signal
        windowed_signal = noisy_signal(1:N_fft) .* window';
        
        % FFT of the windowed signal with N_fft points
        Y = fft(windowed_signal, N_fft);
        Y = abs(Y / N_fft);                     % Normalize the FFT output
        Y = Y(1:N_fft/2+1);                     % Single-sided spectrum
        Y(2:end-1) = 2 * Y(2:end-1);            % Double amplitude for single-sided
        
        % Estimate the frequency by finding the peak
        [~, peak_idx] = max(Y);
        estimated_frequencies(idx) = f(peak_idx);
        
        % Parabolic and Gaussian interpolation
        if 2 * Y(peak_idx) > Y(peak_idx + 1) + Y(peak_idx - 1)
            % Parabolic interpolation
            delta = (Y(peak_idx + 1) - Y(peak_idx - 1)) / (2 * (2 * Y(peak_idx) - Y(peak_idx + 1) - Y(peak_idx - 1)));
            peak_idx_int = peak_idx + delta;
            estimated_frequencies_int(idx) = fs * (peak_idx_int - 1) / N_fft;
            
            % Gaussian interpolation
            delta2 = log(Y(peak_idx + 1) / Y(peak_idx - 1)) / (2 * log((Y(peak_idx)^2) / (Y(peak_idx + 1) * Y(peak_idx - 1))));
            peak_idx_int2 = peak_idx + delta2;
            estimated_frequencies_int2(idx) = fs * (peak_idx_int2 - 1) / N_fft;
        else
            estimated_frequencies_int(idx) = 0;
            estimated_frequencies_int2(idx) = 0;
        end
    end
    
    % Calculate signed percentage error
    % signed_percentage_error = ((estimated_frequencies - true_frequencies) ./ true_frequencies) * 100;
    % signed_percentage_error_int = ((estimated_frequencies_int - true_frequencies) ./ true_frequencies) * 100;
    % signed_percentage_error_int2 = ((estimated_frequencies_int2 - true_frequencies) ./ true_frequencies) * 100;
    signed_percentage_error = ((estimated_frequencies - true_frequencies)) * 100;
    signed_percentage_error_int = ((estimated_frequencies_int - true_frequencies) ) * 100;
    signed_percentage_error_int2 = ((estimated_frequencies_int2 - true_frequencies)) * 100;
    
    % Plot signed percentage error for FFT peak estimation
    figure(1);
    hold on;
    plot(true_frequencies-freq_under_analysis, signed_percentage_error,colors{j}, 'DisplayName', sprintf('%s (FFT Peak)', window_types{j}), 'LineWidth', 1);
   
    
    % Plot signed percentage error for parabolic interpolation
    figure(2);
    hold on;
    plot(true_frequencies-freq_under_analysis, signed_percentage_error_int, colors{j}, 'DisplayName', sprintf('%s (Parabolic Interpolation)', window_types{j}), 'LineWidth', 1);
  
    
    % Plot signed percentage error for Gaussian interpolation
    figure(3);
    hold on;
    plot(true_frequencies-freq_under_analysis, signed_percentage_error_int2, colors{j}, 'DisplayName', sprintf('%s (Gaussian Interpolation)', window_types{j}), 'LineWidth', 1);
  
    % Plot the window function
    figure(4);
    plot(window,colors2{j},'LineWidth', 1.5, 'DisplayName', sprintf('%s Window', window_types{j}));
   
end

% Finalize plots with legends and grids
figure(1); legend; grid minor;
xlabel('True Frequency (Hz)');
ylabel('Signed Percentage Frequency Estimation Error (%)');
title('Signed Frequency Estimation Error Across Frequency Sweep (FFT Peak)');
% ylim([-1 1]);
hold off;
figure(2); legend; grid minor;
xlabel('True Frequency (Hz)');
ylabel('Signed Percentage Frequency Estimation Error (%)');
title('Signed Frequency Estimation Error Across Frequency Sweep (Parabolic Interpolation)');
% ylim([-0.1 0.1]);
% ylim([-0.08 0.08]);
hold off;
figure(3); legend; grid minor;
xlabel('True Frequency (Hz)');
ylabel('Signed Percentage Frequency Estimation Error (%)');
title('Signed Frequency Estimation Error Across Frequency Sweep (Gaussian Interpolation)');
% ylim([-0.1 0.1]);
% ylim([-0.02 0.02]);
hold off;
figure(4); legend; grid minor;
xlabel('Window Index');
ylabel('Window Weights');
title('Windowing Function (Prior to FFT)');
hold off;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% End of the Code %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%