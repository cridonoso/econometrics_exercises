function output = probit(data, config)
    options = optimset(...
        'MaxFunEvals', 5000, ...  % Puedes ajustar este valor
        'MaxIter', 5000,      ...  % Puedes ajustar este valor
        'Display', ''     ...  % Muestra información en cada iteración
    );
    data.X
    X = normalize_matrix(data.X);
    loglike = @(b) loglikelihood(b, X, data.y);

    initial_betas = zeros(size(X, 2), 1);
    [min_betas, negLL] = fminsearch(loglike, initial_betas, options);
    fprintf('Valor de la log-verosimilitud en el óptimo: %f\n', -negLL);

    output = table(data.X_labels', min_betas, 'VariableNames', {'Predictor', 'Beta_Estimado'});
end