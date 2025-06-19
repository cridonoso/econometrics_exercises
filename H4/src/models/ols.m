function [output, se] = ols(data, config)

    X = normalize_matrix(data.X);
    if config.log_y == "true"
        y=log(data.y+1e-9);
    else
        y=data.y;
    end
    [n, k] = size(X);
    beta = X \ y;
    residuals = y - X * beta;
    
    if strcmp(config.robust, 'true')
        fprintf('[INFO] White Kernel.\n');
        [vcov, se] = white_se(X, residuals);        
    else
        fprintf('[INFO] Classical OLS.\n');
        sigma2 = (residuals' * residuals) / (n - k);
        var_cov_matrix_classic = sigma2 * inv(X' * X);
        se = sqrt(diag(var_cov_matrix_classic));
    end
    
    output = table(data.X_labels', beta, 'VariableNames', {'Predictor', 'Beta_Estimado'});
end