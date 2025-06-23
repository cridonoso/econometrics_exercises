function [output, se, fstats] = twosls(data, config)
%TWOSLS Performs Two-Stage Least Squares (2SLS) for instrumental variables.
%
%   This function estimates a model with one endogenous regressor using the
%   2SLS method. In the first stage, it regresses the endogenous variable
%   on the instruments and exogenous controls. In the second stage, it
%   regresses the dependent variable on the predicted values from the first
%   stage and the exogenous controls.
%
%   Inputs:
%       data    - A structure containing the data and labels.
%                 It must include the following fields:
%                 .y: Vector of the dependent variable.
%                 .X: Matrix of all independent variables (endogenous and
%                     exogenous controls).
%                 .Z: Matrix of instrumental variables.
%                 .X_labels: Cell array with names for the predictors in X.
%
%       config  - A structure with configuration settings.
%                 It must include the following fields:
%                 .vars.independent: String name of the endogenous variable.
%                 .vars.control: Cell array of strings with names of the
%                                exogenous control variables.
%
%   Outputs:
%       output  - A table containing the 2SLS coefficients.
%       se      - A column vector of standard errors for the coefficients.
%       fstats  - A table with F-statistics for instrument relevance (first
%                 stage) and overall model significance (second stage).

    %% 1. Prepare Data and Variables
    y = data.y;
    X = data.X;
    Z_inst = data.Z;

    % Separate variables into endogenous, exogenous, and instruments.
    X_endo = gather_matrix(X, data.X_labels, config.vars.independent);
    X_exo  = gather_matrix(X, data.X_labels, config.vars.control);

    [n, L] = size(Z_inst); % n = observations, L = number of instruments.

    % Ensure instruments are provided.
    if L == 0
        error('Error: No instruments (Z) were provided.');
    end

    %% 2. First-Stage Regression
    % Regress the endogenous variable on instruments and exogenous controls.
    if isempty(X_exo)
        X_unrestricted = [ones(n, 1), Z_inst];
    else
        X_unrestricted = [ones(n, 1), X_exo, Z_inst];
    end

    b_unrestricted = X_unrestricted \ X_endo;
    X_endo_hat = X_unrestricted * b_unrestricted;
    residuals_u = X_endo - X_endo_hat;
    RSS_u = sum(residuals_u.^2); % Unrestricted Sum of Squares.

    %% 3. F-Test for Instrument Relevance (Weak Instruments)
    % Compare the model with instruments to one without.
    if isempty(X_exo)
        X_restricted = ones(n, 1);
    else
        X_restricted = [ones(n, 1), X_exo];
    end
    b_restricted = X_restricted \ X_endo;
    residuals_r = X_endo - X_restricted * b_restricted;
    RSS_r = sum(residuals_r.^2); % Restricted Sum of Squares.

    % Calculate the F-statistic and its p-value.
    q = L; % Number of restrictions is the number of instruments.
    df_den = n - size(X_unrestricted, 2);
    z_f_test  = ((RSS_r - RSS_u) / q) / (RSS_u / df_den);
    z_p_value = 1 - fcdf(z_f_test, q, df_den);

    %% 4. Second-Stage Regression
    % Regress y on the predicted endogenous variable and exogenous controls.
    if isempty(X_exo)
        X_2sls = [ones(n, 1), X_endo_hat];
        X_2sls_labels = ["intercept", config.vars.independent];
    else
        X_2sls = [ones(n, 1), X_endo_hat, X_exo];
        X_2sls_labels = ["intercept", config.vars.independent, config.vars.control];
    end

    % Create a temporary data struct and run OLS for the second stage.
    data_2sls = struct;
    data_2sls.y = y;
    data_2sls.X = X_2sls;
    data_2sls.X_labels = X_2sls_labels;
    [output, se] = ols(data_2sls, config);
    output.Properties.VariableNames{'Beta_Estimado'} = 'Beta_Estimado_2sls';

    %% 5. F-Test for Overall Model Significance
    y_fit_2sls = X_2sls * output.Beta_Estimado_2sls;
    k_2sls = size(X_2sls, 2);
    [x_f_test, x_p_value] = calculate_model_f(y, y_fit_2sls, n, k_2sls);

    %% 6. Format Output
    fstats = table(z_f_test, z_p_value, x_f_test, x_p_value, ...
                   'VariableNames', {'F_inst', 'Pval_inst', 'F_x2ls', 'Pval_x2ls'});
end