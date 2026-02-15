% Calibration Error Plot - True Distance vs. Error

function cali_test_error()
    % Get paths relative to script location
    script_dir = fileparts(mfilename('fullpath'));
    data_file = fullfile(script_dir, '..', 'data', 'sx1280_test_data.xlsx');
    figures_dir = fullfile(script_dir, '..', 'figures', 'caliTest');
    
    % Create figures directory if needed
    if ~exist(figures_dir, 'dir')
        mkdir(figures_dir);
    end
    
    % Load calibration data
    sheet = 'CaliTest1';
    data = readtable(data_file, 'Sheet', sheet);
    
    distances = data.Distance_m;
    meas = table2array(data(:,2:end));
    
    % Compute mean and std of measurements
    meas_mean = mean(meas,2);
    meas_std = std(meas,0,2);
    error = meas_mean - distances;
    
    % Plot: True Distance vs. Error with standard deviation
    figure('Name', 'True Distance vs. Error', 'NumberTitle', 'off');
    errorbar(distances, error, meas_std, 'bo-', 'LineWidth', 1.5, 'MarkerFaceColor', 'b');
    hold on;
    
    % Reference lines at -2m, -5m, -10m
    yline(-2, 'k--', 'LineWidth', 1);
    yline(-5, 'k--', 'LineWidth', 1);
    yline(-10, 'k--', 'LineWidth', 1);
    
    xlabel('True Distance (m)');
    ylabel('Mean Error (Measured - True) [m]');
    title('Measurement Error vs. True Distance');
    grid on;
    legend('Measured Error \pm Std Dev', '-2m', '-5m', '-10m', 'Location', 'best');
    hold off;
    
    % Save figure
    output_file = fullfile(figures_dir, 'error_vs_distance.jpg');
    set(gcf,'PaperPositionMode','auto');
    print(gcf, output_file, '-djpeg', '-r300');
    fprintf('Saved: %s\n', output_file);
end
