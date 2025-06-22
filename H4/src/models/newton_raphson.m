function [theta_hat, V_cov, logL_val, iter_to_converge] = newton_raphson(logL_fun, theta0, options)
if nargin < 3, options = struct(); end
if ~isfield(options, 'max_iter'), options.max_iter = 1000; end
if ~isfield(options, 'tolerance'), options.tolerance = 1e-6; end
if ~isfield(options, 'verbose'), options.verbose = true; end

theta = theta0;

if options.verbose
    fprintf('--- Iniciando Estimador MLE (derivadas numéricas) ---\n');
    fprintf('Iteración | Norma del Gradiente\n');
    fprintf('----------------------------------\n');
end

for i = 1:options.max_iter
    [gradient, ~, ~] = gradest(logL_fun, theta);

    hessian = hessian_f(logL_fun, theta);
    
    grad_norm = norm(gradient);
    
    if options.verbose, fprintf('%9d | %17.6f\n', i, grad_norm); end
        
    if grad_norm < options.tolerance
        if options.verbose, fprintf('Convergencia alcanzada.\n'); end
        break;
    end

    step = hessian \ gradient';
    theta = theta - step;
end

if i == options.max_iter
    warning('No se alcanzó la convergencia en %d iteraciones.', options.max_iter);
end

theta_hat = theta;
final_hessian = hessian_f(logL_fun, theta_hat); % Recalcular en el punto final exacto
V_cov = inv(final_hessian); % Inversa del negativo del Hessiano
logL_val = logL_fun(theta_hat);
iter_to_converge = i;

end