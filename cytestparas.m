function cytestparas()
%����������ѭ��
global cluster_ratio;   %�������
cluster_ratio = 0.3;

global center_num;    %Ѱ��ͶƱ�ռ伫ֵʱ�ľ�������
center_num = 30;

global area_range_t;   %Ѱ��ͶƱ�ռ伫ֵʱ�ļ�ֵ�㷶Χ
area_range_t = [6 35 35] ./ 3;

for cluster_ratio = 0.5:0.01:0.80
    cymain();
    
end

end

