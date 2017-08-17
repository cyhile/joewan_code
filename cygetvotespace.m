function idx_vote_space = cygetvotespace(root_dir, set_name, sample_name, input_feat_mat, cluster_center, cluster_vote)

%1、计算sample [center_id loacation]
sample_center_dir = [root_dir '\cysample_center\' set_name];
dir_exist = exist(sample_center_dir, 'dir');
if ~dir_exist
    mkdir(sample_center_dir);
end
global cluster_ratio;
file_exist = exist([sample_center_dir '\' num2str(cluster_ratio) sample_name], 'file');
if ~file_exist
    tic;
    sample_max_num = max(max(input_feat_mat(:,4:1027)));
    sample_min_num = min(min(input_feat_mat(:,4:1027)));
    if(sample_max_num <= 255 && sample_min_num >= 0)
%         [n, ~] = size(input_feat_mat);
%         sample_center_id_location = zeros(n,1);
%         for i = 1:n
            sample_center_id_location = vl_ikmeanspush(uint8(input_feat_mat(:,4:1027)'), int32(cluster_center'));     %%计算sample_center_id
            sample_center_id_location = double(sample_center_id_location');
%         end
        sample_center_id_location = [sample_center_id_location input_feat_mat(:,1:3)];
        csvwrite([sample_center_dir '\' num2str(cluster_ratio) sample_name], sample_center_id_location);
    else
        fprintf('%s is not recognized, because its value is aut of range!!!\r\n', sample_name);
    end
    fprintf('sample_center_id_location saved, t:%f, set_name:%s, sample_name:%s, cluster_ratio:%f\r\n', toc, set_name, sample_name, cluster_ratio);
else
    sample_center_id_location = csvread([sample_center_dir '\' num2str(cluster_ratio) sample_name]);
end

%1、计算vote_space

% vote_space_dir = [root_dir '\cyvote_space_center\' set_name];
% dir_exist = exist(vote_space_dir, 'dir');
% if ~dir_exist
%     mkdir(vote_space_dir);
% end
% file_exist = exist([vote_space_dir '\' sample_name], 'file');
% if ~file_exist
    vote_space = [];
    [n, ~] = size(sample_center_id_location);
    for i = 1:n     %每个样本的特征序号循环
        cluster_center_id = sample_center_id_location(i);
        [m, ~] = size(cluster_vote{cluster_center_id});
        vote_space_tmp = zeros(m, 5);   %[center weight idx]
        vote_space_tmp(:, 4) = 1/m;     %weight = 1/m
        for j = 1:m
            vote_space_tmp(j, 5) = cluster_vote{cluster_center_id}(j, 4);   %idx = idx
            vote_space_tmp(j, 1:3) = sample_center_id_location(i, 2:4) + cluster_vote{cluster_center_id}(j, 1:3);   %center vote
        end
        vote_space = [vote_space; vote_space_tmp];
    end
% else
% end
vote_space = sortrows(vote_space, 5); 

idx_num = max(vote_space(:, 5));
idx_vote_space = cell(idx_num, 1);
for i = 1:idx_num
    row_index = vote_space(:,5) == i;
    idx_vote_space{i} = vote_space(row_index, 1:4);
end
end
    
