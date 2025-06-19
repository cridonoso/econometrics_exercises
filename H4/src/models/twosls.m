function [output, se] = twosls(data, config)
    
    X = normalize_matrix(data.X);
    Z_inst = normalize_matrix(data.Z);


    X_endo = gather_matrix(X, data.X_labels, config.vars.independent);
    X_exo  = gather_matrix(X, data.X_labels, config.vars.control);

    [n, k_exo] = size(X_exo);

    % % --- step 1 ---
    Z = [ones(n, 1), Z_inst, X_exo];

    X_endo_hat = Z * (Z \ X_endo);

    % --- Cálculo manual del estadístico F de la primera etapa ---
    residuals_first_stage = X_endo - X_endo_hat;
    RSS_first_stage = sum(residuals_first_stage.^2);
    TSS_first_stage = sum((X_endo - mean(X_endo)).^2);
    ESS_first_stage = TSS_first_stage - RSS_first_stage;
    
    num_regressors_first_stage = size(Z, 2); % Incluye el intercepto
    df1_first_stage = num_regressors_first_stage - 1; 
    df2_first_stage = n - num_regressors_first_stage;
    
    % Asegurarse de que df1_first_stage no sea cero para evitar división por cero
    if df1_first_stage == 0
        F_statistic_first_stage = NaN; % O manejarlo como un error
        warning('No hay predictores en la primera etapa más allá del intercepto para calcular el estadístico F de instrumentos.');
    else
        F_statistic_first_stage = (ESS_first_stage / df1_first_stage) / (RSS_first_stage / df2_first_stage);
    end
    F_statistic_first_stage

    % % --- Etapa 2 ---
    X_2sls = [ones(n, 1), X_endo_hat, X_exo];
    data.X = X_2sls;
    data.X_labels=["intercept", config.vars.independent, config.vars.control];
    [output, se] = ols(data, config);
    output.Properties.VariableNames{'Beta_Estimado'} = 'Beta_Estimado_2sls';
end