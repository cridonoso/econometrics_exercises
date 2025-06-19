function negLL = loglikelihood(betas, X, y)
% Calcula el negativo de la log-verosimilitud para un modelo Probit.

    % linear predictor
    mu = X * betas;

    % prob. y=1 using CDF (normcdf)
    p1 = normcdf(mu);

    % avoid log(0) -> -Inf
    epsilon = 1e-9;
    p1(p1 > 1 - epsilon) = 1 - epsilon;
    p1(p1 < epsilon) = epsilon;
    
    % sum(y*log(p1) + (1-y)*log(1-p1))
    logL = sum(y .* log(p1) + (1 - y) .* log(1 - p1));

    negLL = -logL;
end