function str_num_mat = get_str_num_mat(str) %已知问题 输入.或者..时有问题
num_cell = regexp(str,'\d*\.?\d*','match');
num_cell_length = length(num_cell);
for i = 1:num_cell_length
    str_num_mat(i) = str2num(num_cell{i});
end
end