function result = max_cell_temp(filePath)
    parsed = parse(filePath);
    max_cell_temps = parsed.ACUAllData.core_data.max_cell_temp.Data;
    max_cell_temp = max(max_cell_temps);

    result.type = 'text';
    result.result = num2str(max_cell_temp);
end
