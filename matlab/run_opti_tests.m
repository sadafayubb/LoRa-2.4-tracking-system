% Run all optimization test plots
% Generates both 3D error plots and confidence interval plots
% for OptiTest1 (35cm height) and OptiTest2 (110cm height)

clear; close all; clc;

% Process OptiTest1 (35cm height)
opti_test_3d_error('OptiTest1');
opti_test_confidence('OptiTest1');
fprintf('OptiTest1 complete.\n\n');

% Process OptiTest2 (110cm height)
opti_test_3d_error('OptiTest2');
opti_test_confidence('OptiTest2');
fprintf('OptiTest2 complete.\n\n');

