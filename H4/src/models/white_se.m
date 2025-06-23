function [vcov_robust, se_robust] = white_se(X, e)
%WHITE_SE Calculates White's heteroskedasticity-robust standard errors.
%
%   This function computes the robust variance-covariance matrix using the
%   "sandwich" estimator, applying the HC1 finite-sample correction factor
%   of n/(n-k).
%
%   Inputs:
%       X           - A (n x k) matrix of independent variables (regressors).
%       e           - A (n x 1) vector of residuals from the original model.
%
%   Outputs:
%       vcov_robust - The (k x k) robust variance-covariance matrix (HC1).
%       se_robust   - A (k x 1) vector of robust standard errors.

    % Get problem dimensions.
    [n, k] = size(X);

    %% 1. Calculate Kernel Estimator Components
    % Calculate the similarity matrix of the estimator: (X'X)^-1
    invXX = inv(X' * X);

    % Calculate the kernel part of the estimator: Sum(e_i^2 * x_i * x_i')
    % This is computed efficiently using matrix operations.
    S = X' * diag(e.^2) * X;

    %% 2. Apply Finite-Sample Correction (HC1)
    % This correction is commonly used by statistical packages like Stata.
    df_correction = n / (n - k);

    %% 3. Assemble the Robust Variance-Covariance Matrix
    vcov_robust = df_correction * invXX * S * invXX;

    %% 4. Extract Standard Errors
    % Standard errors are the square root of the diagonal elements.
    se_robust = sqrt(diag(vcov_robust));

end