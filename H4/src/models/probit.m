function [output, train_logs] = probit(data, config)
    options = optimset(...
        'MaxFunEvals', 5000, ...  % Puedes ajustar este valor
        'MaxIter', 5000,      ...  % Puedes ajustar este valor
        'Display', ''     ...  % Muestra información en cada iteración
    );

    X = data.X;
    loglike = @(b) loglikelihood(b, X, data.y);

    initial_betas = zeros(size(X, 2), 1);

    if config.optimization == "fminsearch"
        [min_betas, negLL] = fminsearch(loglike, initial_betas, options);
        iters = 0;
        H = hessian_f(loglike, min_betas); % thanks John D'Errico
        H_inv = H \ eye(size(H));
    elseif config.optimization == "newton"
        [min_betas, H_inv, negLL, iters] = newton_raphson(loglike, initial_betas, options);
    end
    se = sqrt(diag(H_inv));
    z = X * min_betas;
    f_z = normpdf(z);
    marginal_effects = min_betas' .* f_z;
    marginal_effects = mean(marginal_effects, 1);
    output = table(data.X_labels', min_betas, se, marginal_effects',...
    'VariableNames', {'Predictor', 'Beta_Estimado', 'se', 'emarginal'});
    train_logs = table(-negLL, iters, 'VariableNames', {'MaxL', 'iterations'});
end