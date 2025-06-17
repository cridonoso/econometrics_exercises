function negLL = probit_log_likelihood(betas, X, y)
% Calcula el negativo de la log-verosimilitud para un modelo Probit.

    % calcular el predictor lineal
    mu = X * betas;

    % calcular probabilidad de y=1 usando la CDF de la Normal (normcdf)
    p1 = normcdf(mu);

    % evitar valores extremos de 0 o 1 para prevenir log(0) -> -Inf
    epsilon = 1e-9;
    p1(p1 > 1 - epsilon) = 1 - epsilon;
    p1(p1 < epsilon) = epsilon;
    
    % calculo de log-verosimilitud
    % sum(y*log(p1) + (1-y)*log(1-p1))
    logL = sum(y .* log(p1) + (1 - y) .* log(1 - p1));

    % Devolver el negativo para la minimizacion
    negLL = -logL;
end