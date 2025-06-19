function [X, X_labels] = to_matrix(vars, table)
    X = [];
    X_labels = string([]);  
    for index = 1:length(vars)
        current_column = table.(vars{index});

        if iscellstr(current_column) || isstring(current_column)
            cat_col = categorical(table.(vars{index}));
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
            X = [X, table.(vars{index})];
            X_labels = [X_labels, vars{index}];
        end

    end
    X(isnan(X)) = -99;
end