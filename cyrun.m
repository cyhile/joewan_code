%%最终跑的程序，跑完devel1~20
%输入devel1~20，输出devel1~20_predict.xlsx

function cyrun()
data_dir = 'D:\Action Recognition\MoSIFT code & ConGD\tmpfeature_results';

for i = [4 6]   %从第二个开始 有问题 速度太慢
    set_name = sprintf('devel%02d', i);
    dir_path = [data_dir '\' set_name '\MFSK'];
    cydeleteduplicate(dir_path);    %删除目录文件里的重复数据
    cytrain(dir_path, set_name);    %得出训练样本特征数据结构，并保存
    cymain(dir_path, set_name);
end
end
