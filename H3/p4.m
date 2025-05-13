clearvars
clc
%% Question 4 
addpath("utils") % add utils functions

J = 40;           % number of groups
n = 10;           % individuals per group
rho = 0.05;       % ICC
sigma2_e = 1;     % individual variance (idiosincratica)
P = 0.5;          % treatment portion 
B = 1000;         % number of simulations
effect_sizes = [0.3, 0.4];  % true effects
alpha = 0.05;     % significance level
sigma2_u = rho/(1 - rho); % group variance

%% MonteCarlo Simulation
rng(42); % set seed to reproduce the same charts 
seeds = randi(1e6, B, 1); % set seed for each simulation

powers = zeros(size(effect_sizes));
for e = 1:length(effect_sizes)
    tau = effect_sizes(e);  % true effect
    rejections = 0;
    
    for b=1:B
        rng(seeds(b));  % reset interno
        % Data generation process
        [X, Y] = gdprocess(P, J, n, sigma2_e, sigma2_u, tau);
        
        % Linear regression
        beta_hat = (X' * X) \ (X' * Y);
        residuals = Y - X * beta_hat;
    
        % standar error per cluster  
        se_b = standard_error(X, residuals, n, J);
        
        % t stat 
        t_stat = beta_hat(2) / se_b;
         % bilateral rejection
        if abs(t_stat) > norminv(1 - alpha / 2)
            rejections = rejections + 1;
        end
    end
    powers(e) = rejections / B;
    fprintf('Efecto = %.1f → Poder estimado: %.1f%%\n', tau, 100 * powers(e));
end