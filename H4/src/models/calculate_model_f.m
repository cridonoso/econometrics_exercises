function [F_stat, p_value] = calculate_model_f(y, y_fit, n, k)
%CALCULATE_MODEL_F Calculates the F-statistic for overall model significance.
%
%   This function computes the F-test, which assesses whether a regression
%   model provides a better fit to the data than a model with no
%   independent variables (i.e., an intercept-only model).
%
%   Inputs:
%       y       - A vector of the observed dependent variable values.
%       y_fit   - A vector of the fitted (predicted) values from the model.
%       n       - The total number of observations.
%       k       - The number of regressors in the model (including intercept).
%
%   Outputs:
%       F_stat  - The calculated value of the F-statistic.
%       p_value - The p-value associated with the F-statistic.

    % Calculate the Residual Sum of Squares (RSS).
    RSS = sum((y - y_fit).^2);

    % Calculate the Total Sum of Squares (TSS).
    TSS = sum((y - mean(y)).^2);

    % Define the degrees of freedom for the F-statistic.
    df_num = k - 1; % Numerator degrees of freedom.
    df_den = n - k; % Denominator degrees of freedom.

    % Compute the F-statistic.
    F_stat = ((TSS - RSS) / df_num) / (RSS / df_den);

    % Compute the p-value from the F-distribution's CDF.
    p_value = 1 - fcdf(F_stat, df_num, df_den);

end