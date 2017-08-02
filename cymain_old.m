function cymain(dir_path, set_name)
file_path = dir_path;   %[data_dir '\' set_name '\MFSK'];    %'D:\Action Recognition\MoSIFT code & ConGD\tmpfeature_results\devel01\MFSK';
label_file_path = ['D:\Action Recognition\MoSIFT code & ConGD\CGD\' set_name '\' set_name '_train.csv'];

%step 1:识别每个样本ID对应的训练ID
feature_dir = dir(file_path);
[m, ~] = size(feature_dir);
rslt = struct([]);
for i=1:m
    if(feature_dir(i).name(1) ~= '.')
        input_sample_idx_mat = get_str_num_mat(feature_dir(i).name);
        if(length(input_sample_idx_mat) == 1 && input_sample_idx_mat > 10)
            input_sample_idx_mat = [input_sample_idx_mat 1];
        end
        if(length(input_sample_idx_mat) == 2)
            rslt_elemt.input_sample_idx = input_sample_idx_mat;
            rslt_elemt.result_idx = cyvote(feature_dir(i).name, dir_path, set_name);
            rslt = [rslt rslt_elemt];
        end
    end
end
%save('D:\Action Recognition\MoSIFT code & ConGD\joewan_code\cytempdata\idx2idx_result.mat', 'rslt');

%step 2:将样本ID转换成LABEL
train_label = read_file(label_file_path);
for i = 1:length(rslt)
    rslt(i).label = train_label{rslt(i).result_idx};
end

%求出final result  每个视频样本对应一组结果
final_rslt = cell({});
for i = 1:length(rslt)
    final_rslt{rslt(i).input_sample_idx(1)}(rslt(i).input_sample_idx(2)) = rslt(i).label;
end
for i = 1:10
    final_rslt{i}(1) = train_label{i};
end

save(['D:\Action Recognition\MoSIFT code & ConGD\joewan_code\cytempdata\' set_name '_result.mat'], 'final_rslt');
%保存文件
% for i = 1:length(final_rslt)
%     xlswrite([set_name '_predict_result.xlsx'], {mat2str(final_rslt{i})}, 'Sheet1', ['A' num2str(i)]);
% end
end
