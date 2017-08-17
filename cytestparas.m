function cytestparas()
%参数调试外循环
global cluster_ratio;   %聚类比例
cluster_ratio = 0.1;

global center_num;    %寻找投票空间极值时的聚类中心
center_num = 30;

global area_range_t;   %寻找投票空间极值时的极值点范围
area_range_t = [6 35 35] ./ 3;

for cluster_ratio = 0.28:0.04:0.80
    score = cymain(); 
    fid = fopen('D:\Action Recognition\MoSIFT code & ConGD\final_score.csv','a');
    fprintf(fid, '%f,%f\r\n', cluster_ratio, score);
    fclose(fid);
end

end

