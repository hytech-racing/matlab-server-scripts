function result = meters_travelled(filePath)
    % define constants
    TIRE_RADIUS = 0.2032;
    GEAR_RATIO = 11.86;
    
    % parse h5 file
    parsed = parse(filePath);
    
    % extract RPM data from parsed h5
    FL = parsed.VehicleData.current_rpms.FL;
    FR = parsed.VehicleData.current_rpms.FR;
    RL = parsed.VehicleData.current_rpms.RL;
    RR = parsed.VehicleData.current_rpms.RR;
    
    % extract timestamps and calculate sample intervals
    timestamps = FL(:,1);
    sample_intervals = diff(timestamps);

    % calculate the average of rpm of each wheel
    avg_motor_rpms = mean([FL(:,2), FR(:,2), RL(:,2), RR(:,2)], 2);
    avg_wheel_rpms = avg_motor_rpms / GEAR_RATIO;
    
    % convert RPM to linear speed
    linear_speeds = (avg_wheel_rpms * 2 * pi / 60) * TIRE_RADIUS;  % in m/s
    
    % calculate distance travelled during each interval
    distances = linear_speeds(1:end-1) .* sample_intervals;
    
    % sum up distances for total
    total_distance = sum(distances);
    
    % return
    result.type = 'text';
    result.result = total_distance;
end
