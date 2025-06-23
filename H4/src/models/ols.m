function [output, se] = ols(data, config)
%OLS Performs an Ordinary Least Squares (OLS) regression.
%
%   This function estimates a linear model using OLS. It calculates the
%   coefficients and provides an option to compute either classical or
%   heteroskedasticity-robust (White's) standard errors.
%
%   Inputs:
%       data    - A structure containing the model data.
%                 It must include the following fields:
%                 .y: Vector of the dependent variable.
%                 .X: Matrix of independent variables, including a column
%                     for the intercept.
%                 .X_labels: Cell array with names for the predictors in X.
%
%       config  - A structure with configuration settings.
%                 It should include the following field:
%                 .robust: String, 'true' to use White's robust standard errors.
%
%   Outputs:
%       output  - A table containing the predictor names and their estimated
%                 coefficients.
%       se      - A column vector of standard errors for the coefficients.

    X = data.X;
    y = data.y;
    [n, k] = size(X); % n = observations, k = regressors.

    % Calculate OLS coefficients using the efficient backslash operator.
    beta = X \ y;

    % Compute the residuals of the model.
    residuals = y - X * beta;

    % Calculate standard errors based on the configuration.
    if strcmp(config.robust, 'true')
        % Use White's heteroskedasticity-robust standard errors.
        fprintf('[INFO] White Kernel.\n');
        [~, se] = white_se(X, residuals);
    else
        % Use classical OLS standard errors (assuming homoskedasticity).
        fprintf('[INFO] Classical OLS.\n');
        sigma2 = (residuals' * residuals) / (n - k);
        var_cov_matrix_classic = sigma2 * inv(X' * X);
        se = sqrt(diag(var_cov_matrix_classic));
    end

    % Format the output into a table.
    output = table(data.X_labels', beta, 'VariableNames', {'Predictor', 'Beta_Estimado'});
end