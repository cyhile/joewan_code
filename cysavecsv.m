function cysavecsv(file_path, matr)
%file_path = 'D:\Action Recognition\MoSIFT code & ConGD\tmpfeature_results\devel01\MFSK\test.csv';
%matr = [1 2 3;4 5 6;7 8 9];

fid = fopen(file_path, 'w');

[m n] = size(matr);
for i=1:m
    for j=1:n
        if(j == n)
            fprintf(fid, '%d\r\n',matr(i,j));
        else
            fprintf(fid, '%d ',matr(i,j));
        end
    end
end
fclose(fid);
end

