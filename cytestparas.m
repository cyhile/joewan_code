function cytestparas()
%参数调试外循环
global cluster_ratio;   %聚类比例
cluster_ratio = 0.48;

global center_num;    %寻找投票空间极值时的聚类中心
center_num = 30;

global area_range_t;   %寻找投票空间极值时的极值点范围
area_range_t = [5 32.5 32.5];   %0.1 1

% for cluster_ratio = 0.5:0.1:0.6
%     score = cymain();
%     fid = fopen('D:\Action Recognition\MoSIFT code & ConGD\final_score.csv','a');
%     fprintf(fid, '%s-%f,%f\r\n', date, cluster_ratio, score);
%     fclose(fid);
% end

% for i = 4.5:0.5:5.5
%     for j = 30:0.5:34
%         area_range_t = [i j j];
        
        score = cymain();
        fid = fopen('D:\Action Recognition\MoSIFT code & ConGD\final_score.csv','a');
        fprintf(fid, '%s-%f,%f,%f\r\n', date, area_range_t(1), area_range_t(2), score);
        fclose(fid);
        fprintf('%s-%f,%f,%f\r\n', date, area_range_t(1), area_range_t(2), score);
%     end
%     
% end

