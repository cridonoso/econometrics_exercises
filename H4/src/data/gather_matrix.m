function selected_columns_matrix = gather_matrix(matrix_input, labels_matrix_columns, labels_list_2)
%GATHER_MATRIX Selects matrix columns based on a list of labels.
%
%   This function extracts columns from a source matrix by finding the
%   common labels between the matrix's column labels and a separate list of
%   desired labels.
%
%   Inputs:
%       matrix_input          - The source numerical matrix.
%       labels_matrix_columns - A string or cell array with labels for the
%                               columns of 'matrix_input'.
%       labels_list_2         - A string or cell array with the labels of
%                               the columns to be selected.
%
%   Output:
%       selected_columns_matrix - A new matrix containing only the selected
%                                 columns from 'matrix_input'.

    % Ensure both label inputs are string arrays for reliable comparison.
    if iscellstr(labels_matrix_columns)
        labels_matrix_columns = string(labels_matrix_columns);
    end
    if iscellstr(labels_list_2)
        labels_list_2 = string(labels_list_2);
    end

    % Find the set of labels that are present in both lists.
    common_labels = intersect(labels_matrix_columns, labels_list_2);

    % If no common labels are found, return an empty matrix and warn the user.
    if isempty(common_labels)
        selected_columns_matrix = [];
        warning('No common labels found between the two lists. Returning empty matrix.');
        return;
    end

    % Get the indices of the common labels in the original matrix's label list.
    [~, col_indices_to_select] = ismember(common_labels, labels_matrix_columns);

    % Sanitize indices to ensure no zero-indices are passed.
    col_indices_to_select = col_indices_to_select(col_indices_to_select ~= 0);

    % Select the desired columns from the input matrix to create the output.
    selected_columns_matrix = matrix_input(:, col_indices_to_select);
end