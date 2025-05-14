
function [X, Y] = gdprocess(P, J, n_g, sigma2_e, sigma2_u, tau)
% Generative data process
% P = treatment portion 
% J = Number of groups
% n_g = number of individuals per group

N = J*n_g; % total number of observations
num_treated = round(P * J);
treated_groups = randsample(J, num_treated);
D_group = zeros(J, 1);
D_group(treated_groups) = 1;

u_j = normrnd(0, sqrt(sigma2_u), J, 1);  % group effect

D = repelem(D_group, n_g);  % repeat vector N_g x 1
u = repelem(u_j, n_g);      % repeat vector N_g x 1

eps = normrnd(0, sqrt(sigma2_e), N, 1);  % individual error

Y = tau * D + u + eps;

X = [ones(N,1), D];

end

