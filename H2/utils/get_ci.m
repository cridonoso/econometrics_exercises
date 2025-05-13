function ci_matrix = get_ci(alphas, beta_hat, var_hat, R, DF)
    % GET_IC Get Confidence Intervals given levels of confidence

    ci_matrix = zeros(length(alphas), 2);
    for i=1:length(alphas)
        % t-value
        t_crit = tinv(1 - alphas(i)/2, DF);
        % Cálculo del intervalo de confianza para el parámetro seleccionado
        lower_bound = R' * beta_hat - t_crit * sqrt(var_hat);
        upper_bound = R' * beta_hat + t_crit * sqrt(var_hat);
        
        ci_matrix(i, :) = [lower_bound; upper_bound];
    end

end

