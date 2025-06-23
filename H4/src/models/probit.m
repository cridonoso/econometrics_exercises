function [output, train_logs] = probit(data, config)
%PROBIT Estimates a probit model using Maximum Likelihood Estimation (MLE).
%
%   This function finds the coefficients (betas) for a probit model that
%   maximize the log-likelihood function. It supports multiple optimization
%   routines and calculates standard errors and average marginal effects.
%
%   Inputs:
%       data    - A structure containing the model data.
%                 It must include the following fields:
%                 .y: Binary (0 or 1) dependent variable vector.
%                 .X: Matrix of independent variables.
%                 .X_labels: Cell array with names for the predictors in X.
%
%       config  - A structure with configuration settings.
%                 It should include the following field:
%                 .optimization: String, either "fminsearch" or "newton",
%                                to select the optimization algorithm.
%
%   Outputs:
%       output      - A table containing predictor names, estimated
%                     coefficients, standard errors, and average marginal effects.
%       train_logs  - A table containing the final log-likelihood value and
%                     the number of iterations.

    % Define settings for the optimization algorithm.
    options = optimset(...
        'MaxFunEvals', 5000, ...
        'MaxIter', 5000, ...
        'Display', 'none' ... % Suppress optimizer display.
    );

    X = data.X;

    % Create an anonymous function for the negative log-likelihood.
    loglike = @(b) loglikelihood(b, X, data.y);

    % Set the initial guess for coefficients to zero.
    initial_betas = zeros(size(X, 2), 1);

    % Find parameters using the specified optimization method.
    if config.optimization == "fminsearch"
        [min_betas, negLL] = fminsearch(loglike, initial_betas, options);
        iters = NaN; % fminsearch does not return iteration count directly.
        % Numerically compute the Hessian matrix for standard errors.
        H = hessian_f(loglike, min_betas);
        H_inv = H \ eye(size(H));
    elseif config.optimization == "newton"
        % Use a custom Newton-Raphson implementation.
        [min_betas, H_inv, negLL, iters] = newton_raphson(loglike, initial_betas, options);
    end

    % Standard errors are the sqrt of the diagonal of the inverse Hessian.
    se = sqrt(diag(H_inv));

    % Calculate Average Marginal Effects (AME).
    z = X * min_betas;
    f_z = normpdf(z); % Probability density function at z.
    marginal_effects = mean(f_z .* min_betas');

    % Format the output tables.
    output = table(data.X_labels', min_betas, se, marginal_effects', ...
    'VariableNames', {'Predictor', 'Beta_Estimado', 'se', 'emarginal'});

    train_logs = table(-negLL, iters, 'VariableNames', {'MaxL', 'iterations'});
end