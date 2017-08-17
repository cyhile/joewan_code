clear all
load('c.mat');
rslt = cell(length(c),1);
for i = 1:length(c)
    if strcmp(class(c{i}), 'char')
        tmp = str2num(c{i});
    else
        tmp = c{i};
    end
    rslt{i} = tmp;
end
        
        