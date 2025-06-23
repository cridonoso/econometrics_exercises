function negLL = loglikelihood(betas, X, y)
%LOGLIKELIHOOD Calculates the negative log-likelihood for a probit model.
%
%   This function computes the log-likelihood value for a set of binary
%   outcomes given the model parameters. It returns the *negative* of this
%   value, making it suitable for minimization-based optimizers like
%   fminsearch or Newton-Raphson.
%
%   Inputs:
%       betas   - A column vector of model coefficients.
%       X       - A matrix of independent variables (regressors).
%       y       - A column vector of the binary (0/1) dependent variable.
%
%   Output:
%       negLL   - The scalar value of the negative log-likelihood.

    % Calculate the linear predictor.
    mu = X * betas;

    % Compute the probability of y=1 using the standard normal CDF.
    p1 = normcdf(mu);

    % Clamp probabilities to avoid log(0), which results in -Inf.
    epsilon = 1e-9;
    p1(p1 > 1 - epsilon) = 1 - epsilon;
    p1(p1 < epsilon) = epsilon;

    % Calculate the log-likelihood using the standard formula for binary models.
    logL = sum(y .* log(p1) + (1 - y) .* log(1 - p1));

    % Return the negative of the log-likelihood for minimization.
    negLL = -logL;
end