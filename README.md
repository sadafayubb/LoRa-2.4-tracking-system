# LoRa 2.4 GHz Tracking System

This project wishes to build a 2D position estimation system using Semtech SX1280 LoRa ranging software, and through Direct Linear Solve (DLS) and Least Squares (LSQ) trilerations algorithms.

## Overview

This repository contains the complete implementation and analysis for a LoRa 2.4 GHz based outdoor-positioning system. The system uses ranging measurements from three anchor nodes to estimate the position of a node through trilateration.

**Key Features:**
- Parameter optimization (Spreading Factor, Bandwidth, Code Rate)
- Polynomial calibration with lookup tables (LUT)
- Two trilateration methods: Direct Linear Solve (DLS) and Least Squares (LSQ)
- Comprehensive error analysis with DRMS metrics
- 95% confidence ellipses for uncertainty quantification

## Repository Structure

```
LoRa-2.4-tracking-system/
├── README.md                    # This file
├── matlab/                      # Analysis scripts
│   ├── README.md               # Detailed MATLAB documentation
│   ├── run_all.m               # Master script - runs all analyses
│   ├── opti_test_*.m           # Optimization tests
│   ├── req_test.m              # Request/exchange tests
│   ├── cali_test_*.m           # Calibration tests
│   └── pos_test_*.m            # Position estimation tests
├── data/                        # Raw measurement data
│   └── sx1280_test_data.xlsx   # All test measurements
├── figures/                     # Generated plots (JPG)
│   ├── optiTest/               # Optimization test results
│   ├── reqTest/                # Request test results
│   ├── caliTest/               # Calibration results
│   └── posTest/                # Position estimation results
├── lut/                         # Calibration lookup tables
│   ├── lut_cr45.txt            # CR 4/5 coefficients
│   ├── lut_cr48.txt            # CR 4/8 coefficients
│   ├── calibration_lut_cr45.mat
│   └── calibration_lut_cr48.mat
└── stm32cube_project/           # STM32CubeIDE firmware (incomplete)
    ├── Core/
    ├── Drivers/
    └── README.md
```

## Quick Start

### Prerequisites

**MATLAB Requirements:**
- MATLAB R2020a or later
- Statistics and Machine Learning Toolbox
- Optimization Toolbox

### Running the Analysis

1. Place `sx1280_test_data.xlsx` in the `data/` folder
2. Open MATLAB and navigate to the `matlab/` folder
3. Run all analyses:

```matlab
run_all
```

Or run individual test categories:

```matlab
% Optimization tests
run_opti_tests

% Calibration and position estimation
cali_test_fit2()        % Generate LUT
pos_test_dls_cal()      % Position estimation with calibration
```

See `matlab/README.md` for detailed usage instructions.

## Test Categories

### 1. Optimization Tests (`OptiTest1`, `OptiTest2`)
- Test various SF (5-10) and BW (800, 1600 kHz) combinations
- Two antenna heights: 35cm and 110cm
- Generates 3D error plots and confidence intervals

### 2. Request Tests (`ReqTest`)
- Evaluates impact of number of ranging exchanges (1-10)
- Tests at 50m, 100m, 150m distances
- Plots MAE vs. number of exchanges

### 3. Calibration Tests (`CaliTest1`, `CaliTest2`)
- Polynomial fitting (degree 6) to measured vs. true distance
- Two coding rates: CR 4/5 and CR 4/8
- Generates lookup tables for distance correction

### 4. Position Estimation Tests (`PosTest`)
- Direct Linear Solve (DLS) and Least Squares (LSQ) methods
- With and without calibration
- Calculates DRMS error and 95% confidence ellipses

## Results

All figures are automatically saved to `figures/` organized by test category. Calibration LUTs are saved to `lut/` in both human-readable (.txt) and MATLAB (.mat) formats.

## Hardware

- **SX1280 LoRa modules** - 2.4 GHz ranging-capable transceivers
- **Anchor configuration:** 3 fixed nodes at positions (0,0), (0,100), (62,0) meters
- **Distance tracking** A way to record distances, either GPS or physical meter-tape.
- **Note:** The STM32CubeIDE project is incomplete due to calibration register issues with the custom library. 

## Citation

This repository accompanies my bachelor thesis on LoRa-based indoor positioning:

**Ayub, S. (2025). *LoRa based Time-of-Flight Tracking system.* DTU Department of Electrical and Photonics Engineering.**

**BibTeX:**
```bibtex
@thesis{ayub2025a,
  author = {Ayub, Sadaf},
  title = {LoRa based Time-of-Flight Tracking system},
  language = {und},
  format = {thesis},
  year = {2025},
  publisher = {DTU Department of Electrical and Photonics Engineering}
}
```

If you build upon this work, please cite the thesis and link to this repository.

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Contact

- **Email:** [s224027@dtu.dk]
- **GitHub:** [@sadafayubb](https://github.com/sadafayubb)
