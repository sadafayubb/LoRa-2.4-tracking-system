% Run all SX1280 test analyses
% Generates all plots and calibration data

clear; close all; clc;

fprintf('SX1280 Analysis Starting... \n\n');

% 1. Optimization Tests
fprintf('--- Running Optimization Tests ---\n');
opti_test_3d_error('OptiTest1');
opti_test_confidence('OptiTest1');

opti_test_3d_error('OptiTest2');
opti_test_confidence('OptiTest2');
fprintf('Optimization tests complete.\n\n');

% 2. Request Test
fprintf('--- Running Request Test ---\n');
req_test();
fprintf('Request test complete.\n\n');

% 3. Calibration Tests
fprintf('--- Running Calibration Tests ---\n');
cali_test_error();

cali_test_fit1();

cali_test_fit2();
fprintf('Calibration tests complete.\n\n');

% 4. Position Estimation Tests (No Calibration)
fprintf('--- Running Position Estimation (No Calibration) ---\n');
fprintf('DLS method...\n');
pos_test_dls();

fprintf('LSQ method...\n');
pos_test_lsq();
fprintf('Position estimation (no calibration) complete.\n\n');

% 5. Position Estimation Tests (With Calibration)
fprintf('--- Running Position Estimation (With Calibration) ---\n');
fprintf('DLS with calibration...\n');
pos_test_dls_cal();

fprintf('LSQ with calibration...\n');
pos_test_lsq_cal();
fprintf('Position estimation (with calibration) complete.\n\n');

fprintf('=== All Analyses Complete ===\n');
fprintf('Figures saved to: figures/optiTest/, figures/reqTest/, figures/caliTest/, figures/posTest/\n');
fprintf('LUT files saved to: lut/\n');
