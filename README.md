# Improving FFT Frequency Measurement Resolution by Parabolic and Gaussian Spectrum Interpolation

## Digital Signal Processing (E9 201)

### Indian Institute of Science (IISc), Bangalore

---

## Project Team

* Amrit Lal (M.Tech Signal Processing, IISc Bangalore)
* Pramod Kumar (M.Tech Signal Processing, IISc Bangalore)

### Project Mentors

* Prof. Soma Biswas
* Prof. Prasanta Kumar Ghosh

---

## Project Overview

Fast Fourier Transform (FFT) is widely used for frequency estimation in applications such as radar, sonar, LiDAR, telecommunications, medical imaging, and meteorology.

A major limitation of FFT-based frequency estimation is the finite frequency resolution determined by:

Δf = Fs / NFFT

When the actual signal frequency lies between FFT bins, significant estimation errors can occur.

This project investigates two spectrum interpolation techniques:

1. Parabolic Spectrum Interpolation
2. Gaussian Spectrum Interpolation

to improve frequency estimation accuracy beyond FFT-bin resolution.

---

## Objectives

* Study FFT-based frequency estimation.
* Analyze spectral leakage using different window functions.
* Implement Parabolic Interpolation.
* Implement Gaussian Interpolation.
* Compare frequency estimation accuracy.
* Evaluate RMS and percentage error performance.

---

## Implemented Window Functions

* Hanning Window
* Gaussian Window
* Kaiser Window
* Cosine 4T1 Window

---

## MATLAB Modules

### Window Analysis

* DSP_Project_windows.m
* cosine_window.m

Analyzes magnitude spectra and main-lobe characteristics of various window functions.

### FFT Frequency Estimation

* DSP_Project_FFT.m

Performs FFT-based frequency estimation.

### Interpolation Techniques

* DSP_Interpolation.m
* DSP_Interpolation2.m

Implements:

* Parabolic Interpolation
* Gaussian Interpolation

for sub-bin frequency estimation.

### Error Analysis

* DSP_Project_PercentageError.m
* DSP_Project_RMSError.m

Computes:

* Percentage Frequency Error
* RMS Frequency Error

---

## Methodology

1. Generate sinusoidal signals.
2. Add AWGN noise.
3. Apply windowing.
4. Compute FFT spectrum.
5. Detect spectral peak.
6. Apply interpolation techniques.
7. Estimate frequency.
8. Compare estimation errors.

---

## Experimental Setup

### Test Case 1

* 800 test signals
* Frequency sweep without noise
* Four window types

### Test Case 2

* 1600 test signals
* SNR = 3, 6, 10, 20 dB
* Frequency sweep with noise

### Test Case 3

* NFFT = 128, 256, 512
* Frequency sweep with noise

### Test Case 4

* Two-tone frequency estimation
* Interference signal with 0.7 amplitude
* Hanning and Gaussian windows

---

## Key Results

### Frequency Resolution Improvement

Gaussian and Parabolic interpolation significantly reduce FFT estimation error.

### Best Interpolation Method

Gaussian interpolation generally provides better accuracy than Parabolic interpolation.

### Best Window Function

Gaussian window performs best under ideal conditions.

Hanning window provides more robust performance across different scenarios.

---

## Technologies Used

* MATLAB
* Signal Processing Toolbox
* FFT Analysis
* Spectral Interpolation Techniques

---

## Institution

Department of Electrical Engineering

Indian Institute of Science (IISc), Bangalore

2024
