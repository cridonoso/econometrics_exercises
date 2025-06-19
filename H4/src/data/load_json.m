function data = load_json(data)
    fid = fopen(data); % Abre el archivo para lectura
    raw = fread(fid, inf);    % Lee todo el contenido del archivo
    str = char(raw');         % Convierte los bytes leídos a un arreglo de caracteres
    fclose(fid);              % Cierra el archivo

    % Decodifica la cadena JSON a una estructura de MATLAB
    data = jsondecode(str);
end