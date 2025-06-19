function [output_struct, config] = load_data(path, config)

table = readtable(path); % leemos la tabla de datos
output_struct = struct(); % to return

if config.on_missing == "delete"
    table = rmmissing(table, 'DataVariables', {config.vars.dependent});
    rowstokeep = table.(config.vars.dependent) ~= -99;
    table = table(rowstokeep, :);
end


y = table.(config.vars.dependent); % dependent var
output_struct.y = y;

X = ones(height(table), 1);
X_labels = {'intercept'};

[X_ind, ind_labels] = to_matrix(config.vars.independent, table);
[X_ctr, ctr_labels] = to_matrix(config.vars.control, table);
config.vars.independent = ind_labels;
config.vars.control = ctr_labels;

output_struct.X = [X, X_ind, X_ctr]; % these are the predictors
output_struct.X_labels = [X_labels, ind_labels, ctr_labels];

% intrumental variables if exist
[Z, Z_labels] = to_matrix(config.vars.instrumental, table);
output_struct.Z = Z;
output_struct.Z_labels = Z_labels;
config.vars.instrumental = Z_labels;

end


