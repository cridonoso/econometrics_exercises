function [X, X_labels] = to_matrix(vars, table)
%TO_MATRIX Converts specified table variables into a numerical design matrix.
%
%   This function processes a list of variables from a MATLAB table to
%   create a numerical matrix 'X' suitable for statistical modeling. It
%   handles both numeric and categorical data types, creating dummy variables
%   and performing mean imputation where necessary.
%
%   Inputs:
%       vars    - A cell array of strings containing the names of the
%                 columns from 'table' to be processed.
%       table   - The input MATLAB table containing the dataset.
%
%   Outputs:
%       X       - The resulting numerical matrix, ready for modeling.
%       X_labels- A string array of labels for each column of 'X'.

    X = [];
    X_labels = string([]);
    
    % Iterate through each variable name provided.
    for index = 1:length(vars)
        current_var_name = vars{index};
        current_column = table.(current_var_name);

        % --- Process categorical (string or cell) variables ---
        if iscellstr(current_column) || isstring(current_column)
            % Replace missing string values with a 'NoData' category.
            missing_idx = ismissing(current_column);
            current_column(missing_idx) = {'NoData'};
            cat_col = categorical(current_column);
            categories_list = categories(cat_col);

            % If the variable is binary, create one dummy variable.
            if length(categories_list) == 2
                dummy_var = (cat_col == categories_list{2});
                X = [X, dummy_var];
                X_labels = [X_labels, strcat(vars{index}, '_', categories_list{2})];
            % If it has >2 categories, create k-1 dummy variables.
            else
                D_matrix = dummyvar(cat_col);
                % Add all but the first dummy to avoid the dummy variable trap.
                X = [X, D_matrix(:, 2:end)];
                % Generate labels for the new dummy variables.
                for j = 2:length(categories_list)
                    new_label = strcat(vars{index}, '_', categories_list{j});
                    X_labels = [X_labels, new_label];
                end
            end
        end

        % --- Process numeric variables ---
        if isnumeric(current_column)
            % Check for missing values coded as -99.
            missing_idx = (current_column == -99);
            
            if any(missing_idx)
                % Create a missing-value indicator variable.
                missing_flag = double(missing_idx);
                X = [X, missing_flag];
                X_labels = [X_labels, strcat(current_var_name, '_missing')];
                
                % Impute missing values with the column mean.
                imputed_column = current_column;
                temp_column_for_mean = imputed_column;
                temp_column_for_mean(missing_idx) = NaN;
                mean_val = mean(temp_column_for_mean, 'omitnan');
                imputed_column(missing_idx) = mean_val;
                
                % Add the imputed column to the matrix.
                X = [X, imputed_column];
                X_labels = [X_labels, current_var_name];
            else
                % If no missing values, add the column directly.
                X = [X, current_column];
                X_labels = [X_labels, current_var_name];
            end
        end
    end

end