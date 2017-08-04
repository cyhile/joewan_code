%vote_space scatter 脚本
tic;
center_num = 30;    %参数1 聚类中心 可调
area_range_t = [6 35 35] ./ 5;   %参数2 中心大小，可调
i = 7;
one_vote_space = idx_vote_space{i};
test_data = one_vote_space(:,1:3);
test_data = test_data';
[tc, ta] = vl_kmeans(test_data, center_num);
tc = tc';ta = ta';

for j = 1:center_num
    %idx = ta == j;
    points_coor = [19.5 106 106]; %tc(j, 1:3);
    %weight = one_vote_space(:, 4);
    [n, ~] = size(one_vote_space);
    %for k = 1:n
    for i = 1:10
        tmp_a = one_vote_space(:, 1:3) <= repmat(points_coor + area_range_t, n, 1);
        tmp_b = one_vote_space(:, 1:3) >= repmat(points_coor - area_range_t, n, 1);
        points_idx = all([tmp_a tmp_b], 2);
        points = one_vote_space(points_idx, 1:4);
        points_coor = sum(points(:, 1:3) .* repmat(points(:, 4), 1, 3)) ./ sum(points(:, 4));
        scatter3(points_coor(1),points_coor(2),points_coor(3), 5,'r','filled');
    end
end

    
    
    
    
    scatter3(one_vote_space(:,1),one_vote_space(:,2),one_vote_space(:,3),5, 'k' ,'filled');
    hold on;
    scatter3(19.5, 106, 106, 5,'r','filled');
    %scatter3(tc(:,1),tc(:,2),tc(:,3),10,'r','filled');
    toc