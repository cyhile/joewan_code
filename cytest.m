function cytest()
path1 = 'D:\Action Recognition\MoSIFT code & ConGD\tmpfeature_results\devel01\MFSK\K_3.csv';  % label = 9
path2 = 'D:\Action Recognition\MoSIFT code & ConGD\tmpfeature_results\devel01\MFSK\K_11_3.csv';  % label = 9

cell_num = 2;
oribin_num = 8;
[~, ~, desc1]=readmosift_hoghofmbh(path1,oribin_num,cell_num);
[~, ~, desc2]=readmosift_hoghofmbh(path2,oribin_num,cell_num);
[m1 n1] = size(desc1);
[m2 n2] = size(desc2);  % n1 = n2 = 1024, m is num of descr

tic;
rslt = zeros(m1,m2);
for i = 1:m1
    for j = 1:m2
        rslt(i,j) = norm(desc1(i,1:n1) - desc2(j,1:n2),1);  % L1 L2 no matter
    end
end
toc


save('rsltsameL1.mat','rslt');
rmin = min(min(rslt));
rmax = max(max(rslt));
imshow(rslt,[rmin 12000]);      %ãÐÖµ ¿Éµ÷

end