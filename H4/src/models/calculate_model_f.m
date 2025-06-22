function [F_stat, p_value] = calculate_model_f(y, y_fit, n, k)
% CALCULATE_MODEL_F Calculates the F-statistic for overall model significance.
%
%   Usage:
%   [F_stat, p_value] = calculate_model_f(y, y_fit, n, k)
%
%   Inputs:
%   y:     Vector of the observed dependent variable (Nx1).
%   y_fit: Vector of the fitted values from the model (Nx1).
%   n:     Number of observations.
%   k:     Number of regressors in the model (including intercept).
%
%   Outputs:
%   F_stat:  Value of the F-statistic.
%   p_value: p-value of the F-statistic.

    % Sum of Squared Residuals (RSS or SSR)
    RSS = sum((y - y_fit).^2);
    
    % Total Sum of Squares (TSS)
    TSS = sum((y - mean(y)).^2);
    
    % Degrees of freedom
    df_num = k - 1; % Numerator
    df_den = n - k; % Denominator
    
    % F-test formula
    F_stat = ((TSS - RSS) / df_num) / (RSS / df_den);
    
    % p-value calculation
    p_value = 1 - fcdf(F_stat, df_num, df_den);

end