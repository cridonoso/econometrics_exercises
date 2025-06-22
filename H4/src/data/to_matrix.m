function [X, X_labels] = to_matrix(vars, table)
    X = [];
    X_labels = string([]);  
    for index = 1:length(vars)
        current_var_name = vars{index};
        current_column = table.(current_var_name);

        if iscellstr(current_column) || isstring(current_column)
            % Create a new category for categorical variables.
            missing_idx = ismissing(current_column);
            current_column(missing_idx) = {'NoData'};

            cat_col = categorical(current_column);
            categories_list = categories(cat_col);
            % 2 categories
            if length(categories_list) == 2
                dummy_var = (cat_col == categories_list{2});
                X = [X, dummy_var];
                X_labels = [X_labels, strcat(vars{index}, '_', categories_list{2})];
            else % > 2 categories
                D_matrix = dummyvar(cat_col);
                X = [X, D_matrix(:, 2:end)];
                
                for j = 2:length(categories_list)
                    new_label = strcat(vars{index}, '_', categories_list{j});
                    X_labels = [X_labels, new_label];
                end
            end
        end
        if isnumeric(current_column)
            missing_idx = (current_column == -99);
            if any(missing_idx)
                missing_flag = double(missing_idx);
                X = [X, missing_flag];
                X_labels = [X_labels, strcat(current_var_name, '_missing')];
                imputed_column = current_column;          
                temp_column_for_mean = imputed_column;
                temp_column_for_mean(missing_idx) = NaN; 
                mean_val = mean(temp_column_for_mean, 'omitnan');
                
                % Ahora sí, reemplazamos los -99 en nuestra columna de trabajo por la media correcta.
                imputed_column(missing_idx) = mean_val;
                
                X = [X, imputed_column];
                X_labels = [X_labels, current_var_name];
            else
                X = [X, current_column];
                X_labels = [X_labels, current_var_name];
            end
        end
    end

end