function cytestparas()
%����������ѭ��
global cluster_ratio;   %�������
cluster_ratio = 0.48;

global center_num;    %Ѱ��ͶƱ�ռ伫ֵʱ�ľ�������
center_num = 30;

global area_range_t;   %Ѱ��ͶƱ�ռ伫ֵʱ�ļ�ֵ�㷶Χ
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

