function most_center = cyanalysisvotespace(idx_vote_space)
global center_num;    %Ѱ��ͶƱ�ռ伫ֵʱ�ľ�������
global area_range_t;   %Ѱ��ͶƱ�ռ伫ֵʱ�ļ�ֵ�㷶Χ

most_center = [];
%most_center_points = cell();
for i = 1:length(idx_vote_space)    %����ͶƱ�ռ�ÿ��label��ͶƱ
    one_vote_space = idx_vote_space{i};
    [one_vote_space_m, ~] = size(one_vote_space);
    if isempty(one_vote_space) || one_vote_space_m < center_num
        continue;
    end
    
    one_vote_space_data = one_vote_space(:,1:3);
    one_vote_space_data = one_vote_space_data';
    [tc, ta] = vl_kmeans(one_vote_space_data, center_num);
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
            if isempty(points)  %�յ�����
                break;
            end
            points_coor_new = sum(points(:, 1:3) .* repmat(points(:, 4), 1, 3)) ./ sum(points(:, 4));
            if all(points_coor_new == points_coor)  %�����ɹ����������ݣ�����
                center_weight_save = [center_weight_save; points_coor sum(points(:, 4))];
                points_save = [points_save; points];
                break;
            else
                points_coor = points_coor_new;
            end
        end
    end
    [center_weight_save_sort, sort_idx] = sortrows(center_weight_save, -4);
    most_center = [most_center; center_weight_save_sort(1, :) i];
    %most_center_points{i} = points_save{sort_idx(1)};
end

if ~isempty(most_center)
    most_center = sortrows(most_center, -4);
end

end

