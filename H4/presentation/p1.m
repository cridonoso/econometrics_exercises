clc, clearvars
addpath('utils') % cargar funciones

num_cols = {'phq_score'};
cat_cols = {};
y_var    = 'trabaja';

% Crear la matriz de diseño X y el vector y
[y, X, X_labels ]= load_data('p1.csv', y_var, num_cols, cat_cols);

% creamos un placeholder de los beta para crear la funcion objetivo
objective_function = @(b) probit_log_likelihood(b, X, y);

disp('Iniciando optimización con fminsearch...');
initial_betas = zeros(size(X, 2), 1);
[betas_optimizados, negLogL] = fminsearch(objective_function, initial_betas);
fprintf('\nOptimización finalizada.\n');
fprintf('Valor de la log-verosimilitud en el óptimo: %f\n', -negLogL);

% Mostrar los coeficientes estimados en una tabla
resultados = table(X_labels', betas_optimizados, 'VariableNames', {'Predictor', 'Beta_Estimado'});

disp('Coeficientes (Betas) estimados para el modelo Probit:');
disp(resultados);