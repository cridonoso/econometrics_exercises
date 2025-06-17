clc, clearvars;

data = readtable('p1.csv');

% Definir variables
y_var      = 'phq_score';
exo_vars   = {'edad', 'sexo'};
endo_var   = 'niveleduc';
inst_vars  = {'matrimonio', 'separacion'};

% Crear las matrices numéricas
y      = data.(y_var);
X_exo  = data{:, exo_vars};
X_endo = data{:, endo_var};
Z_inst = data{:, inst_vars};

% Eliminar filas con datos faltantes (NaN)
full_data = [y, X_exo, X_endo, Z_inst];
filas_completas = ~any(ismissing(full_data), 2);
y      = y(filas_completas, :);
X_exo  = X_exo(filas_completas, :);
X_endo = X_endo(filas_completas, :);
Z_inst = Z_inst(filas_completas, :);


%% Estimar el modelo usando la función de MCO

% Construir la matriz X completa para OLS (constante, endógena, exógenas)
X_ols = [ones(size(y,1), 1), X_endo, X_exo];

% Llamar a la función de MCO
[beta_ols, se_ols] = calculate_ols(X_ols, y);

% Mostrar resultados
predictor_names_ols = ['Intercepto'; endo_var; exo_vars'];
resultados_ols = table(predictor_names_ols, beta_ols, se_ols, 'VariableNames', {'Predictor', 'Coeficiente', 'ErrorStd'});
disp(resultados_ols);


%% --- PASO 2: Estimar el modelo usando la función de 2SLS ---

% Llamar a la función de 2SLS con las matrices separadas
[beta_2sls, se_2sls] = calculate_2sls(y, X_endo, X_exo, Z_inst);

% Mostrar resultados
predictor_names_2sls = ['Intercepto'; endo_var; exo_vars'];
resultados_2sls = table(predictor_names_2sls, beta_2sls, se_2sls, 'VariableNames', {'Predictor', 'Coeficiente', 'ErrorStd'});
disp(resultados_2sls);