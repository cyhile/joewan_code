%vote_space scatter 脚本
clear all;
load('matlab.mat');
tic;
center_num = 30;    %参数1 聚类中心 可调
area_range_t = [6 35 35] ./ 3;   %参数2 中心大小，可调
i = 10;
one_vote_space = idx_vote_space{i};
test_data = one_vote_space(:,1:3);
test_data = test_data';
[tc, ta] = vl_kmeans(test_data, center_num);
tc = tc';ta = ta';

points_save = cell({});
center_weight_save = [];
for j = 1:center_num
    points_coor = tc(j, 1:3);
    [n, ~] = size(one_vote_space);
    while 1
        tmp_a = one_vote_space(:, 1:3) <= repmat(points_coor + area_range_t, n, 1);
        tmp_b = one_vote_space(:, 1:3) >= repmat(points_coor - area_range_t, n, 1);
        points_idx = all([tmp_a tmp_b], 2);
        points = one_vote_space(points_idx, 1:4);
        if isempty(points)
            break;
        end
        points_coor_new = sum(points(:, 1:3) .* repmat(points(:, 4), 1, 3)) ./ sum(points(:, 4));
        if all(points_coor_new == points_coor)
            %scatter3(points_coor(1),points_coor(2),points_coor(3), 5,'r','filled');
            center_weight_save = [center_weight_save; points_coor sum(points(:, 4))];
            points_save = [points_save; points];
            break;
        else
            points_coor = points_coor_new;
        end
    end
end
[center_weight_save_sort, sort_idx] = sortrows(center_weight_save, -4);
center_weight_save_sort = center_weight_save_sort(1, :);
%sort_idx = sort_idx(1:3);
point_save_sort = points_save(sort_idx);

    
    
    
    
    scatter3(one_vote_space(:,1),one_vote_space(:,2),one_vote_space(:,3),5, 'k' ,'filled');
    hold on;
    scatter3(point_save_sort{1}(:,1),point_save_sort{1}(:,2),point_save_sort{1}(:,3),5, 'r' ,'filled');
    %scatter3(point_save_sort{2}(:,1),point_save_sort{2}(:,2),point_save_sort{2}(:,3),5, 'g' ,'filled');
    %scatter3(point_save_sort{3}(:,1),point_save_sort{3}(:,2),point_save_sort{3}(:,3),5, 'b' ,'filled');
    %scatter3(19.5, 106, 106, 5,'r','filled');
    %scatter3(tc(:,1),tc(:,2),tc(:,3),10,'r','filled');
    toc