clc, clearvars

script_dir = fileparts(mfilename('fullpath'));
cd(fileparts(script_dir));

addpath('data'); % data path
addpath('src/data') % load functions
addpath('src/models') % load functions

config_file = './presentation/config/p2.json'; % problem specific configuration

config = load_json(config_file);

[data, config] = load_data('./data/depresion_clean.csv', config);

if config.model_type == "probit"
    output = probit(data, config);
end

if config.model_type == "2sls"
    [output, se_ols] = ols(data, config);
    [output_2sls, se_2sls] = twosls(data, config);
    output = join(output, output_2sls);
    output.se = se_ols;
    output.se_2sls = se_2sls;
end

% disp('Coeficientes (Betas) estimados para el modelo Probit:');
% disp(output);