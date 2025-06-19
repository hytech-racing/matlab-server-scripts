function result = max_cell_temp_plus_random_num(filePath)
    max_temp = str2num(max_cell_temp(filePath).result);
    random_num = better_random();
    max_temp_plus_random_num = my_add(max_temp, random_num);

    result.type = 'text';
    result.result = num2str(max_temp_plus_random_num);
end

function result = better_random()
    result = rand * 10;
end
