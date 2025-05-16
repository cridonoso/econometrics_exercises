function [X, Y] = gdprocess(P, G, n_g, sigma2_e, sigma2_u, tau)
% Generative data process
% P = treatment portion 
% J = Number of groups
% n_g = number of individuals per group

N = G*n_g; % total number of observations
num_treated = round(P * G);
treated_groups = randsample(G, num_treated);
D_group = zeros(G, 1);
D_group(treated_groups) = 1;

u_j = normrnd(0, sqrt(sigma2_u), G, 1);  % group effect

D = repelem(D_group, n_g);  % repeat vector N_g x 1
u = repelem(u_j, n_g);      % repeat vector N_g x 1

eps = normrnd(0, sqrt(sigma2_e), N, 1);  % individual error

Y = tau * D + u + eps;

X = [ones(N,1), D];

end

