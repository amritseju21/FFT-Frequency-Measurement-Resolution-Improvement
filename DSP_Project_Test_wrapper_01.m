%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Description: DSP Project (Wrapper Code)
%% Developer/s: Pramod Kumar (Sr.No.: 24997), Amrit Lal (Sr.No.: 24608) 
%% M.Tech (SP) 2024-26  IISc Bangalore
%% Start Date: 11/10/2024
%% Code Status: Completed
%% Remarks: Nil
%% Start Code
% This script serves as a wrapper to run code1 to code4 sequentially.

disp('Running code1 Magnitude Spectrum of Four Windows...');
run('DSP_Project_windows.m');  % Runs the first code
disp('Finished code1.');

%% Wait for user to press Enter before continuing
input('Press Enter to run code2...','s');

disp('Running code2 Improvement in FFT based freq. estimation using Parabolic and Gaussian interpolation...');
run('DSP_Project_FFT.m');  % Runs the second code
disp('Finished code2.');

%% Wait for user to press Enter before continuing
input('Press Enter to run code3...','s');

disp('Running code3 Percentage error analysis for Parabolic and Gaussian Interpolation in ref. of Four windows ...');
run('DSP_Project_PercentageError.m');  % Runs the second code
disp('Finished code3.');

%% Wait for user to press Enter before continuing
input('Press Enter to run code4...','s');

disp('Running code4 R.M.S. error analysis for Parabolic and Gaussian Interpolation in ref. of Four windows ...');
run('DSP_Project_RMSError.m');  % Runs the second code
disp('Finished code4.');
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%  END  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%