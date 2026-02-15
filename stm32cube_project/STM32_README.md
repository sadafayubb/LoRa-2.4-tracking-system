# STM32CubeIDE Project - SX1280 Firmware

## Status: Incomplete / Not Functional

This directory contains an incomplete STM32CubeIDE project for SX1280 LoRa ranging firmware.

## Issue

The project was developed using Semtech's SX1280 custom library to flash development boards with `main.c` for ranging functionality. However, a **calibration register issue** prevented ranging from working properly.

## Current State

- Library and project structure are set up
- Code does not fully work due to calibration register problems
- **All measurements used in this thesis were obtained from pre-programmed modules with working firmware**, not from this project
- If you wish to use this project as starting point, rememeber to configure the build paths to the SX1280 library.

## Alternative Approach

Instead of debugging the firmware, pre-programmed SX1280 modules with functional ranging capabilities were used for all testing and data collection. The MATLAB analysis scripts in this repository process measurements from these working modules.

## Contents

- `Core/` - Main application code
- `Drivers/` - STM32 HAL and SX1280 library drivers
- `Inc/` - Header files
- `Src/` - Source files

## Note

This project is included for completeness and transparency. The focus of this thesis is on the ranging analysis, calibration methodology, and position estimation algorithms implemented in MATLAB, not on firmware development.
