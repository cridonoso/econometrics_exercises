clearvars
clc
addpath("utils") % add utils functions

B = 1000;             % Num of simulations
G= 4;                 % Num of clusters
n_g = 620;            % Individuals per group
N = G*n_g;            % Total pop. size
rho = 0.05;           % intra-cluster correlation
sigma2 = 1;           % total variance
P = 0.5;              % treatment fraction
alpha = 0.05;         % significance
beta_true = 0.1;      % true effect

sigma2_u = rho*sigma2;        % individual variance
sigma2_e = (1 - rho)*sigma2;  % using Var(e) = 1

%logspace search on n_g
a = log10(10);
b = log10(100000);
n_gs = logspace(a, b, 20);
n_gs = round(n_gs);
n_gs = unique(n_gs); % Eliminar duplicados si el redondeo los crea
values_to_show = zeros(1, length(n_gs));
for j = 1:length(n_gs)
   disp(j)
   [power, nrejec] = run_mc(B, P, G, n_gs(j), sigma2_e, sigma2_u, beta_true, alpha);
   values_to_show(j) = 100*power;
end
save('./backup/saved.mat', 'values_to_show', 'n_gs');

%logspace search on G
a = log10(4);
b = log10(512);
Gs = logspace(a, b, 20);
Gs = round(Gs);
Gs = unique(Gs); % Eliminar duplicados si el redondeo los crea
values_to_show = zeros(1, length(Gs));
for j = 1:length(Gs)
    disp(j)
    [power, nrejec] = run_mc(B, P, Gs(j), n_g, sigma2_e, sigma2_u, beta_true, alpha);
    values_to_show(j) = 100*power;
end
save('./backup/saved_cluster.mat', 'values_to_show', 'Gs');



