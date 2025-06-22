function [X_normalized, X_means, X_stds] = normalize_matrix(X_input)
    % NORMALIZE_MATRIX Standardizes matrix columns (mean 0, std 1).
    %
    %   [X_NORMALIZED, X_MEANS, X_STDS] = NORMALIZE_MATRIX(X_INPUT)
    %
    %   X_INPUT: The input matrix where columns are variables and rows are
    %            observations. The first column is assumed to be the intercept
    %            and is NOT normalized.
    %
    %   X_NORMALIZED: The matrix with standardized columns.
    %   X_MEANS: A row vector with the means used for each column.
    %   X_STDS: A row vector with the standard deviations used for each column.
    %
    %   Columns with zero standard deviation (constant columns) are not normalized.

    if isempty(X_input)
        X_normalized = [];
        X_means = [];
        X_stds = [];
        warning('Input matrix is empty. No normalization performed.');
        return;
    end

    [num_rows, num_cols] = size(X_input);
    X_normalized = X_input; % Initialize normalized matrix with original data
    
    % Initialize vectors to store means and standard deviations
    X_means = zeros(1, num_cols);
    X_stds = ones(1, num_cols); % Use 1 for non-normalized columns (intercept or std=0)

    % Iterate over each column, skipping the first one (intercept)
    for j = 1:num_cols
        current_column_data = X_input(:, j);

        if j == 1 % Assume the first column is the intercept (all ones)
            X_means(j) = 0; % Mean of intercept is not used for normalization
            X_stds(j) = 1;  % Standard deviation of intercept is not used
            % X_normalized(:, j) is already 1, no change needed.
            continue; % Skip to the next column
        end

        % Calculate mean and standard deviation for the current column
        col_mean = mean(current_column_data);
        col_std = std(current_column_data);

        % Store for future reference
        X_means(j) = col_mean;
        X_stds(j) = col_std;

        % Normalize the column if standard deviation is not zero
        % (Avoid division by zero for constant columns)
        if col_std > 1e-10 % Use a small tolerance for comparison with zero
            X_normalized(:, j) = (current_column_data - col_mean) / col_std;
        else
            warning('Column %d is constant (zero standard deviation). Not normalized.', j);
            X_normalized(:, j) = current_column_data; % Leave constant column as is
            X_means(j) = col_mean; % Store its mean
            X_stds(j) = 1; % Set std to 1 to indicate no division by zero occurred
        end
    end
end