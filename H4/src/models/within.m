function [output, se] = within(data, config)
    % WITHIN Implements the Within (Fixed Effects) estimator for panel data.
    %
    %   results = within(y, x, id)
    %
    %   Inputs:
    %     data:  Data structure with data and labels.
    %     config:  Config file.
    %
    %   Outputs:
    %     results: A struct containing the estimation results.
    %% 1. GET DIMENSIONS AND MATRICES
    % Get the dimensions of our data.
    % n = total number of observations
    % k = number of regressors
    % N = number of individuals/groups in the panel
    x = normalize_matrix(data.X);
    if config.log_y == "true"
        y=log(data.y+1e-9);
    else
        y=data.y;
    end
    id = data.id;
    [n, k] = size(x);
    [unique_vals, ~, id_sequential] = unique(id);
    N = length(unique_vals);

    %% 2. WITHIN TRANSFORMATION (DEMEAN THE DATA)
    % For each variable, we subtract its group mean.
    
    % Initialize matrices for the transformed data.
    y_demeaned = zeros(n, 1);
    x_demeaned = zeros(n, k);
    
    % Count how many observations (T_i) there are for each group.
    counts = accumarray(id_sequential, 1);
    
    % Demean the dependent variable 'y'.
    y_sums = accumarray(id_sequential, y);      % Sum of 'y' by group.
    y_means = y_sums ./ counts;                 % Mean of 'y' by group.
    y_group_means = y_means(id_sequential);     % Expand the means to the original size.
    y_demeaned = y - y_group_means;             % Subtract the group mean.

    % Repeat the process for each column of the 'x' matrix.
    x_demeaned = zeros(n, k); % Pre-allocate for speed
    for i = 1:k
        x_col_sums = accumarray(id_sequential, x(:, i));
        x_col_means = x_col_sums ./ counts;
        x_col_group_means = x_col_means(id_sequential);
        x_demeaned(:, i) = x(:, i) - x_col_group_means;
    end
    
    %% 3. OLS ESTIMATION ON TRANSFORMED DATA
    % Now that the data is demeaned, we apply the OLS formula.
    
    beta = (x_demeaned' * x_demeaned) \ (x_demeaned' * y_demeaned);
    
    e = y_demeaned - x_demeaned * beta;

    % Calculate the error variance (s^2).
    if strcmp(config.robust, 'true')
        fprintf('[INFO] White Kernel.\n');
        [vcov, se] = white_se(x, e);        
    else
        fprintf('[INFO] Classical OLS.\n');
        df = n - k - N;
        s2 = (e' * e) / df;
        vcov = s2 * inv(x_demeaned' * x_demeaned);
        se = sqrt(diag(vcov));
    end

    output = table(data.X_labels', beta, 'VariableNames', {'Predictor', 'Beta_Estimado'});

end