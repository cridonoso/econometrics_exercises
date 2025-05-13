function var_white = white_variance(residuals, X, R)
    %   Calculates estimated white-like variance 
    
    % White's kernel (vector-based solution)
    wkernel = X' * (residuals.^2 .* X);
    
    % Sequential loop-based solution =========================
    %K = size(X, 2);
    %N = size(X, 1);
    %wkernel  = zeros(K, K);
    %for i=1:N
    %    curr_X = X(i, :)';
    %    wkernel = wkernel + residuals(i).^2*(curr_X*curr_X');
    %end
    % =========================================================


    % Variance 
    invX = inv(X'*X);
    var_white = invX * wkernel * invX;

    % Check if R is provided
    if ~(nargin < 3 || isempty(R))
        var_white = R' * var_white * R;
    end

end
