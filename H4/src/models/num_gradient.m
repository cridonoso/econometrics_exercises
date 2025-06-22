function G = num_gradient(fun, theta)
% NUMERICAL_GRADIENT Calcula el gradiente de una función en un punto dado
%                    usando el método de diferencias finitas centrales.
%
% Entradas:
%   fun:    Handle a la función a diferenciar.
%   theta:  Vector columna del punto donde se evalúa el gradiente.
%
% Salida:
%   G:      Vector columna con el gradiente numérico.
%
n_params = length(theta);
G = zeros(n_params, 1); % Inicializamos el vector gradiente
epsilon = 1e-6; % Un paso pequeño para la diferenciación
for j = 1:n_params
    % Creamos los vectores para el paso "hacia adelante" y "hacia atrás"
    theta_plus = theta;
    theta_minus = theta;
    
    % Movemos únicamente el j-ésimo parámetro
    theta_plus(j) = theta(j) + epsilon;
    theta_minus(j) = theta(j) - epsilon;
    
    % Calculamos la derivada parcial para el j-ésimo parámetro
    G(j) = (fun(theta_plus) - fun(theta_minus)) / (2 * epsilon);
end

end