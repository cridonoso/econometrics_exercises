function se_cr = cluster_robust_se(X, residuals, cluster_idx, R_selector)
    % Calculates cluster-robust standard errors 
    % Inputs:
    %   X: N x K regressor matrix
    %   residuals: N x 1 vector of OLS residuals (must be a column vector)
    %   cluster_idx: N x 1 vector of cluster identifiers
    %   R_selector (optional): K x 1 vector to select variance of R_selector'*beta.
    %                          If empty, returns SEs for all beta_k.

    N = size(X, 1); % Number of observations
    K = size(X, 2); % Number of parameters

    % Map cluster_idx to 1:G for accumarray
    [~, ~, group_indices_1_to_G] = unique(cluster_idx);
    G = max(group_indices_1_to_G); % Number of clusters
    
    XTX = X'*X;
    Xu = X .* residuals; % Element-wise, residuals broadcast if X is matrix

    S_g_prime_matrix = zeros(G, K);
    for k_col = 1:K
        S_g_prime_matrix(:, k_col) = accumarray(group_indices_1_to_G, Xu(:, k_col), [G 1], @sum, 0);
    end
    
    % Calculate B_clu = sum_g (s_g * s_g')
    B_clu = S_g_prime_matrix' * S_g_prime_matrix;

    % Correction factor
    if G > 1 && (N - K) > 0
        correction_factor = (G / (G - 1)) * ((N - 1) / (N - K));
    else
        correction_factor = 1; 
    end
    B_clu_corrected = B_clu * correction_factor;
    
    % A\B is inv(A)*B and B/A is B*inv(A)
    Z = XTX \ B_clu_corrected; 
    V_cr = Z / XTX;
    V_cr = (V_cr + V_cr') / 2;

    var_R_beta = R_selector' * V_cr * R_selector;
    se_cr = sqrt(var_R_beta);
end