%%�����ܵĳ�������devel1~20
%����devel1~20�����devel1~20_predict.xlsx

function cyrun()
data_dir = 'D:\Action Recognition\MoSIFT code & ConGD\tmpfeature_results';

for i = [4 6]   %�ӵڶ�����ʼ ������ �ٶ�̫��
    set_name = sprintf('devel%02d', i);
    dir_path = [data_dir '\' set_name '\MFSK'];
    cydeleteduplicate(dir_path);    %ɾ��Ŀ¼�ļ�����ظ�����
    cytrain(dir_path, set_name);    %�ó�ѵ�������������ݽṹ��������
    cymain(dir_path, set_name);
end
end
