function se_cr = cluster_robust_se(X, residuals, cluster_idx, R_selector)
    % Calculates cluster-robust standard errors (CRVE)
    % Formula: V_cr = (X'X)^-1 * B_clu_corrected * (X'X)^-1
    % where B_clu_corrected = sum_g (X_g' * u_g * u_g' * X_g) * correction_factor
    %
    % Inputs:
    %   X: N x K regressor matrix
    %   residuals: N x 1 vector of OLS residuals
    %   cluster_idx: N x 1 vector of cluster identifiers for each observation
    %   R_selector (optional): K x 1 column vector to select variance of R_selector'*beta.
    %                          If empty or not provided, returns SEs for all beta_k.
    %                          Example: for SE of beta_2 in [beta_1; beta_2], R_selector = [0; 1].

    N = size(X, 1); % Number of observations
    K = size(X, 2); % Number of parameters

    unique_clusters = unique(cluster_idx);
    G = length(unique_clusters); % Number of clusters

    % Calculate (X'X)^-1
    invXX = inv(X'*X);
    % Calculate B_clu = sum_g (X_g' u_g u_g' X_g)
    B_clu = zeros(K, K);
    for i = 1:G
        current_cluster_id = unique_clusters(i);
        cluster_members_idx = (cluster_idx == current_cluster_id);
        
        X_g = X(cluster_members_idx, :);
        u_g = residuals(cluster_members_idx);
        
        % Ensure u_g is a column vector for matrix multiplication
        if size(u_g, 2) > 1 
            u_g = u_g';
        end
        
        B_clu = B_clu + (X_g' * u_g * u_g' * X_g);
    end

    % Finite sample correction (similar to Stata's default for regress, vce(cluster))
    % Reference: Cameron & Miller (2015), "A Practitioner's Guide to Cluster-Robust Inference", eq. (12) [cite: 141]
    if G > 1 && (N - K) > 0
        correction_factor = (G / (G - 1)) * ((N - 1) / (N - K));
    else
        correction_factor = 1; % Avoid division by zero if G=1 or N=K
        if G <=1
            warning('Number of clusters (G) is <= 1. CRVE may not be appropriate or well-defined.');
        end
        if (N-K) <=0
             warning('(N-K) is <=0. Standard correction factor cannot be applied.');
        end
    end
    B_clu_corrected = B_clu * correction_factor;
    
    % Variance-Covariance matrix
    V_cr = invXX * B_clu_corrected * invXX;

    if nargin < 4 || isempty(R_selector)
        % Return standard errors for all coefficients
        var_hat_diag = diag(V_cr);
        % Ensure no negative variances due to numerical issues
        var_hat_diag(var_hat_diag < 0) = NaN; 
        se_cr = sqrt(var_hat_diag);
    else
        % Ensure R_selector is a column vector if it's for a single coefficient
        if size(R_selector, 1) ~= K || size(R_selector,2) ~= 1
            if size(R_selector,2) == K && size(R_selector,1) == 1 % if it's a row vector
                R_selector = R_selector'; % convert to column
            else
                error('R_selector must be a Kx1 vector or empty.');
            end
        end
        
        var_R_beta = R_selector' * V_cr * R_selector;
        if var_R_beta < 0
            var_R_beta = NaN; % Or handle error appropriately
             warning('Calculated variance is negative.');
        end
        se_cr = sqrt(var_R_beta);
    end
end