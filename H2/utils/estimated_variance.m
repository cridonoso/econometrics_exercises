function var_hat = estimated_variance(residuals, X, R)
    %   Calculates estimated variance
    
    N = size(X, 1); % number of samples
    K = size(X, 2); % number of parameters
    
    s2 = residuals'*residuals./(N-K); % residual variance

    % Check if R is provided
    if nargin < 3 || isempty(R)
        invX = inv(X'*X);
        var_hat = s2*invX; % estimated variance
    else
        var_hat = s2*R'*((X'*X)\R); % estimated variance
    end
    
end

