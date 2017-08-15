clear all;
load('matlab.mat');
label_file_path = 'D:\Action Recognition\MoSIFT code & ConGD\CGD\devel01\devel01_train.csv';
%step 2:������IDת����LABEL
train_label = read_file(label_file_path);
for i = 1:length(rslt)
    rslt(i).label = train_label{rslt(i).result_idx};
end

%���final result  ÿ����Ƶ������Ӧһ����
final_rslt = cell({});
for i = 1:length(rslt)
    final_rslt{rslt(i).input_sample_idx(1)}(rslt(i).input_sample_idx(2)) = rslt(i).label;
end
for i = 1:10
    final_rslt{i}(1) = train_label{i};
end
final_rslt = final_rslt';

save('_result.mat', 'final_rslt');
%�����ļ�
% for i = 1:length(final_rslt)
%     xlswrite([set_name '_predict_result.xlsx'], {mat2str(final_rslt{i})}, 'Sheet1', ['A' num2str(i)]);
% end