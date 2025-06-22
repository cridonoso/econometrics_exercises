function [output, se] = ols(data, config)
    X = data.X;
    y = data.y;
    [n, k] = size(X);
    beta = X \ y;
    residuals = y - X * beta;
    
    if strcmp(config.robust, 'true')
        fprintf('[INFO] White Kernel.\n');
        [~, se] = white_se(X, residuals);        
    else
        fprintf('[INFO] Classical OLS.\n');
        sigma2 = (residuals' * residuals) / (n - k);
        var_cov_matrix_classic = sigma2 * inv(X' * X);
        se = sqrt(diag(var_cov_matrix_classic));
    end
    
    output = table(data.X_labels', beta, 'VariableNames', {'Predictor', 'Beta_Estimado'});
end