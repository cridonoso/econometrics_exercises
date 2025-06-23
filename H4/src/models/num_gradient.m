function G = num_gradient(fun, theta)
%NUM_GRADIENT Computes the numerical gradient of a function.
%
%   This function calculates the gradient of a given function 'fun' at a
%   specific point 'theta' using the central finite difference method.
%
%   Inputs:
%       fun     - A handle to the function to be differentiated. This
%                 function must accept a vector and return a scalar.
%       theta   - A column vector representing the point at which the
%                 gradient is evaluated.
%
%   Output:
%       G       - A column vector containing the numerical gradient.

    n_params = length(theta);
    G = zeros(n_params, 1); % Initialize the gradient vector.
    epsilon = 1e-6;         % Define a small step size for differentiation.

    % Iterate over each parameter to compute its partial derivative.
    for j = 1:n_params
        % Create vectors for the forward and backward steps.
        theta_plus = theta;
        theta_minus = theta;

        % Perturb only the j-th parameter.
        theta_plus(j) = theta(j) + epsilon;
        theta_minus(j) = theta(j) - epsilon;

        % Compute the partial derivative using the central difference formula.
        G(j) = (fun(theta_plus) - fun(theta_minus)) / (2 * epsilon);
    end

end