clearvars
clc
%% Question 1
rng(42); % set seed to reproduce the same charts    
addpath("utils") % add utils functions

N       = 100; % sample size
beta    = [1, 2, 1, -1]; % beta coefficients
K       = length(beta);
sigma_u = [1, 2, 10]; % Variance values for U
conflev = [1e-2, 5e-2, 1e-1]; % confidence levels

% initialize estimation
n_iter = 500; % number of trials
beta_estimates = zeros(length(sigma_u), n_iter, length(beta));
errs_estimates = zeros(length(sigma_u), n_iter);
conf_intervals = zeros(length(sigma_u), n_iter, length(conflev), 2);

for j=1:length(sigma_u)
    for i=1:n_iter
        % define input matrix 
        X = generate_data(N, [0, 0, 0], [1, 2, 1]);
        U = sample_normal(N, 0, sigma_u(j));
        
        % calculate target variable
        Y = X*beta' + U;
        
        % compute parameter estimates
        beta_hat = X \ Y;
        beta_estimates(j, i, :) = beta_hat;
    
        % compute estimated error (residuals)
        residuals = Y - X*beta_hat;
        
        % estimated standard error
        R  = [0; 0; 0; 1]; % taking b3 only
        var_hat = estimated_variance(residuals, X, R);
        errs_estimates(j, i, :) = sqrt(var_hat);
        
        % confidence intervals
        ci = get_ci(conflev, beta_hat, var_hat, R, N-K);
        conf_intervals(j, i, :, :) = ci;
    end
end

% returns a summary with the number of success made
% columns = alpha confidence level
% row = sigma
stats = summary(conf_intervals, beta(4));
stats % display stats