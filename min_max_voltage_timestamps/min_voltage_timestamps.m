function result = min_voltage_timestamps(filePath)
    parsed = parse(filePath);
   
    ids = parsed.ACUAllData.min_cell_voltage_id.Data;
    times = parsed.ACUAllData.min_cell_voltage_id.Timestamp;

    unique_ids = unique(ids);
    timestamps = struct();
    
    for i = 1:length(unique_ids)
        id_num = unique_ids(i);
        field_name = sprintf("id%d", id_num);
        idx = ids == id_num;
        timestamps.(field_name) = times(idx);
    end


    % Define file name
    fileName = ['/data/mps_generated/' char(matlab.lang.internal.uuid()) '/min_voltage_timestamps.mat'];
    fileLocation = fullfile(pwd, fileName);

    % Ensure all folders in the path exist
    folderPath = char(fileparts(fileLocation));
    if ~exist(folderPath, 'dir')
        mkdir(folderPath);  % Creates nested directories automatically, if needed
    end

    % Save the matrix to a MAT file using -v7.3 format for matfile support
    save(fileLocation, 'timestamps', '-v7.3');

    result.type = 'mat';
    result.result = fileName;
end