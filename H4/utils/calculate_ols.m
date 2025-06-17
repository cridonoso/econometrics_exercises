function [beta, se] = calculate_ols(X, y, varargin)
%calculate_ols Estima coeficientes y errores estándar por MCO.
%   Permite el cálculo de errores estándar robustos a la heterocedasticidad (White).
%
%   Args:
%       X (matrix): Matriz de diseño (predictores), incluyendo intercepto.
%       y (vector): Vector de la variable dependiente.
%       varargin (char): Argumento opcional. Escribir 'robust' para
%                        calcular errores estándar de White.
%
%   Returns:
%       beta (vector): Vector de coeficientes estimados.
%       se (vector):   Vector de errores estándar (clásicos o robustos).

    % Paso 1: Estimar coeficientes
    [n, k] = size(X);
    beta = X \ y;

    % --- Paso 2: Calcular errores estándar ---
    residuals = y - X * beta;
    
    % Revisar si se pidió la opción 'robust'
    is_robust = false;
    if ~isempty(varargin) && strcmp(varargin{1}, 'robust')
        is_robust = true;
    end

    if is_robust
        fprintf('Calculando errores estándar robustos (White).\n');
        % Matriz Omega con los residuos al cuadrado en la diagonal
        Omega = diag(residuals.^2);
        
        % kernel de white
        X_omega_X = X' * Omega * X;
        
        % Inversa de (X'X)
        inv_XX = inv(X' * X);
        
        % La fórmula del kernel de White con corrección de muestra pequeña (HC1)
        var_cov_matrix_robust = (n / (n - k)) * inv_XX * X_omega_X * inv_XX;
        
        se = sqrt(diag(var_cov_matrix_robust));
        
    else
        % Cálculo de Errores Estándar Clásicos (Homocedásticos)
        fprintf('Calculando errores estándar clásicos.\n');
        sigma2 = (residuals' * residuals) / (n - k);
        var_cov_matrix_classic = sigma2 * inv(X' * X);
        se = sqrt(diag(var_cov_matrix_classic));
    end
end