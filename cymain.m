%%最终跑的程序，跑完devel1~20
%输入devel1~20，输出devel1~20_predict.xlsx

function cymain()
root_dir = 'D:\Action Recognition\MoSIFT code & ConGD';
feature_dir = [root_dir '\tmpfeature_results'];
new_feature_dir = [root_dir '\cyfeature_result'];
all_train_feature_dir = [root_dir  '\cyallfeature'];
global cluster_ratio;

train_class_num = [ ...
    10  10  8   10  8   ...
    11  9   11  9   9  ...
    8   11  12  8   8  ...
    13  8   10  9   9  ];

for i = 1:20
    set_name = sprintf('devel%02d', i);
    set_dir_path = [feature_dir '\' set_name '\MFSK'];
    
    %step 1:删除源特征里面的重复向量，并保存到新目录
    new_set_dir_path = [new_feature_dir '\' set_name];
    cydeleteduplicate(set_dir_path, new_set_dir_path);    %删除目录文件里的重复数据，并将结果保存在new path里面
    
    %step 2:保存所有训练样本特征
    set_all_train_feature_dir = [all_train_feature_dir '\' set_name];
    dir_exist = exist(set_all_train_feature_dir, 'dir');    %得到每个集合所有的训练特征（就可以用于聚类
    if ~dir_exist
        mkdir(set_all_train_feature_dir);
    end
    all_train_feature_file = [set_all_train_feature_dir '\' set_name '_allfeature.csv'];
    file_exist = exist(all_train_feature_file, 'file');    %判断文件是否存在
    if ~file_exist
        all_train_feature_mat = cygetalltrainfea(new_set_dir_path, train_class_num(i));
        csvwrite(all_train_feature_file, all_train_feature_mat);
    else
        all_train_feature_mat = csvread(all_train_feature_file);
    end
    
    %step 2:聚类,会保存文件，因为使用integer聚类 所以特征向量所有值必须在0~255范围内
    cluster_file_path = [set_all_train_feature_dir '\cluster'];
    dir_exist = exist(cluster_file_path, 'dir');    %得到每个集合所有的训练特征（就可以用于聚类
    if ~dir_exist
        mkdir(cluster_file_path);
    end
    descr_max_num = max(max(all_train_feature_mat(:,1:1024)));
    descr_min_num = min(min(all_train_feature_mat(:,1:1024)));
    if(descr_max_num <= 255 && descr_min_num >= 0)
        cluster_center_file_name = sprintf('%.3fcluster_ratio_center_file.csv', cluster_ratio);
        descr_center_list_file_name = sprintf('%.3fcluster_ratio_list_file.csv', cluster_ratio);
        cluster_center_file = [cluster_file_path '\' cluster_center_file_name];
        descr_center_list_file = [cluster_file_path '\' descr_center_list_file_name];
        file_exist = exist(cluster_center_file, 'file') && exist(descr_center_list_file, 'file');
        if ~file_exist
            [all_descr_num, ~] = size(all_train_feature_mat);
            [cluster_center, descr_center_list] = vl_ikmeans((uint8(all_train_feature_mat(:,1:1024)))', cluster_ratio * all_descr_num);
            cluster_center = cluster_center';
            descr_center_list = descr_center_list';
            csvwrite(cluster_center_file, cluster_center);
            csvwrite(descr_center_list_file, descr_center_list);
        else
            cluster_center = csvread(cluster_center_file);
            descr_center_list = csvread(descr_center_list_file);
        end
    else
        fprintf('%s is not process, because its descr_max_num is larger than 255!!!\r\n', set_name);
    end
    
    %step 3:生成cluster_vote{},这是每个类中心的投票信息
    relative_pos = all_train_feature_mat(:, 1029:1031) - all_train_feature_mat(:, 1025:1027);
    idx = all_train_feature_mat(:, 1028);   %[descr(1~1024) location(1025~1027) idx(label 1028) center(1029~1031)]
    [cluster_center_num, ~] = size(cluster_center);
    cluster_vote = cell(cluster_center_num, 1);
    for j = 1:length(descr_center_list)
        cluster_vote{descr_center_list(j)} = [cluster_vote{descr_center_list(j)}; relative_pos(j, :) idx(j)];
    end
    
    %step 4:获取输入样本 set_name sample_name -> [id subid]，然后计算vote_space
    sample_dir = dir(new_set_dir_path);
    [n, ~] = size(sample_dir);
    rslt = struct([]);
    for j=1:n   %sample循环
        input_sample_idx_mat = get_str_num_mat(sample_dir(j).name);
        if(length(input_sample_idx_mat) == 1 && input_sample_idx_mat > 10)
            input_sample_idx_mat = [input_sample_idx_mat 1];
        end
        if(length(input_sample_idx_mat) == 2 && input_sample_idx_mat(1) > 10)
            input_feat_mat = csvread([new_set_dir_path '\' sample_dir(j).name]);
            %计算vote_space
            idx_vote_space = cygetvotespace(root_dir, set_name, sample_dir(j).name, input_feat_mat, cluster_center, cluster_vote);
            %分析vote space most_center(1,5)就是结果
            most_center = cyanalysisvotespace(idx_vote_space);
            if ~isempty(most_center)
                rslt_elemt.input_sample_idx = input_sample_idx_mat;
                rslt_elemt.result_idx = most_center(1,5);
                rslt = [rslt rslt_elemt];
            end
        end
    end
    
end


%cytrain(set_dir_path, set_name);    %得出训练样本特征数据结构，并保存
%cymain(set_dir_path, set_name);
end
