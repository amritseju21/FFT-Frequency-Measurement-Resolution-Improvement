%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Description: DSP Project (Main Algo. Code for testing using test wrapper for algo evaluation)
%% Developers: Pramod Kumar (Sr.No.: 24997), Amrit Lal (Sr.No.: 24608) 
%% M.Tech (SP) 2024-26  IISc Bangalore
%% Start Date: 11/10/2024
%% Code Status: Completed
%% Remarks: Nil
%% Start funtion
function DSP_Interpolation(fs,SNR,N_fft,freq_start,freq_end,freq_step,j,Noise)
    T = 1;                  % Duration (s)
    A = 1;                  % Amplitude of the sine wave
    % Time vector
    t = 0:1/fs:T-1/fs;

    % Frequency vector for FFT output
    f = fs * (0:(N_fft/2)) / N_fft;
    
    % Initialize arrays for storing true and estimated frequencies
    true_frequencies = freq_start:freq_step:freq_end;
    estimated_frequencies = zeros(size(true_frequencies));
    estimated_frequencies_int = zeros(size(true_frequencies));
    estimated_frequencies_int2 = zeros(size(true_frequencies));
    
    % Loop through each frequency in the sweep
    for idx = 1:length(true_frequencies)
        f_sine = true_frequencies(idx);     % Current frequency in sweep
        
        % Generate sinewave
        signal = A * sin(2 * pi * f_sine * t);
        
        % Add AWGN
         if Noise==1
             noisy_signal = signal; %for test case 1
         elseif Noise==2
             noisy_signal = awgn(signal, SNR, 'measured');
         end
             
        if j==1
            window =hanning(N_fft,'periodic'); % Generate Hanning window with parameter periodic
        elseif j==2
            window = gausswin(N_fft, 8);   % Generate Gaussian window with parameter alpha=8
        elseif j==3
            window = kaiser(N_fft,7);  % Generate Kaiser window with parameter r=7
        elseif j==4
            window  = cosine_window(N_fft); % Generate Cosine window with parameter 4T1
        end
       
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
            disp('Parabolic and Gaussian Interpolation condition is Not saisfied...')
            estimated_frequencies_int(idx) = 0;
        end
    end
    
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
    fprintf('\n\nEvaluation Freqency Range is: %.2f Hz, to %.2f Hz with sweep step size of %.2f Hz\n', freq_start, freq_end, freq_step);
    if Noise==2
        fprintf('SNR(dB) : %.2f\n',SNR);
    end
    fprintf('Window Index: %.d and Noise Index : %.d\n', j,Noise);
    fprintf('Fs: %.2f Hz\n', fs);
    fprintf('NFFT : %d \n', N_fft);
    fprintf('Bin Size: %.4f Hz\n', fs/N_fft);
    fprintf('RMS Error of Frequency Estimation: %.2f Hz\n', rms_error);
    fprintf('RMS Error of Parabolic Interpolated Frequency Estimation: %.2f Hz\n', rms_error1);
    fprintf('RMS Error of Gaussian Interpolated Frequency Estimation: %.2f Hz\n', rms_error2);
    
    % Plot frequency estimation error
    figure(1);
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
    
    % % % Plot frequency estimation error
    % % figure(2);
    % % hold on;
    % % plot(window, 'r',LineWidth=2);
    % % xlabel('Window Index');
    % % ylabel('Window Weights');
    % % title('Windowing function (Prior to FFT)');
    % % grid minor;
end
