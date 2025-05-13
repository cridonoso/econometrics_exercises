function se_b = standard_error(X, residuals, n, J)
    %STANDARD_ERROR per cluster
    D = X(:, 2);
    D_mean = mean(D);
    num = (D - D_mean) .* residuals;
    num = reshape(num, n, J);
    num = mean(num, 1)';
    den = (1 / (J*var(D, 1)))^2;
    var_b = sum(num.^ 2)*den;
    se_b = sqrt(var_b);
end

