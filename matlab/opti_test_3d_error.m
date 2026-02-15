% MATLAB script to generate 3D error plots from optimization test data
% Generates separate 3D scatter plots showing mean absolute error
% for different SF and BW settings at various distances

function opti_test_3d_error(sheet_name)
    % sheet_name: 'OptiTest1' (35cm height) or 'OptiTest2' (110cm height)
    
    if nargin < 1
        sheet_name = 'OptiTest1';
    end
    
    % Get script directory and build paths relative to it
    script_dir = fileparts(mfilename('fullpath'));
    data_file = fullfile(script_dir, '..', 'data', 'sx1280_test_data.xlsx');
    figures_dir = fullfile(script_dir, '..', 'figures', 'optiTest');
    
    % Create figures directory if it doesn't exist
    if ~exist(figures_dir, 'dir')
        mkdir(figures_dir);
    end
    
    % Read data from Excel
    data = readtable(data_file, 'Sheet', sheet_name);
    
    % Distance values to plot
    distances = [25, 50, 100, 150];
    
    % Loop over each distance
    for i = 1:length(distances)
        figure;
        dist = distances(i);
        
        % Filter data for this distance
        distData = data(data.Distance_m == dist, :);
        
        % Calculate absolute errors
        measurements = distData{:, 4:end};
        absolute_errors = abs(measurements - distData.Distance_m);
        mean_errors = mean(absolute_errors, 2);
        
        % Prepare grid data
        [SF_vals, ~, sf_idx] = unique(distData.SF_Setting);
        [BW_vals, ~, bw_idx] = unique(distData.BW_Setting);
        
        Z = nan(length(BW_vals), length(SF_vals));
        X = nan(length(BW_vals), length(SF_vals));
        Y = nan(length(BW_vals), length(SF_vals));
        
        for j = 1:height(distData)
            sf = sf_idx(j);
            bw = bw_idx(j);
            Z(bw, sf) = mean_errors(j);
            X(bw, sf) = SF_vals(sf);
            Y(bw, sf) = BW_vals(bw);
        end
        
        xVals = X(:);
        yVals = Y(:);
        zVals = Z(:);
        
        % Create 3D scatter plot
        scatter3(xVals, yVals, zVals, 80, zVals, 'filled');
        hold on;
        
        % Add vertical lines from base to points
        for k = 1:length(xVals)
            if ~isnan(zVals(k))
                plot3([xVals(k), xVals(k)], [yVals(k), yVals(k)], [0, zVals(k)], 'r--');
            end
        end
        
        title(sprintf('Absolute Error at %dm - %s', dist, sheet_name));
        xlabel('SF (5-10)');
        ylabel('BW (kHz)');
        zlabel('Mean Absolute Error (m)');
        
        xticks(5:10);
        yticks([800, 1600]);
        grid on;
        colorbar;
        view(45, 30);
        
        % Save figure
        output_file = fullfile(figures_dir, sprintf('%s_3DError_%dm.jpg', sheet_name, dist));
        saveas(gcf, output_file);
        fprintf('Saved: %s\n', output_file);
    end
end
