%%�����ܵĳ�������devel1~20
%����devel1~20�����devel1~20_predict.xlsx

function avg_accu = cymain()
root_dir = 'D:\Action Recognition\MoSIFT code & ConGD';
feature_dir = [root_dir '\tmpfeature_results'];
new_feature_dir = [root_dir '\cyfeature_result'];
all_train_feature_dir = [root_dir  '\cyallfeature'];
global cluster_ratio;

for i = 1:20
    set_name = sprintf('devel%02d', i);
    set_dir_path = [feature_dir '\' set_name '\MFSK'];
    
    %step 1:ɾ��Դ����������ظ������������浽��Ŀ¼
    new_set_dir_path = [new_feature_dir '\' set_name];
    cydeleteduplicate(set_dir_path, new_set_dir_path);    %ɾ��Ŀ¼�ļ�����ظ����ݣ��������������new path����
    
    %step 2:��������ѵ����������
    set_all_train_feature_dir = [all_train_feature_dir '\' set_name];
    dir_exist = exist(set_all_train_feature_dir, 'dir');    %�õ�ÿ���������е�ѵ���������Ϳ������ھ���
    if ~dir_exist
        mkdir(set_all_train_feature_dir);
    end
    train_label = read_file([root_dir '\CGD\' set_name '\' set_name '_train.csv']);
    train_class_num = length(train_label);
    all_train_feature_file = [set_all_train_feature_dir '\' set_name '_allfeature.csv'];
    file_exist = exist(all_train_feature_file, 'file');    %�ж��ļ��Ƿ����
    if ~file_exist
        all_train_feature_mat = cygetalltrainfea(new_set_dir_path, train_class_num);
        csvwrite(all_train_feature_file, all_train_feature_mat);
    else
        all_train_feature_mat = csvread(all_train_feature_file);
        train_class_num__ = max(all_train_feature_mat(:,1028));
        if train_class_num__ ~= train_class_num
            fprintf('%s all feature is error !!!!!\r\n', set_name);
        end
    end
%     continue;
    
    %step 2:����,�ᱣ���ļ�����Ϊʹ��integer���� ����������������ֵ������0~255��Χ��
    cluster_file_path = [set_all_train_feature_dir '\cluster'];
    dir_exist = exist(cluster_file_path, 'dir');    %�õ�ÿ���������е�ѵ���������Ϳ������ھ���
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
    
    %step 3:����cluster_vote{},����ÿ�������ĵ�ͶƱ��Ϣ
    relative_pos = all_train_feature_mat(:, 1029:1031) - all_train_feature_mat(:, 1025:1027);
    idx = all_train_feature_mat(:, 1028);   %[descr(1~1024) location(1025~1027) idx(label 1028) center(1029~1031)]
    [cluster_center_num, ~] = size(cluster_center);
    cluster_vote = cell(cluster_center_num, 1);
    for j = 1:length(descr_center_list)
        cluster_vote{descr_center_list(j)} = [cluster_vote{descr_center_list(j)}; relative_pos(j, :) idx(j)];
    end
    
    %step 4:��ȡ�������� set_name sample_name -> [id subid]��Ȼ�����vote_space
    sample_dir = dir(new_set_dir_path);
    [n, ~] = size(sample_dir);
    rslt = struct([]);
    for j=1:n   %sampleѭ��
        input_sample_idx_mat = get_str_num_mat(sample_dir(j).name);
        if(length(input_sample_idx_mat) == 1 && input_sample_idx_mat > train_class_num)
            input_sample_idx_mat = [input_sample_idx_mat 1];
        end
        if(length(input_sample_idx_mat) == 2 && input_sample_idx_mat(1) > train_class_num)
            input_feat_mat = csvread([new_set_dir_path '\' sample_dir(j).name]);
            %����vote_space
            idx_vote_space = cygetvotespace(root_dir, set_name, sample_dir(j).name, input_feat_mat, cluster_center, cluster_vote);
            %����vote space most_center(1,5)���ǽ��
            most_center = cyanalysisvotespace(idx_vote_space);
            if ~isempty(most_center)
                rslt_elemt.input_sample_idx = input_sample_idx_mat;
                rslt_elemt.result_idx = most_center(1,5);
                rslt = [rslt rslt_elemt];
            else
                rslt_elemt.input_sample_idx = 1;
                rslt_elemt.result_idx = 1;
                rslt = [rslt rslt_elemt];
            end
        end
    end
    [final_accu(i), right_cnt, false_cnt] = cyrsltann(rslt, root_dir, set_name);
    
    dir_exist = exist([root_dir '\cyfinal_accu'], 'dir');    %�õ�ÿ���������е�ѵ���������Ϳ������ھ���
    if ~dir_exist
        mkdir([root_dir '\cyfinal_accu']);
    end
    fid = fopen([root_dir '\cyfinal_accu\' num2str(cluster_ratio) 'final_accu.csv'],'a');
    fprintf(fid, '%s,%f\r\n', set_name, final_accu(i));
    fclose(fid);
end

avg_accu = mean(final_accu);

end
