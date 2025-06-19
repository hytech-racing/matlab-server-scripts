function result = battery_discharge_percentage(filePath)
    parsed = parse(filePath);
    charge_percentage = parsed.ACUAllData.SoC.Data;
    start = charge_percentage(1);
    stop = charge_percentage(end);
    diff = start - stop;

    result.type = 'text';
    result.result = num2str(diff);
end