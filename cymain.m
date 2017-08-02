%%�����ܵĳ�������devel1~20
%����devel1~20�����devel1~20_predict.xlsx

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
    new_set_dir_path = [new_feature_dir '\' set_name];
    cydeleteduplicate(set_dir_path, new_set_dir_path);    %ɾ��Ŀ¼�ļ�����ظ����ݣ��������������new path����
    
    set_all_train_feature_dir = [all_train_feature_dir '\' set_name];
    dir_exist = exist(set_all_train_feature_dir, 'dir');    %�õ�ÿ���������е�ѵ���������Ϳ������ھ���
    if ~dir_exist
        mkdir(set_all_train_feature_dir);
    end
    all_train_feature_file = [set_all_train_feature_dir '\' set_name '_allfeature.csv'];
    file_exist = exist(all_train_feature_file, 'file');    %�ж��ļ��Ƿ����
    if ~file_exist
        all_train_feature_mat = cygetalltrainfea(new_set_dir_path, train_class_num(i));
        csvwrite(all_train_feature_file, all_train_feature_mat);
    else
        all_train_feature_mat = csvread(all_train_feature_file);
    end
    
    cluster_file_path = [set_all_train_feature_dir '\cluster'];
    dir_exist = exist(cluster_file_path, 'dir');    %�õ�ÿ���������е�ѵ���������Ϳ������ھ���
    if ~dir_exist
        mkdir(cluster_file_path);
    end
    descr_max_num = max(max(all_train_feature_mat(:,1:1024)));
    if(descr_max_num <= 255)
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
        break;
    end
    
end


%cytrain(set_dir_path, set_name);    %�ó�ѵ�������������ݽṹ��������
%cymain(set_dir_path, set_name);
end
