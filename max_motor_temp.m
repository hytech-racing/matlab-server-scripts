function result = getMaxMotorTemp(filePath)
    parsed = parse(filePath) ;
    motor_temps = parsed.mc1_temps.motor_temp;
    max_motor_temp = max(motor_temps(:,2));
    result = jsonencode(struct("max_motor_temp", max_motor_temp));
end
