function cytrain(dir_path, set_name)
%dir_path = 'D:\Action Recognition\MoSIFT code & ConGD\tmpfeature_results\devel01\MFSK';
%temp_data_path = 'D:\Action Recognition\MoSIFT code & ConGD\joewan_code\cytempdata';

for i=1:10
    feature_file_name = sprintf('K_%d.csv',i);
    feature_file_path = [dir_path '\' feature_file_name];
    cell_num = 2;
    oribin_num = 8;
    [frame_num, pos, descr]=readmosift_hoghofmbh(feature_file_path,oribin_num,cell_num);
    pos_avg = mean(pos);
    frame_num_avg = mean(frame_num);
    class_center = [frame_num_avg pos_avg];
    class_feature_location = [frame_num pos];
    [m, ~] = size(descr);
    
    train_class(i).center = class_center;
    for j=1:m
        train_class(i).feature(j).location = class_feature_location(j, :);
        train_class(i).feature(j).descr = descr(j, :);
    end
end

save(['D:\Action Recognition\MoSIFT code & ConGD\joewan_code\cytempdata\' set_name '_train_class.mat'], 'train_class');
% save('descr_array.mat', 'descr_array');
% save('relative_pos_array.mat', 'relative_pos_array');
end

