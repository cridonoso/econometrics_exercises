clearvars
clc
addpath("utils")  % add utils functions

B = 1000;         % number of simulations
G = 40;           % number of groups
n_g = 10;         % individuals per group
rho = 0.05;       % ICC
sigma2 = 1;       % total variance
P = 0.5;          % treatment portion 
effect_sizes = [0.3, 0.4];  % true effects
alpha = 0.05;     % significance level

df = G*n_g - 2; % 2 regressors
t_crit = tinv(1 - alpha/2, df); %critic value 

sigma2_u = rho*sigma2;        % individual variance
sigma2_e = (1 - rho)*sigma2;  % using Var(e) = 1


for e = 1:length(effect_sizes)
    beta = effect_sizes(e);  % true effect
    rejections = 0;
    
    [power, nrej] = run_mc(B, P, G, n_g, sigma2_e, sigma2_u, beta, alpha);

    fprintf('Efecto = %.1f → Poder estimado: %.1f%%\n', beta, 100*power);
end