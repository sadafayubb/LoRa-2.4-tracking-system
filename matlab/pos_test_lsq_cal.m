% Position estimation using Least Squares (LSQ) trilateration
% WITH calibration applied

function pos_test_lsq_cal()
    % Get paths relative to script location
    script_dir = fileparts(mfilename('fullpath'));
    data_file = fullfile(script_dir, '..', 'data', 'sx1280_test_data.xlsx');
    figures_dir = fullfile(script_dir, '..', 'figures', 'posTest');
    lut_file = fullfile(script_dir, '..', 'lut', 'calibration_lut_cr48.mat');
    
    % Create figures directory if needed
    if ~exist(figures_dir, 'dir')
        mkdir(figures_dir);
    end
    
    % Load LUT
    S = load(lut_file);
    true_vals = S.true_vals;
    measured_vals = S.measured_vals;
    
    % Load data
    sheet = 'PosTest';
    data = readtable(data_file, 'Sheet', sheet);
    
    % Anchor positions (fixed)
    anchors = [0 0; 0 100; 62 0];
    
    % Number of test positions
    nTests = height(data) / 3;
    true_pos = zeros(nTests, 2);
    est_pos = zeros(nTests, 2);
    errors = zeros(nTests, 1);
    
    % Optimization options
    opts = optimoptions('lsqnonlin', 'Display', 'off');
    
    % Process each test position
    for i = 1:nTests
        rowIdx = (i-1)*3 + 1;
        
        % Ground truth
        xt = data.Player_X(rowIdx);
        yt = data.Player_Y(rowIdx);
        true_pos(i,:) = [xt, yt];
        
        % Get calibrated average distances
        r = zeros(3,1);
        for a = 1:3
            raw_meas = table2array(data(rowIdx + a - 1, 5:end));
            corrected_meas = interp1(measured_vals, true_vals, raw_meas, 'linear', 'extrap');
            r(a) = mean(corrected_meas);
        end
        
        % LSQ Trilateration
        cost_fun = @(p) sqrt((p(1) - anchors(:,1)).^2 + (p(2) - anchors(:,2)).^2) - r;
        x0 = [mean(anchors(:,1)), mean(anchors(:,2))];
        xy_hat = lsqnonlin(cost_fun, x0, [], [], opts);
        
        est_pos(i,:) = xy_hat(:)';
        errors(i) = norm(xy_hat(:)' - [xt, yt]);
    end
    
    % Print results
    fprintf('\n=== LSQ Trilateration WITH Calibration ===\n');
    for i = 1:nTests
        fprintf('Point %2d: Error = %.2f m\n', i, errors(i));
    end
    
    % Calculate DRMS
    dx = est_pos(:,1) - true_pos(:,1);
    dy = est_pos(:,2) - true_pos(:,2);
    DRMS = sqrt(mean(dx.^2 + dy.^2));
    fprintf('DRMS error: %.2f m\n', DRMS);
    
    % Visualization
    figure; hold on;
    h1 = scatter(true_pos(:,1), true_pos(:,2), 80, 'g', 'filled');
    h2 = scatter(est_pos(:,1), est_pos(:,2), 80, 'b', 'filled');
    h3 = quiver(true_pos(:,1), true_pos(:,2), ...
                est_pos(:,1)-true_pos(:,1), est_pos(:,2)-true_pos(:,2), ...
                0, 'r', 'LineWidth', 1.2);
    h4 = scatter(anchors(:,1), anchors(:,2), 120, 'k', 'd', 'filled');
    text(anchors(:,1) + 1.5, anchors(:,2), {'A1','A2','A3'}, 'FontSize', 12);
    
    % Add confidence ellipses
    for i = 1:nTests
        xt = true_pos(i,1); yt = true_pos(i,2);
        rowIdx = (i-1)*3 + 1;
        
        meas1 = table2array(data(rowIdx + 0, 5:14));
        meas2 = table2array(data(rowIdx + 1, 5:14));
        meas3 = table2array(data(rowIdx + 2, 5:14));
        
        est_samples = zeros(10,2);
        for m = 1:10
            R1 = interp1(measured_vals, true_vals, meas1(m), 'linear', 'extrap');
            R2 = interp1(measured_vals, true_vals, meas2(m), 'linear', 'extrap');
            R3 = interp1(measured_vals, true_vals, meas3(m), 'linear', 'extrap');
            r_sample = [R1; R2; R3];
            
            cost_fun = @(p) sqrt((p(1) - anchors(:,1)).^2 + (p(2) - anchors(:,2)).^2) - r_sample;
            x0 = [mean(anchors(:,1)), mean(anchors(:,2))];
            xy_hat = lsqnonlin(cost_fun, x0, [], [], opts);
            est_samples(m,:) = xy_hat(:).';
        end
        
        err_samples = est_samples - repmat([xt, yt], 10, 1);
        C_local = cov(err_samples) + 1e-6*eye(2);
        chi2_val = chi2inv(0.95, 2);
        [V, D] = eig(C_local);
        theta = linspace(0, 2*pi, 50);
        unit_circle = [cos(theta); sin(theta)];
        ellipse_shape = V * sqrt(D * chi2_val) * unit_circle;
        center_mean = mean(est_samples, 1);
        x_e = ellipse_shape(1,:) + center_mean(1);
        y_e = ellipse_shape(2,:) + center_mean(2);
        plot(x_e, y_e, 'k--', 'HandleVisibility','off');
    end
    
    legend([h1, h2, h3, h4], {'True Position', 'Calibrated Estimate', 'Error', 'Anchors'});
    xlabel('X (m)'); ylabel('Y (m)');
    title('LSQ Trilateration - With Calibration');
    grid on; axis equal;
    
    % Set axis limits
    margin = 10;
    all_x = [true_pos(:,1); est_pos(:,1); anchors(:,1)];
    all_y = [true_pos(:,2); est_pos(:,2); anchors(:,2)];
    xlim([min(all_x) - margin, max(all_x) + margin]);
    ylim([min(all_y) - margin, max(all_y) + margin]);
    
    % Save figure
    output_file = fullfile(figures_dir, 'pos_lsq_calibrated.jpg');
    set(gcf, 'Position', [100, 100, 800, 600]);
    exportgraphics(gcf, output_file, 'Resolution', 150);
    fprintf('Saved: %s\n', output_file);
end
