function train_sample_idx = cyvote(input_sample_name, dir_path, set_name)
%dir_path = 'D:\Action Recognition\MoSIFT code & ConGD\tmpfeature_results\devel01\MFSK';
%test_vote_path_ = 'D:\Action Recognition\MoSIFT code & ConGD\tmpfeature_results\devel01\MFSK';%\K_17_2.csv';
load(['D:\Action Recognition\MoSIFT code & ConGD\joewan_code\cytempdata\' set_name '_train_class.mat']);

test_vote_path = [dir_path '\' input_sample_name];

tic
%step 1:读取特征比较相似度，保留阈值以下相似度
%读取输入特征
cell_num = 2;
oribin_num = 8;
[frame_num, pos, input_descr]=readmosift_hoghofmbh(test_vote_path,oribin_num,cell_num);
n = size(frame_num);

match_info = struct([]);
for i=1:n  %输入特征数循环
    for i1=1:10  %train class num
        [~, m] = size(train_class(i1).feature);
        for i2=1:m  %每个训练样本的特征数循环
            tmp_dist = norm(input_descr(i,:) - train_class(i1).feature(i2).descr,1);
            if(tmp_dist < 12000)    %阈值可调
                match_info_element.input_feature_id = i;
                match_info_element.target_feature_id = [i1 i2];
                match_info_element.score = tmp_dist;
                match_info = [match_info  match_info_element];
            end
        end
    end
end

%计算权重：最小距离对应权重1，最大距离对应权重w0,这里可能最大最小score可以削顶
w1 = 1;
w0 = 0.8;   %最小权重可调
smin = min([match_info.score]);
smax = max([match_info.score]);

[~, n] = size(match_info);
for i=1:n
    match_info(i).weight = ((match_info(i).score - smin)./(smax - smin)).* (w0 - w1) + w1;
    if(match_info(i).weight >= 1)
        match_info(i).weight = 1;
    end
    if(match_info(i).weight <= 0)
        match_info(i).weight = 0;
    end
end

%step 2:得到投票匹配信息之后，对不同class空间投票，输出
%计算center
[~, n] = size(match_info);
for i=1:n
    input_feature_id = match_info(i).input_feature_id;
    target_feature_id = match_info(i).target_feature_id;
    class_center = train_class(target_feature_id(1)).center;
    class_feature_location = train_class(target_feature_id(1)).feature(target_feature_id(2)).location;
    input_feature_location = [frame_num(input_feature_id) pos(input_feature_id,:)];
    
    match_info(i).center = input_feature_location + (class_center - class_feature_location);
    center(i,1:3) = input_feature_location + (class_center - class_feature_location);
end
save(['D:\Action Recognition\MoSIFT code & ConGD\joewan_code\cytempdata\' set_name '_' input_sample_name(1:end-4) '_match_info.mat'], 'match_info', 'center');

%滑窗找最大密度
%bin投票直方图统计
tcmin = min(center(:,1));
tcmax = max(center(:,1));
bin_range = [];
range_n = 100;    %分成多少分，可调
for i=1:range_n
    bin(i).range = [tcmin + (i - 1).*((tcmax - tcmin)./range_n) tcmin + i.*((tcmax - tcmin)./range_n)];
    bin_range = [bin_range; tcmin + (i - 1).*((tcmax - tcmin)./range_n) tcmin + i.*((tcmax - tcmin)./range_n)];
    bin(i).weight = 0;
    bin(i).match_item = struct([]);
end

[~, m] = size(match_info);
for i=1:m
    for j=1:range_n
        if(match_info(i).center(1) >= bin(j).range(1) && match_info(i).center(1) <= bin(j).range(2))    %%在range内，投点
            bin(j).weight = bin(j).weight + match_info(i).weight;
            bin(j).match_item = [bin(j).match_item match_info(i)];
            break;
        end
    end
end

save(['D:\Action Recognition\MoSIFT code & ConGD\joewan_code\cytempdata\' set_name '_' input_sample_name(1:end-4) '_bin.mat'], 'bin');

x = (bin_range(:,1) + bin_range(:,2))./2;
y = [bin.weight];
% hist(center(:,1),range_n)
% hold on;
%bar(x',y);

%求最大滑窗区域
slidwindow = 8;     %%滑窗大小 可调
for i = 1:range_n - slidwindow
    slid_window_weight(i) =  sum([bin(i:i + slidwindow).weight]);
end
[~, slid_max_pos] = max(slid_window_weight);
dist_weight_hist = [x' y];
save(['D:\Action Recognition\MoSIFT code & ConGD\joewan_code\cytempdata\' set_name '_' input_sample_name(1:end-4) '_dist_weight_hist.mat'], 'dist_weight_hist');

vote_mat = [];
for i=slid_max_pos:slid_max_pos + slidwindow
    [~, n] = size(bin(i).match_item);
    for j=1:n
        vote_mat = [vote_mat bin(i).match_item(j).target_feature_id(1)];
    end
end
toc

save(['D:\Action Recognition\MoSIFT code & ConGD\joewan_code\cytempdata\' set_name '_' input_sample_name(1:end-4) '.vote_hist.mat'], 'vote_mat');
hist(vote_mat,30);
vote_rslt = tabulate(vote_mat);
[~, vote_rslt_most_idx] = max(vote_rslt(:,2));
train_sample_idx = vote_rslt(vote_rslt_most_idx, 1);
end