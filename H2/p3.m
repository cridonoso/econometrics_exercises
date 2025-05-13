clearvars
clc
%% Question 1
rng(42); % set seed to reproduce the same charts    
addpath("utils") % add utils functions

N       = 100; % sample size
beta    = [1, 2, 1, -1]; % beta coefficients
K       = length(beta);
sigma_e = 1; % Variance values for U
alpha   = 5e-2;

% initialize estimation
n_iter = 500; % number of trials
beta_estimates = zeros(n_iter, length(beta));
err_cov_homo = zeros(n_iter, K, K); % homoskedastic covariance 
err_cov_hete = zeros(n_iter, K, K); % heteroskedastic covariance

rej_homo = 0;
rej_het  = 0;

for i=1:n_iter
    % define input matrix 
    X  = generate_data(N, [0, 0, 0], [1, 2, 1]);
    e  = sample_normal(N, 0, sigma_e);
    U  = X(:, 3).*e;
    
    % calculate target variable
    Y = X*beta' + U;
    
    % compute parameter estimates
    beta_hat = X \ Y;
    beta_estimates(i, :) = beta_hat;

    % compute estimated error (residuals)
    residuals = Y - X*beta_hat;
    
    % estimated standard error
    R  = [0; 0; 1; 0]; % taking b3 only
    var_homo = estimated_variance(residuals, X);
    err_cov_homo(i, :, :) = var_homo; % should we store all cov matrix?
    
    var_white = white_variance(residuals, X);
    err_cov_hete(i, :, :) = var_white;

    % t-test
    t_homo = (R'*beta_hat - beta*R) / sqrt(R' * var_homo * R);
    t_hete = (R'*beta_hat - beta*R) / sqrt(R' * var_white * R);
    
    % ==== CHECK  other === 
    t_crit = tinv(1-alpha/2, N-K);

    if abs(t_homo) > t_crit
            rej_homo = rej_homo + 1;
    end

    if abs(t_hete) > t_crit
            rej_het = rej_het + 1;
    end

end

%% PLOT
plot_covariances(err_cov_homo, err_cov_hete, './figures/covmatrices.pdf')

fprintf('Rechazos con matriz homocedástica: %d de %d (%.2f%%)\n', ...
    rej_homo, n_iter, 100*(rej_homo/n_iter));

fprintf('Rechazos con matriz robusta White: %d de %d (%.2f%%)\n', ...
    rej_het, n_iter, 100*(rej_het/n_iter));
