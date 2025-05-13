function summary_matrix = summary(conf_intervals, beta)
    %SUMMARY print confidence intervals
    n_sigma = size(conf_intervals, 1);
    n_alpha = size(conf_intervals, 3);
    
    summary_matrix = zeros(n_sigma, n_alpha, 1);
    for i=1:n_sigma
        for j=1:n_alpha
            current = conf_intervals(i, :, j, :); % get specific intervs.
            current = squeeze(current); % remove extra dims
            result = (beta >= current(:,1)) & (beta <= current(:,2));
            npos = sum(result); % number of positives
            summary_matrix(i, j) = npos;
        end
    end
end

