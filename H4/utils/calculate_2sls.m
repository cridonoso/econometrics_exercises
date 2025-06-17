function [beta, se] = calculate_2sls(y, X_endo, X_exo, Z_inst, varargin)
%calculate_2sls Estima por MC2E con errores estándar clásicos o robustos.
%
% Args:
%   y, X_endo, X_exo, Z_inst: matrices de datos.
%   varargin (char): Opcional. Escribir 'robust' para errores estándar de White.
%
% Returns:
%   beta, se: Coeficientes y errores estándar.

    [n, k_exo] = size(X_exo);
    k_endo = size(X_endo, 2);
    k = 1 + k_exo + k_endo;
    
    % --- Etapa 1 ---
    Z = [ones(n, 1), Z_inst, X_exo];
    X_endo_hat = Z * (Z \ X_endo);

    % --- Etapa 2 ---
    X_2sls = [ones(n, 1), X_endo_hat, X_exo];
    beta = X_2sls \ y;

    % --- Cálculo de Errores Estándar ---
    X_original = [ones(n, 1), X_endo, X_exo];
    residuals = y - X_original * beta;
    
    is_robust = false;
    if ~isempty(varargin) && strcmp(varargin{1}, 'robust')
        is_robust = true;
    end

    if is_robust
        fprintf('Calculando errores estándar robustos (White) para 2SLS.\n');
        Omega = diag(residuals.^2);
        % Para 2SLS, el kernel de white usa la matriz de instrumentos Z
        % en lugar de X. Específicamente, Pz = Z*inv(Z'Z)*Z'
        % La fórmula simplificada es V = inv(X_hat'X_hat) * (X_hat' * Omega * X_hat) * inv(X_hat'X_hat)
        % donde X_hat es X_2sls.
        X_hat_omega_X_hat = X_2sls' * Omega * X_2sls;
        inv_Xhat_Xhat = inv(X_2sls' * X_2sls);
        
        var_cov_matrix_robust = (n / (n - k)) * inv_Xhat_Xhat * X_hat_omega_X_hat * inv_Xhat_Xhat;
        se = sqrt(diag(var_cov_matrix_robust));
    else
        fprintf('Calculando errores estándar clásicos para 2SLS.\n');
        sigma2 = (residuals' * residuals) / (n - k);
        var_cov_matrix_classic = sigma2 * inv(X_2sls' * X_2sls);
        se = sqrt(diag(var_cov_matrix_classic));
    end
end