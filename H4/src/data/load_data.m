function [output_struct, config] = load_data(path, config)
%LOAD_DATA Loads and preprocesses data for statistical modeling.
%
%   This function serves as a comprehensive data pipeline. It reads data
%   from a file, handles missing values, constructs design matrices for
%   predictors (X) and instruments (Z), and optionally normalizes them.
%   It returns a structure with the processed data and an updated config file.
%
%   Inputs:
%       path    - A string containing the path to the data file (e.g., a .csv).
%       config  - A structure with configuration options, including:
%                 .debug: "true" to run on a small random sample.
%                 .on_missing: "delete" for listwise deletion or
%                              "preserve_x" to only check the dependent var.
%                 .log_y: "true" to apply a log-transformation to y.
%                 .normalize_x: "true" to standardize the X matrix.
%                 .normalize_z: "true" to standardize the Z matrix.
%                 .vars: A struct with cell arrays of variable names for
%                        .dependent, .independent, .control, .instrumental.
%
%   Outputs:
%       output_struct - A structure containing the processed data with fields
%                       like .y, .X, .Z, .id, and corresponding labels.
%       config        - The configuration structure, updated with the new
%                       variable labels generated during dummy creation.

% Read the data table from the specified path.
table = readtable(path);
output_struct = struct(); % Initialize the output structure.

% If in debug mode, take a small random sample of the data.
if config.debug == "true"
    n_samples = 20;
    n_total = height(table);
    random_indices = randperm(n_total);
    random_sample = random_indices(1:n_samples);
    table = table(random_sample, :);
end

% Handle missing data based on the chosen strategy.
if config.on_missing == "delete"
    % Strategy 1: Listwise deletion for standard missing values (NaN, etc.).
    table = rmmissing(table);
    % Also perform listwise deletion for numeric variables coded as -99.
    vars_ = [config.vars.independent; config.vars.dependent];
    is_numeric_flags = varfun(@isnumeric, table, 'InputVariables', vars_);
    numeric_vars = vars_(table2array(is_numeric_flags));
    data_subset = table{:, numeric_vars};
    rows_to_remove = any(data_subset == -99, 2);
    table = table(~rows_to_remove, :);

elseif config.on_missing == "preserve_x"
    % Strategy 2: Delete rows only if the dependent variable is missing.
    table = rmmissing(table, 'DataVariables', {config.vars.dependent});
    rowstokeep = table.(config.vars.dependent) ~= -99;
    table = table(rowstokeep, :);
end

% Extract and optionally log-transform the dependent variable.
y = table.(config.vars.dependent);
if config.log_y == "true"
    output_struct.y = log(y + 1e-9);
else
    output_struct.y = y;
end

% Initialize the design matrix X with an intercept.
X = ones(height(table), 1);
X_labels = {'intercept'};

% Process independent and control variables using 'to_matrix' helper.
[X_ind, ind_labels] = to_matrix(config.vars.independent, table);
[X_ctr, ctr_labels] = to_matrix(config.vars.control, table);

% Update config with new labels from dummy variable creation.
config.vars.independent = ind_labels;
config.vars.control = ctr_labels;

% Assemble the final predictor matrix and labels.
output_struct.X = [X, X_ind, X_ctr];
output_struct.X_labels = [X_labels, ind_labels, ctr_labels];

% Process instrumental variables, if they exist.
[Z, Z_labels] = to_matrix(config.vars.instrumental, table);
output_struct.Z = Z;
output_struct.Z_labels = Z_labels;
config.vars.instrumental = Z_labels;

% Extract panel data identifiers.
output_struct.id = table.id;

% Optionally, normalize the predictor and instrument matrices.
if config.normalize_x == "true"
    output_struct.X = normalize_matrix(output_struct.X);
end
if config.normalize_z == "true"
    output_struct.Z = normalize_matrix(output_struct.Z);
end

end