data = readtable("breast-cancer-wisconsin.csv");
data = table2cell(data);
%len = length(data.class);
%for i = 1:len
%    if(data.class(i)==2)
%        data.class(i)=0;
%    else
%        data.class(i)=1;
%    end
%end 
training_data = data(1:559,:);
testing_data = data(560:699,:);

Xtrain = cell2mat(training_data(:,2:10));

noFeatures = size(Xtrain,2);

Ytrain = cell2mat(training_data(:,11));

Xtest = cell2mat(testing_data(:,2:10));
Ytest = cell2mat(testing_data(:,11));

for i = 1:size(Xtrain,1)
    for j= 1:size(Xtrain,2)
        if(isnan(Xtrain(i,j)))
            Xtrain(i,j)=0;
        end
    end
end
for i = 1:size(Xtest,1)
    for j= 1:size(Xtest,2)
        if(isnan(Xtest(i,j)))
            Xtest(i,j)=0;
        end
    end
end
Ytrain(isnan(Ytrain)) = 2;
Ytest(isnan(Ytest))=2;