function cytestparas()
%参数调试外循环
global cluster_ratio;   %聚类比例
cluster_ratio = 0.3;
for cluster_ratio = 0.63:0.01:0.80
    cymain();
    
end

end

