function data = load_json(filePath)
%LOAD_JSON Loads a JSON file and parses it into a MATLAB structure.
%
%   This function reads a specified JSON file from disk and decodes its
%   contents into a MATLAB structure or array.
%
%   Inputs:
%       filePath - A string containing the full path to the JSON file.
%
%   Output:
%       data     - A MATLAB structure or array representing the parsed
%                  JSON data.

    % Open the file for reading.
    fid = fopen(filePath);
    % Read the raw byte content of the entire file.
    raw = fread(fid, inf);
    % Convert the bytes to a character array (string).
    str = char(raw');
    % Close the file.
    fclose(fid);

    % Decode the JSON string into a MATLAB variable.
    data = jsondecode(str);
end