# MATLAB Scripts - SX1280 Test Analysis

Complete analysis suite for LoRa 2.4 GHz ranging measurements including optimization, calibration, and position estimation.

## Requirements

**MATLAB Version:** R2020a or later recommended

**Required Toolboxes:**
- **Statistics and Machine Learning Toolbox** - Required for:
  - `chi2inv()` - Confidence ellipse calculations (all position tests)
  - `cov()` - Covariance matrix computation
  
- **Optimization Toolbox** - Required for:
  - `lsqnonlin()` - Least squares trilateration (LSQ methods)
  
- **Base MATLAB** - All other functions (`readtable`, `polyfit`, `polyval`, etc.)

**Note:** If you don't have the Optimization Toolbox, you can still run all DLS methods (`pos_test_dls`, `pos_test_dls_cal`) and all calibration/optimization tests. Only LSQ methods (`pos_test_lsq`, `pos_test_lsq_cal`) require it.

All scripts use relative paths and auto-create output directories. Run from any directory (repo root or `matlab/`).

## Quick Start

```matlab
% Run everything at once
run_all
```

## Individual Scripts

### Optimization Tests
- **`opti_test_3d_error.m`** - 3D scatter plots showing mean absolute error for different SF/BW combinations
- **`opti_test_confidence.m`** - 95% confidence interval plots for measurement accuracy
- **`run_opti_tests.m`** - Run both optimization test analyses

Usage:
```matlab
opti_test_3d_error('OptiTest1')      % 35cm height
opti_test_confidence('OptiTest2')    % 110cm height
```

### Request Test
- **`req_test.m`** - MAE vs. number of exchanges at different distances

Usage:
```matlab
req_test()
```

### Calibration Tests
- **`cali_test_error.m`** - Error vs distance plot with std deviation
- **`cali_test_fit1.m`** - Polynomial calibration fit for CR 4/5 (generates LUT .txt and .mat)
- **`cali_test_fit2.m`** - Polynomial calibration fit for CR 4/8 (generates LUT .txt and .mat)

Usage:
```matlab
cali_test_error()
cali_test_fit1()
cali_test_fit2()
```

### Position Estimation Tests
- **`pos_test_dls.m`** - Direct Linear Solve trilateration (no calibration)
- **`pos_test_lsq.m`** - Least Squares trilateration (no calibration)
- **`pos_test_dls_cal.m`** - Direct Linear Solve trilateration (with calibration)
- **`pos_test_lsq_cal.m`** - Least Squares trilateration (with calibration)

Usage:
```matlab
pos_test_dls()           % No calibration
pos_test_lsq()           % No calibration
pos_test_dls_cal()       % With calibration (requires LUT)
pos_test_lsq_cal()       % With calibration (requires LUT)
```

**Note:** Calibrated position tests require running calibration tests first to generate the LUT .mat file.

## Input

Data file: `data/sx1280_test_data.xlsx`

Sheets used:
- `OptiTest1` - Optimization test at 35cm height
- `OptiTest2` - Optimization test at 110cm height
- `ReqTest` - Request/exchange count test
- `CaliTest1` - Calibration data CR 4/5
- `CaliTest2` - Calibration data CR 4/8
- `PosTest` - Position estimation test data

## Output

### Figures (all JPG format)

**`figures/optiTest/`**
- `OptiTest1_3DError_[25|50|100|150]m.jpg`
- `OptiTest1_Confidence_[25|50|100|150]m.jpg`
- `OptiTest2_3DError_[25|50|100|150]m.jpg`
- `OptiTest2_Confidence_[25|50|100|150]m.jpg`

**`figures/reqTest/`**
- `mae_vs_exchanges.jpg`

**`figures/caliTest/`**
- `error_vs_distance.jpg`
- `calibration_fit_cr45.jpg`
- `residuals_cr45.jpg`
- `calibration_fit_cr48.jpg`
- `residuals_cr48.jpg`

**`figures/posTest/`**
- `pos_dls.jpg` - DLS without calibration
- `pos_lsq.jpg` - LSQ without calibration
- `pos_dls_calibrated.jpg` - DLS with calibration
- `pos_lsq_calibrated.jpg` - LSQ with calibration

### Lookup Tables

**`lut/`**
- `lut_cr45.txt` - Polynomial coefficients for CR 4/5
- `lut_cr48.txt` - Polynomial coefficients for CR 4/8
- `calibration_lut_cr45.mat` - LUT for position estimation (CR 4/5)
- `calibration_lut_cr48.mat` - LUT for position estimation (CR 4/8)

## File Organization

```
matlab/
├── run_all.m                  # Master script - runs everything
├── run_opti_tests.m           # Run optimization tests only
├── opti_test_3d_error.m
├── opti_test_confidence.m
├── req_test.m
├── cali_test_error.m
├── cali_test_fit1.m
├── cali_test_fit2.m
├── pos_test_dls.m
├── pos_test_lsq.m
├── pos_test_dls_cal.m
└── pos_test_lsq_cal.m
```
