function all_train_feature_mat = cygetalltrainfea(set_dir_path, n)
%得到所有训练集的所有特征
%all_train_feature_mat：训练集所有特征矩阵，
%all_train_feature_mat = [ descr location label center ] label是序号
%set_dir_path：集合目录，也就是训练类所在目录 n：第1：n个类是训练类

all_train_feature_mat = [];
for i=1:n
    feature_file_name = sprintf('K_%d.csv',i);  %每个训练类文件名，可改
    feature_file_path = [set_dir_path '\' feature_file_name];
    class_feature_mat = csvread(feature_file_path);
    [feature_num, ~] = size(class_feature_mat);
    center = mean(class_feature_mat(:,1:3));
    label_center_mat = repmat([i center], feature_num, 1);   %扩展每个calss的label center矩阵
    
    class_feature_mat = [class_feature_mat(:,4:1027) class_feature_mat(:,1:3) label_center_mat];

    all_train_feature_mat = [all_train_feature_mat; class_feature_mat];
end
end

