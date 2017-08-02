function cydeleteduplicate(dir_path, save_dir_path)
%删除重复数据。
%dir_path里面所有的文件,save_dir_path：目标文件夹
%file_path = 'D:\Action Recognition\MoSIFT code & ConGD\tmpfeature_results\devel01\MFSK';

dir_exist = exist(save_dir_path, 'dir');
if ~dir_exist
    mkdir(save_dir_path);
end

feature_dir = dir(dir_path);
[m, ~] = size(feature_dir);
for i=1:m
    if(feature_dir(i).name(1) ~= '.')
        feature_file_name = feature_dir(i).name;
        feature_file_path = [dir_path '\' feature_file_name];
        
        file_exist = exist(feature_file_path, 'file');
        if ~file_exist
            cell_num = 2;
            oribin_num = 8;
            [frame_num, pos, descr]=readmosift_hoghofmbh(feature_file_path,oribin_num,cell_num);
            feature_mat = [frame_num pos descr];
            new_feature_mat = unique(feature_mat,'rows');
            csvwrite([save_dir_path '\' feature_file_name], new_feature_mat);
        end
    end
end
end

