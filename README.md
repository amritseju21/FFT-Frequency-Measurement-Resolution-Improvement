# Improving FFT Frequency Measurement Resolution by Parabolic and Gaussian Spectrum Interpolation

## Digital Signal Processing (E9 201)

### Indian Institute of Science (IISc), Bangalore

### Team Members

* Amrit Seju
* Pramod

---

## Project Overview

The Fast Fourier Transform (FFT) is one of the most widely used tools for frequency-domain analysis. However, the frequency resolution of an FFT is limited by the FFT size and sampling frequency. When the actual signal frequency lies between FFT bins, direct peak detection can lead to estimation errors.

This project investigates two spectral interpolation techniques:

1. Parabolic Spectrum Interpolation
2. Gaussian Spectrum Interpolation

These methods estimate the true frequency more accurately by interpolating around the FFT peak.

---

## Objectives

* Perform FFT-based spectral analysis.
* Study the effect of different window functions.
* Improve frequency estimation accuracy beyond FFT-bin resolution.
* Implement parabolic interpolation.
* Implement Gaussian interpolation.
* Compare estimation errors using RMS and percentage error metrics.

---

## Methodology

### Step 1: Signal Generation

A sinusoidal signal of known frequency is generated.

### Step 2: Windowing

Different window functions are applied to reduce spectral leakage.

Examples:

* Cosine Window
* Hamming Window
* Hann Window

### Step 3: FFT Computation

The FFT of the windowed signal is calculated.

### Step 4: Peak Detection

The FFT bin corresponding to the maximum spectral magnitude is identified.

### Step 5: Spectrum Interpolation

The neighboring FFT bins are used to estimate the true frequency.

#### Parabolic Interpolation

A quadratic curve is fitted around the FFT peak to estimate the actual frequency location.

#### Gaussian Interpolation

A Gaussian curve is fitted around the FFT peak to obtain a more accurate frequency estimate.

### Step 6: Error Analysis

The estimated frequency is compared with the actual signal frequency.

Metrics:

* RMS Error
* Percentage Error

---

## MATLAB Files

| File                          | Description                  |
| ----------------------------- | ---------------------------- |
| DSP_Project_FFT.m             | FFT computation              |
| DSP_Interpolation.m           | Parabolic interpolation      |
| DSP_Interpolation2.m          | Gaussian interpolation       |
| DSP_Project_windows.m         | Window function analysis     |
| DSP_Project_RMSError.m        | RMS error calculation        |
| DSP_Project_PercentageError.m | Percentage error calculation |
| DSP_Project_Test_wrapper_01.m | Test script                  |
| DSP_Project_Test_wrapper_02.m | Test script                  |
| cosine_window.m               | Cosine window implementation |

---

## Results

The interpolation techniques significantly improve frequency estimation accuracy compared to direct FFT peak detection.

Gaussian interpolation generally provides the highest estimation accuracy, particularly for frequencies located between FFT bins.

---

## Software Used

* MATLAB

---

## Institution

Department of Electrical Engineering

Indian Institute of Science (IISc), Bangalore
