% MATLAB script to generate 95% confidence interval plots
% Shows mean measurements with error bars for different SF and BW settings

function opti_test_confidence(sheet_name)
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
    
    % Create separate figure for each distance
    for i = 1:length(distances)
        figure;
        hold on;
        distance = distances(i);
        
        for BW = [800, 1600]
            % Filter data for current distance and BW
            subset = data(data.Distance_m == distance & data.BW_Setting == BW, :);
            
            % Get unique SFs
            SFs = unique(subset.SF_Setting);
            means = zeros(size(SFs));
            CIs = zeros(size(SFs));
            
            for j = 1:length(SFs)
                sf = SFs(j);
                row = subset(subset.SF_Setting == sf, 4:end);
                values = table2array(row);
                values = values(:);
                
                mu = mean(values);
                SEM = std(values) / sqrt(length(values));
                CI95 = 1.96 * SEM;
                
                means(j) = mu;
                CIs(j) = CI95;
            end
            
            % Plot with error bars
            if BW == 800
                errorbar(SFs, means, CIs, 'o-r', 'LineWidth', 1.5, 'DisplayName', 'BW 800');
            else
                errorbar(SFs, means, CIs, 'o-b', 'LineWidth', 1.5, 'DisplayName', 'BW 1600');
            end
        end
        
        % Add expected distance line
        yline(distance, '--k', 'LineWidth', 1.2, 'DisplayName', 'Expected Distance');
        
        xlabel('Spreading Factor');
        ylabel('Mean Measurement');
        title(sprintf('Distance = %d m - %s', distance, sheet_name));
        legend('Location', 'best');
        grid on;
        
        % Save figure
        output_file = fullfile(figures_dir, sprintf('%s_Confidence_%dm.jpg', sheet_name, distance));
        saveas(gcf, output_file);
        fprintf('Saved: %s\n', output_file);
        close(gcf);
    end
end
