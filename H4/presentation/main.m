clc, clearvars

script_dir = fileparts(mfilename('fullpath'));
cd(fileparts(script_dir));

addpath('data');      % data path
addpath('src/data')   % load functions
addpath('src/models') % load functions
addpath('src/arnd')   % load functions

config_file = './presentation/config/p3.json'; % problem specific configuration

config = load_json(config_file);
proyect_path = "./results/" + config.path;
if ~isfolder(proyect_path)
    fprintf('Directorio no encontrado. Creando ruta: %s\n', proyect_path);
    mkdir(proyect_path);
end

% Loading the data
[data, config] = load_data('./data/depresion_clean.csv', config);

if config.model_type == "probit"
    [output, logs] = probit(data, config);
    writetable(logs, fullfile(proyect_path, 'train_logs.csv'), 'WriteVariableNames', true);
end

if config.model_type == "2sls"
    [output, se_ols] = ols(data, config);
    [output_2sls, se_2sls, fval] = twosls(data, config);
    output = join(output, output_2sls);
    output.se = se_ols;
    output.se_2sls = se_2sls;
    writetable(fval, fullfile(proyect_path, 'f_values.csv'), 'WriteVariableNames', true);
end

if config.model_type == "within"
    [output, se_within] = within(data, config);
    output.se = se_within;
end

save_results(output, data, config, proyect_path)

