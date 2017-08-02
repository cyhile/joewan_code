function all_train_feature_mat = cygetalltrainfea(set_dir_path, n)
%�õ�����ѵ��������������
%all_train_feature_mat��ѵ����������������
%all_train_feature_mat = [ descr location label center ] label�����
%set_dir_path������Ŀ¼��Ҳ����ѵ��������Ŀ¼ n����1��n������ѵ����

all_train_feature_mat = [];
for i=1:n
    feature_file_name = sprintf('K_%d.csv',i);  %ÿ��ѵ�����ļ������ɸ�
    feature_file_path = [set_dir_path '\' feature_file_name];
    class_feature_mat = csvread(feature_file_path);
    [feature_num, ~] = size(class_feature_mat);
    center = mean(class_feature_mat(:,1:3));
    label_center_mat = repmat([i center], feature_num, 1);   %��չÿ��calss��label center����
    
    class_feature_mat = [class_feature_mat(:,4:1027) class_feature_mat(:,1:3) label_center_mat];

    all_train_feature_mat = [all_train_feature_mat; class_feature_mat];
end
end

