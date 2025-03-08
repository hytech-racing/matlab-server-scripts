function result = battery_discharge_percentage(filePath)
    parsed = parse(filePath);
    charge_percentage = parsed.state_of_charge.charge_percentage;
    start = charge_percentage(1,2);
    stop = charge_percentage(end, 2);
    diff = start - stop;
    result = jsonencode(struct("battery_discharge_percentage", diff));
end