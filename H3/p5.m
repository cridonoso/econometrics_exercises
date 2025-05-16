clearvars
clc
%% Question 5 
addpath("utils") % add utils functions

B = 1000;             % Num of simulations
G= 4;                 % Num of clusters
n_g = 620;            % Individuals per group
N = G*n_g;           % Total pop. size
rho = 0.05;           % intra-cluster correlation
sigma2 = 1;           % total variance
P = 0.5;              % treatment fraction
alpha = 0.05;         % significance
beta_true = 0.1;      % true effect

sigma2_u = rho*sigma2;        % individual variance
sigma2_e = (1 - rho)*sigma2;  % using Var(e) = 1

% MonteCarlo Simulation
rng(42); % set seed to reproduce the same charts

% Execution
[power, nrejec] = run_mc(B, P, G, n_g, sigma2_e, sigma2_u, beta_true, alpha);
fprintf('Rechazo hipotesis nula: %.1f%%\n', 100*power);


% logspace
%a = log10(10);
%b = log10(100000);
%n_gs = logspace(a, b, 20);
%n_gs = round(n_gs);
%n_gs = unique(n_gs); % Eliminar duplicados si el redondeo los crea

%Gs = [4, 8, 16, 32, 64, 128, 256, 512];
%values_to_show = zeros(1, length(n_gs));

%for j = 1:length(n_gs)
%    %[power, nrejec] = run_mc(B, P, G, n_gs(j), sigma2_e, sigma2_u, beta_true, alpha);
%    [power, nrejec] = run_mc(B, P, Gs(j), n_g, sigma2_e, sigma2_u, beta_true, alpha);
%    values_to_show(j) = 100*power;
%    fprintf('Rechazo hipotesis nula: %.1f%%\n', 100*power);
%end
%save('./backup/saved.mat', 'values_to_show', 'n_gs');
%save('./backup/saved_cluster.mat', 'values_to_show', 'Gs');

