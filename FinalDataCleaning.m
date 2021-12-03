opts = detectImportOptions('breast-cancer-wisconsin.csv');

temp_data = readtable('breast-cancer-wisconsin.csv',opts);

temp_data = unique(temp_data,"rows");
len = length(temp_data.class);
for i = 1:len
   if(temp_data.class(i)==2)
       temp_data.class(i)=0;
   else
       temp_data.class(i)=1;
   end
end 

data = table2cell(temp_data);

sample_no = size(data,1);

rand_num = randperm(sample_no);

X_temp = cell2mat(data(:,2:10)); 
X = X_temp(rand_num(1:end),:);
for i = 1:size(X,1)
    for j= 1:size(X,2)
        if(isnan(X(i,j)))
            X(i,j)=0;
        end
    end
end
noFeatures = size(X,2); 

Y_temp = cell2mat(data(:,11));
Y = Y_temp(rand_num(1:end),:);

Y(isnan(Y))=0;
CV = cvpartition(Y,'KFold',10,'Stratify',true);
