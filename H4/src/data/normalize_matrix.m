function [X_normalized, X_means, X_stds] = normalize_matrix(X_input)
%NORMALIZE_MATRIX Standardizes the columns of a matrix to have a mean of 0 and a standard deviation of 1.
%
%   This function performs z-score normalization on a given matrix. It is
%   assumed that the first column is an intercept and will be skipped. Any
%   other columns that are constant (i.e., have a standard deviation of
%   zero) will also be skipped to avoid division by zero.
%
%   Inputs:
%       X_input         - The input numerical matrix to be standardized.
%
%   Outputs:
%       X_normalized    - The matrix with its columns standardized.
%       X_means         - A row vector containing the original mean of each column.
%       X_stds          - A row vector containing the original standard
%                         deviation of each column.

    % Handle the case of an empty input matrix.
    if isempty(X_input)
        X_normalized = [];
        X_means = [];
        X_stds = [];
        warning('Input matrix is empty. No normalization performed.');
        return;
    end

    [~, num_cols] = size(X_input);
    % Initialize the output matrix as a copy of the input.
    X_normalized = X_input;

    % Initialize vectors to store the mean and std for each column.
    X_means = zeros(1, num_cols);
    % Default std to 1 for columns that are not normalized (e.g., intercept).
    X_stds = ones(1, num_cols);

    % Iterate through each column to standardize it.
    for j = 1:num_cols
        current_column_data = X_input(:, j);

        % Assume the first column is an intercept and skip normalization.
        if j == 1
            X_means(j) = 0; % Set neutral values for the intercept's parameters.
            X_stds(j) = 1;
            continue;
        end

        % Calculate the mean and standard deviation for the current column.
        col_mean = mean(current_column_data);
        col_std = std(current_column_data);

        % Store the original parameters for potential inverse transformation.
        X_means(j) = col_mean;
        X_stds(j) = col_std;

        % Normalize only if the column is not constant (std is not zero).
        if col_std > 1e-10
            X_normalized(:, j) = (current_column_data - col_mean) / col_std;
        else
            % If column is constant, do not normalize and issue a warning.
            warning('Column %d is constant (zero standard deviation). Not normalized.', j);
        end
    end
end