function save_results(resultsTable, inputDataStruct, configStruct, projectPath)
%SAVE_RESULTS Saves project results, data, and configuration to a directory.
%
%   This function saves all the key components of an analysis to a specified
%   project folder. It saves the results as a .csv file, the input data
%   as a .mat file, and the configuration settings as a .json file.
%   If the target directory does not exist, it will be created.
%
%   This function does not return any output arguments.
%
%   Inputs:
%       resultsTable    - A MATLAB table containing the results to be saved.
%       inputDataStruct - A MATLAB struct containing the input data.
%       configStruct    - A MATLAB struct with the configuration settings.
%       projectPath     - A string with the path to the output directory.

    % Check if the output directory exists, and create it if not.
    if ~isfolder(projectPath)
        fprintf('Directorio no encontrado. Creando ruta: %s\n', projectPath);
        mkdir(projectPath);
    end

    % Define the standard output filenames.
    resultsCsvFilename   = 'results.csv';
    inputDataMatFilename = 'data.mat';
    configJsonFilename   = 'config.json';

    % Construct the full file paths for each output file.
    csvFullPath          = fullfile(projectPath, resultsCsvFilename);
    inputDataMatFullPath = fullfile(projectPath, inputDataMatFilename);
    configJsonFullPath   = fullfile(projectPath, configJsonFilename);

    % Save all files within a try-catch block for robust error handling.
    try
        % Save the results table to a CSV file.
        writetable(resultsTable, csvFullPath, 'WriteVariableNames', true);
        
        % Save the input data structure to a MAT-file.
        save(inputDataMatFullPath, 'inputDataStruct');
        
        % Save the configuration structure to a human-readable JSON file.
        jsonString = jsonencode(configStruct, "PrettyPrint", true);
        fileID = fopen(configJsonFullPath, 'w');
        fprintf(fileID, '%s', jsonString);
        fclose(fileID);
        
        fprintf('\nSaved.\n');
    catch e
        fprintf('Error: %s\n', e.message);
    end
end