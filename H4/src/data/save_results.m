function save_results(resultsTable, inputDataStruct, configStruct, projectPath)
    
    if ~isfolder(projectPath)
        fprintf('Directorio no encontrado. Creando ruta: %s\n', projectPath);
        mkdir(projectPath);
    end
    
    resultsCsvFilename   = 'results.csv';
    inputDataMatFilename = 'data.mat';
    configJsonFilename   = 'config.json';

    csvFullPath          = fullfile(projectPath, resultsCsvFilename);
    inputDataMatFullPath = fullfile(projectPath, inputDataMatFilename);
    configJsonFullPath   = fullfile(projectPath, configJsonFilename);

    try
        writetable(resultsTable, csvFullPath, 'WriteVariableNames', true);
        save(inputDataMatFullPath, 'inputDataStruct');
        jsonString = jsonencode(configStruct, "PrettyPrint", true);
        fileID = fopen(configJsonFullPath, 'w');
        fprintf(fileID, '%s', jsonString);
        fclose(fileID);
        fprintf('\nSaved.\n');
    catch e
        fprintf('Error: %s\n', e.message);
    end
end