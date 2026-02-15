% Calibration with Polynomial Fit - CaliTest1 (CR 4/5)
% Fits polynomial: measured = f(true_dist)

function cali_test_fit1()
    % Get paths relative to script location
    script_dir = fileparts(mfilename('fullpath'));
    data_file = fullfile(script_dir, '..', 'data', 'sx1280_test_data.xlsx');
    figures_dir = fullfile(script_dir, '..', 'figures', 'caliTest');
    lut_dir = fullfile(script_dir, '..', 'lut');
    
    % Create directories if needed
    if ~exist(figures_dir, 'dir')
        mkdir(figures_dir);
    end
    if ~exist(lut_dir, 'dir')
        mkdir(lut_dir);
    end
    
    % Load data
    sheet = 'CaliTest1';
    data = readtable(data_file, 'Sheet', sheet);
    
    true_dist = data.Distance_m;
    measured = mean(table2array(data(:,2:end)), 2);
    error_std = std(table2array(data(:,2:end)), 0, 2);
    
    % Fit polynomial: measured = f(true_dist)
    poly_degree = 6;
    p = polyfit(true_dist, measured, poly_degree);
    f_poly = @(t) polyval(p, t);
    
    % Evaluate fit
    x_fit = linspace(min(true_dist), max(true_dist), 150);
    y_fit = f_poly(x_fit);
    
    % Plot measured vs true with polynomial fit
    fig1 = figure('Name','Calibration Fit: Measured = f(True)','NumberTitle','off');
    hold on;
    errorbar(true_dist, measured, error_std, 'ko', 'DisplayName', 'Measured \pm Std');
    plot(x_fit, y_fit, 'r-', 'LineWidth', 2, 'DisplayName', sprintf('%d^{th}-Degree Polynomial Fit', poly_degree));
    xlabel('True Distance (m)');
    ylabel('Measured Distance (m)');
    title(sprintf('Calibration Fit CR 4/5 (Degree %d)', poly_degree));
    grid on;
    legend('Location', 'northwest');
    hold off;
    
    % Save calibration fit plot
    output_file1 = fullfile(figures_dir, 'calibration_fit_cr45.jpg');
    exportgraphics(fig1, output_file1, 'Resolution', 150);
    fprintf('Saved: %s\n', output_file1);
    
    % Residual analysis
    measured_pred = f_poly(true_dist);
    residuals = measured - measured_pred;
    
    fig2 = figure('Name','Residuals','NumberTitle','off');
    bar(true_dist, residuals);
    xlabel('True Distance (m)');
    ylabel('Residual Error (m)');
    title('Residuals of Polynomial Fit CR 4/5');
    grid on;
    
    % Save residuals plot
    output_file2 = fullfile(figures_dir, 'residuals_cr45.jpg');
    exportgraphics(fig2, output_file2, 'Resolution', 100);
    fprintf('Saved: %s\n', output_file2);
    
    % Residual stats
    mean_resid = mean(residuals);
    std_resid = std(residuals);
    rmse_resid = sqrt(mean(residuals.^2));
    max_resid = max(abs(residuals));
    
    fprintf('\n=== CaliTest1 (CR 4/5) Results ===\n');
    fprintf('Polynomial Coefficients (degree %d):\n', poly_degree);
    format long g
    disp(p)
    fprintf('Residual Stats:\n');
    fprintf(' Mean = %.3f m\n', mean_resid);
    fprintf(' Std = %.3f m\n', std_resid);
    fprintf(' RMSE = %.3f m\n', rmse_resid);
    fprintf(' Max = %.3f m\n', max_resid);
    
    % Calculate Adjusted R^2
    n = length(measured);
    r = poly_degree;
    SS_res = sum(residuals.^2);
    SS_tot = sum((measured - mean(measured)).^2);
    R2 = 1 - (SS_res / SS_tot);
    adj_R2 = 1 - (1 - R2) * (n - 1) / (n - r - 1);
    fprintf('R^2 = %.5f\n', R2);
    fprintf('Adjusted R^2 = %.5f\n', adj_R2);
    
    % Save LUT coefficients as text
    lut_file = fullfile(lut_dir, 'lut_cr45.txt');
    fid = fopen(lut_file, 'w');
    fprintf(fid, 'Calibration LUT - CR 4/5\n');
    fprintf(fid, 'Polynomial degree: %d\n', poly_degree);
    fprintf(fid, 'Coefficients (highest to lowest degree):\n');
    for i = 1:length(p)
        fprintf(fid, '%.15e\n', p(i));
    end
    fclose(fid);
    fprintf('Saved LUT: %s\n', lut_file);
    
    % Generate and save LUT as .mat file for position estimation
    true_vals = linspace(0, 150, 1501);  % 0.1m resolution
    measured_vals = polyval(p, true_vals);
    lut_mat_file = fullfile(lut_dir, 'calibration_lut_cr45.mat');
    save(lut_mat_file, 'true_vals', 'measured_vals');
    fprintf('Saved LUT .mat file: %s\n', lut_mat_file);
end
