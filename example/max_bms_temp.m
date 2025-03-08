function result = max_bms_temp(filePath)
    parsed = parse(filePath);
    bms_temps = parsed.bms_temps.average_temp;
    max_bms_temp = max(bms_temps(:,2));
    result = jsonencode(struct("max_bms_temp", max_bms_temp));
end