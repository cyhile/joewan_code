clear all;
root_dir = 'D:\Action Recognition\MoSIFT code & ConGD';
for ii = 1:20
    set_name = sprintf('devel%02d', ii);
    label_file_path = [root_dir '\tmpResults\' set_name  '_predict.csv'];
    predict_label = read_file(label_file_path);
    predict_label = predict_label';
    
    train_label = read_file(['D:\Action Recognition\MoSIFT code & ConGD\CGD\' set_name '\' set_name '_train.csv']);
    train_class_num = length(train_label);
    predict_label = predict_label(train_class_num + 1 : end);
    
    [~, ~, test_label] = xlsread(['D:\Action Recognition\MoSIFT code & ConGD\CGD\' set_name '\' set_name '_test.csv']);
    test_label = test_label(:,2);
    
    test_label_cell = cell(length(test_label),1);
    for i = 1:length(test_label)
        if strcmp(class(test_label{i}), 'char')
            tmp = str2num(test_label{i});
        else
            tmp = test_label{i};
        end
        test_label_cell{i} = tmp;
    end
    
    %计算准确率
    right_cnt = 0;
    false_cnt = 0;
    for i = 1:length(test_label_cell)
        for j = 1:length(test_label_cell{i})
            if j <= length(predict_label{i})
                if test_label_cell{i}(j) == predict_label{i}(j)
                    right_cnt = right_cnt + 1;
                else
                    false_cnt = false_cnt + 1;
                end
            end
        end
    end
    accurate(ii) = right_cnt / (right_cnt + false_cnt);
end
accurate = accurate';
score = mean(accurate);