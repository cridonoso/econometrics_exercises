function selected_columns_matrix = gather_matrix(matrix_input, labels_matrix_columns, labels_list_2)
    % SELECT_COLUMNS_BY_COMMON_LABELS Selects columns from a matrix based on common labels.
    %
    %   SELECTED_COLUMNS_MATRIX = SELECT_COLUMNS_BY_COMMON_LABELS(MATRIX_INPUT, ...
    %                                                            LABELS_MATRIX_COLUMNS, ...
    %                                                            LABELS_LIST_2)
    %
    %   MATRIX_INPUT:          The numeric matrix from which to select columns.
    %   LABELS_MATRIX_COLUMNS: A cell array or string array containing the labels
    %                          for the columns of MATRIX_INPUT, in order.
    %   LABELS_LIST_2:         A cell array or string array containing a second
    %                          list of labels to intersect with LABELS_MATRIX_COLUMNS.
    %
    %   SELECTED_COLUMNS_MATRIX: The new matrix containing only the columns
    %                            whose labels are common to both input lists.

    if iscellstr(labels_matrix_columns)
        labels_matrix_columns = string(labels_matrix_columns);
    end
    if iscellstr(labels_list_2)
        labels_list_2 = string(labels_list_2);
    end

    common_labels = intersect(labels_matrix_columns, labels_list_2);

    % If no common labels, return an empty matrix
    if isempty(common_labels)
        selected_columns_matrix = [];
        warning('No common labels found between the two lists. Returning empty matrix.');
        return;
    end

    [~, col_indices_to_select] = ismember(common_labels, labels_matrix_columns);

    col_indices_to_select = col_indices_to_select(col_indices_to_select ~= 0);

    selected_columns_matrix = matrix_input(:, col_indices_to_select);
end