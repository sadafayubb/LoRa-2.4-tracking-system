% MAE and 95% CI vs. Number of Exchanges at different distances
% Plots mean absolute error with confidence intervals

function req_test()
    % Get paths relative to script location
    script_dir = fileparts(mfilename('fullpath'));
    data_file = fullfile(script_dir, '..', 'data', 'sx1280_test_data.xlsx');
    figures_dir = fullfile(script_dir, '..', 'figures', 'reqTest');
    
    % Create figures directory if needed
    if ~exist(figures_dir, 'dir')
        mkdir(figures_dir);
    end
    
    % Read data
    sheet = 'ReqTest';
    data = readtable(data_file, 'Sheet', sheet);
    
    % Extract columns
    num_exch = data{:,1};
    distance = data{:,2};
    measurements = data{:,3:end};
    
    % Unique distances and exchange counts
    distances = [50, 100, 150];
    exchanges = unique(num_exch);
    
    % Preallocate storage for MAE and CI
    mae = zeros(length(exchanges), length(distances));
    ci = zeros(length(exchanges), length(distances));
    
    % Calculate MAE and CI for each distance and exchange count
    for d = 1:length(distances)
        for e = 1:length(exchanges)
            idx = (num_exch == exchanges(e)) & (distance == distances(d));
            errors = abs(measurements(idx,:) - distances(d));
            errors = errors(:);
            mae(e,d) = mean(errors);
            sem = std(errors) / sqrt(length(errors));
            ci(e,d) = 1.96 * sem;
            
            % Print variation for 10 exchanges
            if exchanges(e) == 10
                fprintf('Distance = %dm, Exchanges = %d --> Std Dev = %.3f m\n', distances(d), exchanges(e), std(errors));
            end
        end
    end
    
    % Plotting
    colors = {'r', 'g', 'b'};
    labels = {'50m', '100m', '150m'};
    figure;
    hold on;
    for d = 1:length(distances)
        errorbar(exchanges, mae(:,d), ci(:,d), '-o', 'Color', colors{d}, 'DisplayName', labels{d});
    end
    xlabel('Number of Exchanges');
    ylabel('Mean Absolute Error (MAE) [m]');
    title('MAE vs. Number of Exchanges for Different Distances');
    legend('Location', 'northeast');
    grid on;
    
    % Save figure
    output_file = fullfile(figures_dir, 'mae_vs_exchanges.jpg');
    saveas(gcf, output_file);
    fprintf('Saved: %s\n', output_file);
end
