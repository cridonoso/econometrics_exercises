function [output, se, fstats] = twosls(data, config)
% TWOSLS Performs a Two-Stage Least Squares (2SLS) regression.
    y = data.y;
    X = data.X;
    Z_inst = data.Z;
    
    X_endo = gather_matrix(X, data.X_labels, config.vars.independent);
    X_exo  = gather_matrix(X, data.X_labels, config.vars.control);

    [n, L] = size(Z_inst); % n=obs, L=number of instruments

    if L == 0
        error('Error: No instruments (Z) were provided for the endogenous variable.');
    end

    %% --- Step 1: First-Stage Regression ---
    
    % Build the first-stage regressor matrix
    if isempty(X_exo)
        X_unrestricted = [ones(n, 1), Z_inst];
    else
        X_unrestricted = [ones(n, 1), X_exo, Z_inst];
    end
    
    % Using instrumental variables to regress the endo variable
    b_unrestricted = X_unrestricted \ X_endo;
    X_endo_hat = X_unrestricted * b_unrestricted;
    
    % get residuals for the endogenous variable
    residuals_u = X_endo - X_endo_hat;
    RSS_u = sum(residuals_u.^2); % unrestricted residuals

    % For the F-test, we need to predict without instrument.
    if isempty(X_exo)
        X_restricted = ones(n, 1);
    else
        X_restricted = [ones(n, 1), X_exo];
    end
    b_restricted = X_restricted \ X_endo;
    residuals_r = X_endo - X_restricted * b_restricted;
    RSS_r = sum(residuals_r.^2); % restricted residuals
    
    % Calculate the F-stat reusing RSS_u
    q = L; % Number of restrictions = number of instruments
    k_unrestricted = size(X_unrestricted, 2);
    df_den = n - k_unrestricted; % degree of freedom
    z_f_test  = ((RSS_r - RSS_u) / q) / (RSS_u / df_den);
    z_p_value = 1 - fcdf(z_f_test, q, df_den);
    
    
    %% --- Step 2: Run Second Stage ---
    
    % here we use the x_endo_hat from the previous step
    if isempty(X_exo)
        X_2sls = [ones(n, 1), X_endo_hat]; 
        X_2sls_labels = ["intercept", config.vars.independent];
    else % if there is control then add it
        X_2sls = [ones(n, 1), X_endo_hat, X_exo];
        X_2sls_labels = ["intercept", config.vars.independent, config.vars.control];
    end

    % This is for consistence with our ols method.
    data_2sls = struct;
    data_2sls.y = y;
    data_2sls.X = X_2sls;
    data_2sls.X_labels = X_2sls_labels;
    [output, se] = ols(data_2sls, config);
    % Changing the name to join with OLS results
    output.Properties.VariableNames{'Beta_Estimado'} = 'Beta_Estimado_2sls';
    
    % Calculate F-test for the final model
    y_fit_2sls = X_2sls * output.Beta_Estimado_2sls;
    k_2sls = size(X_2sls, 2);
    [x_f_test, x_p_value] = calculate_model_f(y, y_fit_2sls, n, k_2sls);
    fstats = table(z_f_test,z_p_value,x_f_test, x_p_value, 'VariableNames', {'F_inst', 'Pval_inst', 'F_x2ls', 'Pval_x2ls'});
end