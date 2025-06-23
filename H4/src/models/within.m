function [output, se] = within(data, config)
%WITHIN Implements the Within (Fixed Effects) estimator for panel data.
%
%   This function estimates a fixed-effects model by applying the within
%   transformation (demeaning) to the data and then running OLS on the
%   transformed variables.
%
%   Inputs:
%       data    - A structure containing the panel data and labels.
%                 It must include the following fields:
%                 .y: Vector of the dependent variable.
%                 .X: Matrix of independent variables. The first column
%                     is assumed to be an intercept and will be removed.
%                 .id: Vector of panel identifiers for each observation.
%                 .X_labels: Cell array with names for the predictors in X.
%
%       config  - A structure with configuration settings.
%                 It should include the following fields:
%                 .log_y: String, "true" to apply a log(y) transformation.
%                 .robust: String, "true" to use White's robust standard errors.
%
%   Outputs:
%       output  - A table containing the estimated coefficients and the
%                 names of the predictors.
%       se      - A column vector of standard errors for the coefficients.

    %% 1. Prepare data and dimensions
    % Extract regressors, removing the first column (intercept).
    x = data.X;
    x = x(:, 2:size(x, 2));

    % Optionally, apply log transformation to the dependent variable.
    if config.log_y == "true"
        y = log(data.y + 1e-9);
    else
        y = data.y;
    end

    % Get dimensions and create a sequential ID for efficient grouping.
    id = data.id;
    [n, k] = size(x);
    [~, ~, id_sequential] = unique(id);
    N = max(id_sequential);

    %% 2. Apply the Within Transformation (Demeaning)
    % Count observations for each group.
    counts = accumarray(id_sequential, 1);

    % Demean the dependent variable 'y'.
    y_sums = accumarray(id_sequential, y);
    y_means = y_sums ./ counts;
    y_group_means = y_means(id_sequential);
    y_demeaned = y - y_group_means;

    % Demean each independent variable 'x'.
    x_demeaned = zeros(n, k); % Pre-allocate for performance.
    for i = 1:k
        x_col_sums = accumarray(id_sequential, x(:, i));
        x_col_means = x_col_sums ./ counts;
        x_col_group_means = x_col_means(id_sequential);
        x_demeaned(:, i) = x(:, i) - x_col_group_means;
    end

    %% 3. Estimate Parameters via OLS on Transformed Data
    % Estimate coefficients using the demeaned data.
    beta = (x_demeaned' * x_demeaned) \ (x_demeaned' * y_demeaned);
    beta(isnan(beta)) = 0; % Handle potential NaN from perfect collinearity.

    % Calculate residuals.
    e = y_demeaned - x_demeaned * beta;

    % Calculate standard errors.
    if strcmp(config.robust, 'true')
        % Use White's heteroskedasticity-robust standard errors.
        fprintf('[INFO] White Kernel.\n');
        [~, se] = white_se(x, e);
    else
        % Use classical OLS standard errors.
        fprintf('[INFO] Classical OLS.\n');
        df = n - k - N; % Adjust degrees of freedom for fixed effects.
        s2 = (e' * e) / df;
        vcov = s2 * inv(x_demeaned' * x_demeaned);
        se = sqrt(diag(vcov));
    end

    %% 4. Format Output
    % Get predictor labels (excluding the intercept).
    labels = data.X_labels;
    labels = labels(2:length(labels));
    
    % Create the output table.
    output = table(labels', beta, 'VariableNames', {'Predictor', 'Beta_Estimado'});

end