function str_num_mat = get_str_num_mat(str)
%���룺 K_11_1 �����[11 1]
num_cell = regexp(str,'\d*\.?\d','match');
num_cell_length = length(num_cell);
str_num_mat = [];
for i = 1:num_cell_length
    str_num_mat(i) = str2num(num_cell{i});
end
end