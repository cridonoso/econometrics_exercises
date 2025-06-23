function [theta_hat, V_cov, logL_val, iter_to_converge] = newton_raphson(logL_fun, theta0, options)
%NEWTON_RAPHSON Maximizes a function using the Newton-Raphson algorithm.
%
%   This function implements the Newton-Raphson optimization method to find
%   the parameter vector that maximizes a given function, typically a
%   log-likelihood (logL) for Maximum Likelihood Estimation (MLE). It uses
%   numerical methods to compute the gradient and Hessian matrix.
%
%   Inputs:
%       logL_fun - A handle to the function to be maximized. It must accept
%                  a vector of parameters and return a scalar value.
%       theta0   - A column vector of initial values for the parameters.
%       options  - (Optional) A structure with optimizer settings:
%                  .max_iter: Maximum number of iterations (default: 1000).
%                  .tolerance: Convergence tolerance for the gradient's
%                              norm (default: 1e-6).
%                  .verbose: Set to true to display iteration progress
%                            (default: true).
%
%   Outputs:
%       theta_hat        - The estimated parameter vector at the maximum.
%       V_cov            - The variance-covariance matrix, computed as the
%                          inverse of the Hessian at theta_hat.
%       logL_val         - The value of the function at theta_hat.
%       iter_to_converge - The number of iterations performed.

% Set default options if not provided.
if nargin < 3, options = struct(); end
if ~isfield(options, 'max_iter'), options.max_iter = 1000; end
if ~isfield(options, 'tolerance'), options.tolerance = 1e-6; end
if ~isfield(options, 'verbose'), options.verbose = true; end

theta = theta0; % Initialize parameters with the starting guess.

if options.verbose
    fprintf('--- Iniciando Estimador MLE (derivadas numéricas) ---\n');
    fprintf('Iteración | Norma del Gradiente\n');
    fprintf('----------------------------------\n');
end

% Main optimization loop.
for i = 1:options.max_iter
    % Numerically compute the gradient and Hessian matrix.
    [gradient, ~, ~] = gradest(logL_fun, theta);
    hessian = hessian_f(logL_fun, theta);
    
    % Check for convergence.
    grad_norm = norm(gradient);
    
    if options.verbose, fprintf('%9d | %17.6f\n', i, grad_norm); end
        
    if grad_norm < options.tolerance
        if options.verbose, fprintf('Convergencia alcanzada.\n'); end
        break;
    end

    % Calculate the Newton-Raphson step and update parameters.
    step = hessian \ gradient';
    theta = theta - step;
end

if i == options.max_iter
    warning('No se alcanzó la convergencia en %d iteraciones.', options.max_iter);
end
% Assign output variables.
theta_hat = theta;
% Recalculate Hessian at the final point for accuracy.
final_hessian = hessian_f(logL_fun, theta_hat);
% The variance-covariance matrix is the inverse of the Hessian.
V_cov = inv(final_hessian);
logL_val = logL_fun(theta_hat);
iter_to_converge = i;
end