clearvars
clc
%% Question 5 
addpath("utils") % add utils functions

B = 1000;             % Num of simulations
J = 4;                % Num of clusters
n_g = 784;            % Individuals per group
N = J * n_g;          % Total pop. size
rho = 0.05;           % intra-cluster correlation
sigma2 = 1;           % total variance
P = 0.5;              % treatment fraction
alpha = 0.05;         % significance
beta_true = 0.1;      % true effect
%z_crit = norminv(1 - alpha/2);  % critic value 
df = J - 2; % 2 regressors
t_crit = tinv(1 - alpha/2, df); %critic value 

sigma2_u = rho*sigma2;         % individual variance
sigma2_e = (1 - rho)*sigma2;  % using Var(e) = 1
%% Monte carlo 
rng(42); % set seed to reproduce the same charts 

seeds = randi(1e6, B, 1); % set seed for each simulation

rejections = 0;
for b = 1:B
    [X, Y] = gdprocess(P, J, n_g, sigma2_e, sigma2_u, beta_true);

    % Estimación por MCO: Y ~ 1 + D
    beta_hat = (X' * X) \ (X' * Y);
    residuals = Y - X * beta_hat;

    se_b = standard_error(X, residuals, n_g, J);

    t_stat = beta_hat(2) / se_b;
    if abs(t_stat) > t_crit
        rejections = rejections + 1;
    end
end

% -------------------------------
% RESULTADO FINAL
% -------------------------------
poder_empirico = rejections / B;
fprintf('Poder empírico: %.3f\n', poder_empirico);