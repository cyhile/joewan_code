%vote_space scatter 脚本
tic;
center_num = 30;
i = 7;
test_data = idx_vote_space{i}(:,1:3);
test_data = test_data';
[tc, ta] = vl_kmeans(test_data, center_num);    %参数1 聚类中心 可调
tc = tc';ta = ta';

% for j = 1:center_num
%     %idx = ta == j;
%     points_coor = idx_vote_space{i}(:, 1:3);
%     weight = idx_vote_space{i}(:, 4);
%     area =
    

scatter3(idx_vote_space{i}(:,1),idx_vote_space{i}(:,2),idx_vote_space{i}(:,3),5, 'k' ,'filled');
hold on;
scatter3(tc(:,1),tc(:,2),tc(:,3),10,'r','filled');
toc