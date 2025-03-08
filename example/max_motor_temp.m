function result = max_motor_temp(filePath)
    parsed = parse(filePath);
    motor_temps = parsed.mc1_temps.motor_temp;
    result = max(motor_temps(:,2));
end