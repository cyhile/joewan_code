function cytestparas()
%����������ѭ��
global cluster_ratio;   %�������
cluster_ratio = 0.1;

global center_num;    %Ѱ��ͶƱ�ռ伫ֵʱ�ľ�������
center_num = 30;

global area_range_t;   %Ѱ��ͶƱ�ռ伫ֵʱ�ļ�ֵ�㷶Χ
area_range_t = [6 35 35] ./ 3;

for cluster_ratio = 0.28:0.04:0.80
    score = cymain(); 
    fid = fopen('D:\Action Recognition\MoSIFT code & ConGD\final_score.csv','a');
    fprintf(fid, '%f,%f\r\n', cluster_ratio, score);
    fclose(fid);
end

end

