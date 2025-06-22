function [output_struct, config] = load_data(path, config)

table = readtable(path); % leemos la tabla de datos
output_struct = struct(); % to return

if config.debug=="true"
    n_samples = 20;
    n_total = height(table);
    random_indices = randperm(n_total);
    %random_indices = 1:n_total;
    random_sample = random_indices(1:n_samples);
    table = table(random_sample, :);
end
if config.on_missing == "delete"
    table = rmmissing(table);
    vars_ = [config.vars.independent; config.vars.dependent];
    is_numeric_flags = varfun(@isnumeric, table, 'InputVariables', vars_);
    numeric_vars = vars_(table2array(is_numeric_flags));
    data_subset = table{:, numeric_vars};
    rows_to_remove = any(data_subset == -99, 2);
    table = table(~rows_to_remove, :);

elseif config.on_missing == "preserve_x"
    table = rmmissing(table, 'DataVariables', {config.vars.dependent});
    rowstokeep = table.(config.vars.dependent) ~= -99;
    table = table(rowstokeep, :);
end

hay_nan = any(ismissing(table), 'all');

y = table.(config.vars.dependent); % dependent var
if config.log_y == "true"
    output_struct.y = log(y+1e-9);
else
    output_struct.y = y;
end

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
output_struct.id = table.id;

if config.normalize_x=="true"
    output_struct.X = normalize_matrix(output_struct.X);
end
if config.normalize_z=="true"
    output_struct.Z = normalize_matrix(output_struct.Z);
end

end


