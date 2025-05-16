function [poder_empirico, rejections] = run_mc(B, P, G, n_g, sigma_e, sigma_u, beta, alpha)
    addpath("utils") % add utils functions
    df = G-1; % freedom degrees
    t_crit = tinv(1 - alpha/2, df); %critic value 
    rejections = 0;
    for b = 1:B
        [X, Y] = gdprocess(P, G, n_g, sigma_e, sigma_u, beta);
    
        % Estimación por MCO: Y ~ 1 + D
        beta_hat = (X' * X) \ (X' * Y);
        residuals = Y - X * beta_hat;
    
        %se_b = standard_error(X, residuals, n_g, G);
        R = [0, 1]';
        se_b = white_hc_se(residuals, X, R);
    
        t_stat = beta_hat(2) / se_b;
        if abs(t_stat) > t_crit
            rejections = rejections + 1;
        end
    end
    poder_empirico = rejections / B;
end
