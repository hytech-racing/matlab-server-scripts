function result = max_motor_temp_plus_random_num(filePath)
    max_temp = max_motor_temp(filePath);
    random_num = better_random();
    max_temp_plus_random_num = my_add(max_temp, random_num);
    result = jsonencode(struct("max_motor_temp_plus_random_num", max_temp_plus_random_num));
end

function result = better_random()
    result = rand;
end
