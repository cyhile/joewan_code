function [accurate, right_cnt, false_cnt] = cyrsltann(rslt, root_dir, set_name)
%结果分析，得出准确率
label_file_path = [root_dir '\CGD\' set_name '\' set_name];

%将样本ID转换成LABEL
train_label = read_file([label_file_path '_train.csv']);
train_class_num = length(train_label);

for i = 1:length(rslt)
    rslt(i).label = train_label{rslt(i).result_idx};
end

%求出final result  每个视频样本对应一组结果
final_rslt = cell({});
for i = 1:length(rslt)
    final_rslt{rslt(i).input_sample_idx(1) - train_class_num}(rslt(i).input_sample_idx(2)) = rslt(i).label;
end
final_rslt = final_rslt';

fid = fopen([label_file_path '_test.csv']);
test_label_cell = cell({});
while(~feof(fid))
    str = fgets(fid);
    loc = strfind(str,',');
    tmp = str2num(str(loc+1:end));
    test_label_cell = [test_label_cell; tmp];
end
fclose(fid);
% [~, ~, test_label] = xlsread([label_file_path '_test.csv']);
% test_label = test_label(:,2);
% 
% test_label_cell = cell(length(test_label),1);
% for i = 1:length(test_label)
%     if strcmp(class(test_label{i}), 'char')
%         tmp = str2num(test_label{i});
%     else
%         tmp = test_label{i};
%     end
%     test_label_cell{i} = tmp;
% end

rslt_file_path = [root_dir '\cyrslt'];
dir_exist = exist(rslt_file_path, 'dir');    %得到每个集合所有的训练特征（就可以用于聚类
if ~dir_exist
    mkdir(rslt_file_path);
end
file_exist = exist([rslt_file_path '\' set_name 'rslt.mat'], 'file');
if ~file_exist
    save([rslt_file_path '\' set_name '_rslt.mat'], 'final_rslt', 'test_label_cell');
end

%计算准确率
right_cnt = 0;
false_cnt = 0;
for i = 1:length(test_label_cell)
    for j = 1:length(test_label_cell{i})
        if j <= length(final_rslt{i})
            if test_label_cell{i}(j) == final_rslt{i}(j)
                right_cnt = right_cnt + 1;
            else
                false_cnt = false_cnt + 1;
            end
        end
    end
end
accurate = right_cnt / (right_cnt + false_cnt);
    
end

