function [vcov_robust, se_robust] = white_se(X, e)
    % ROBUST_SE Calculates heteroskedasticity-robust standard errors (HC1).
    %
    %   [vcov_robust, se_robust] = robust_se(X, e)
    %
    %   Inputs:
    %     X: Matrix of regressors (independent variables) from the model (n x k).
    %     e: Vector of residuals from the estimated model (n x 1).
    %
    %   Outputs:
    %     vcov_robust: The robust variance-covariance matrix (k x k).
    %     se_robust:   The vector of robust standard errors (k x 1).

    %% 1. GET DIMENSIONS
    [n, k] = size(X);

    %% 2. CALCULATE THE SANDWICH COMPONENTS

    % The "bread": (X'X)^-1
    % Calculated once for efficiency.
    invXX = inv(X' * X);

    % The "meat": Sum(e_i^2 * x_i * x_i')
    % Calculated using matrix algebra to avoid a slow for-loop.
    % X' * diag(e.^2) * X is an efficient way to compute the sum.
    S = X' * diag(e.^2) * X;

    %% 3. DEGREES OF FREEDOM CORRECTION (HC1)
    % Stata and other packages use n/(n-k) for a finite-sample correction.
    df_correction = n / (n - k);

    %% 4. ASSEMBLE THE SANDWICH
    vcov_robust = df_correction * invXX * S * invXX;

    %% 5. CALCULATE STANDARD ERRORS
    % They are the square root of the diagonal of the var-cov matrix.
    se_robust = sqrt(diag(vcov_robust));

end