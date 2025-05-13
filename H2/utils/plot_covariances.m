function plot_covariances(err_cov_homo, err_cov_hete, target)
covMatrix = mean(err_cov_homo, 1);
covMatrix = squeeze(covMatrix);
covMatrix(covMatrix<1e-3) = 0.00;
covMatrix2 = mean(err_cov_hete, 1);
covMatrix2 = squeeze(covMatrix2);
covMatrix2(covMatrix2<1e-3) = 0.00;

% Determinar los límites globales de color (mínimo y máximo)
globalMin = min([covMatrix(:); covMatrix2(:)]);
globalMax = max([covMatrix(:); covMatrix2(:)]);

labelsCells = {'$X_0$', '$X_1$', '$X_2$', '$X_3$'};

fig = figure;
tcl = tiledlayout(1, 2, 'Padding', 'loose', 'TileSpacing', 'loose'); % Añadir márgenes

% Primer heatmap
nexttile;
h1 = heatmap(covMatrix, 'CellLabelFormat', '%.2g', ...
    'ColorbarVisible', 'off','Interpreter', 'latex');
h1.ColorLimits = [globalMin globalMax];
h1.Title = 'Matriz de Covarianza(Homocedástica)';
h1.XLabel = 'Variables';
h1.YLabel = 'Variables';
h1.XDisplayLabels = labelsCells;
h1.YDisplayLabels = labelsCells;

% Segundo heatmap
nexttile;
h2 = heatmap(covMatrix2, 'CellLabelFormat', '%.2g', ...
    'ColorbarVisible', 'off','Interpreter', 'latex');
h2.ColorLimits = [globalMin globalMax];
h2.Title = 'Matriz de Covarianza (Heterocedástica)';
h2.XDisplayLabels = labelsCells;
h2.YDisplayLabels = labelsCells;

% Ajustar la figura para añadir márgenes blancos alrededor
fig.Units = 'centimeters';
fig.Position = [1, 1, 15, 6]; % Ajustar tamaño total del gráfico

% Exportar a PDF con márgenes blancos y fuente LaTeX
exportgraphics(fig, target, 'ContentType', 'vector');
end

