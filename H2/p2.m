clearvars
clc
%% Question 1
rng(42); % set seed to reproduce the same charts    
addpath("utils") % add utils functions

N       = [50, 100, 500]; % sample size
beta    = [1, 2, 1, -1]; % beta coefficients
K       = length(beta);
sigma_u = 2; % Variance values for U
conflev = [1e-2, 5e-2, 1e-1]; % confidence levels
alpha_p22 = 5e-2 ; % significance level for t-test

% initialize estimation
n_iter = 500; % number of trials
beta_estimates = zeros(length(N), n_iter, length(beta));
errs_estimates = zeros(length(N), n_iter);
conf_intervals = zeros(length(N), n_iter, length(conflev), 2);
b2test_reject  = zeros(length(N), n_iter, 2);

for j=1:length(N)
    for i=1:n_iter
        % define input matrix 
        X = generate_data(N(j), [0, 0, 0], [1, 2, 1]);
        U = sample_normal(N(j), 0, sigma_u);
        
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
        ci = get_ci(conflev, beta_hat, var_hat, R, N(j)-K);
        conf_intervals(j, i, :, :) = ci;
    
        % 2.2 hypothesys testing
        R2 = [0; 0; 1; 0];
        var_hat = estimated_variance(residuals, X, R2);
        
        t_stat_05 = (beta_hat(3) - 0.5) / sqrt(var_hat);
        t_stat_1  = (beta_hat(3) - 1) / sqrt(var_hat);
        t_crit = tinv(1-alpha_p22/2, N(j)-K);

        if abs(t_stat_05) > t_crit
            b2test_reject(j, i, 1) = 1;
        end

        if abs(t_stat_1) > t_crit
            b2test_reject(j, i, 2) = 1;
        end
    end
end

% returns a summary with the number of success made
% columns = alpha confidence level
% row = sigma
stats = summary(conf_intervals, beta(4));
display(stats); % display stats
nrejections = sum(b2test_reject, 2); % num of rejections b2 ttest
nrejections = squeeze(nrejections); % remove extra dim
display(nrejections)