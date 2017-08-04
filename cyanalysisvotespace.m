function cyanalysisvotespace(vote_space)

idx_num = max(vote_space(:, 5));

idx_vote_space = cell(idx_num, 1);

for i = 1:idx_num
    row_index = vote_space(:,5) == i;
    idx_vote_space{i} = vote_space(row_index, 1:4);
end

end

