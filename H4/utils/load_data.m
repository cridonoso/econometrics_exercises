function [y, X, X_labels] = load_data(path, y_name, numeric_regressors, categorical_regressors)
% Esta función GENERALIZADA carga y pre-procesa datos.
% Acepta como parámetros los nombres de las columnas a utilizar.
addpath('data');

T = readtable(path); % leemos la tabla de datos

y = T.(y_name); % variable dependiente

X = ones(height(T), 1);
X_labels = {'Intercepto'};

% variables numericas
for i = 1:length(numeric_regressors)
    var_name = numeric_regressors{i};
    X = [X, T.(var_name)]; % concat
    X_labels = [X_labels, var_name];
end

% variables categoricas
for i = 1:length(categorical_regressors)
    var_name = categorical_regressors{i};
    
    % Convierte la columna a tipo categórico para trabajar con ella
    cat_col = categorical(T.(var_name));
    categories_list = categories(cat_col);
    
    % Si solo hay 2 categorías, el proceso es más simple
    if length(categories_list) == 2
        dummy_var = (cat_col == categories_list{2});
        X = [X, dummy_var];
        X_labels = [X_labels, strcat(var_name, '_', categories_list{2})];
    else 
        D_matrix = dummyvar(cat_col);
        
        % La primera categoría en la lista ('categories_list{1}') será la referencia.
        % Por lo tanto, omitimos la primera columna de la matriz de dummies.
        X = [X, D_matrix(:, 2:end)];
        
        % Creamos las etiquetas para las nuevas columnas dummy
        for j = 2:length(categories_list)
            new_label = strcat(var_name, '_', categories_list{j});
            X_labels = [X_labels, new_label];
        end
    end
end

fprintf('Procesamiento de datos completado.\n');
fprintf('Tamaño de la matriz X: %d filas, %d columnas.\n', size(X, 1), size(X, 2));

end


