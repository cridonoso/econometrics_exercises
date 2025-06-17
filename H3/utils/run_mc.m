function [poder_empirico, rejections] = run_mc(B, P, G, n_g, sigma_e, sigma_u, beta, alpha)
    addpath("utils") % add utils functions
    df = G-1; % freedom degrees
    t_crit = tinv(1 - alpha/2, df); %critic value 
    rejections = 0;
    cluster_idx_vec = repelem((1:G)', n_g, 1); % Creates a column vector
    for b = 1:B
        [X, Y] = gdprocess(P, G, n_g, sigma_e, sigma_u, beta);
    
        % MCO: Y ~ 1 + D
        beta_hat = (X' * X) \ (X' * Y);
        residuals = Y - X * beta_hat;
    
        % R selector for the second coefficient (D)
        R = zeros(size(X,2), 1); 
        R(2) = 1; % Assumes D is the second column in X

        % Cluster-Robust Standard Error:
        se_b = cluster_robust_se(X, residuals, cluster_idx_vec, R);

        t_stat = beta_hat(2) / se_b;
        if abs(t_stat) > t_crit
            rejections = rejections + 1;
        end
    end
    poder_empirico = rejections / B;
end
