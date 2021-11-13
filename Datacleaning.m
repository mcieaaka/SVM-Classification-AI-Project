data = readtable("breast-cancer-wisconsin.csv");
data = unique(data,"rows");


len = length(data.class);
for i = 1:len
   if(data.class(i)==2)
       data.class(i)=0;
   else
       data.class(i)=1;
   end
end 

data = table2cell(data);
training_data = data(1:414,:);
testing_data = data(415:691,:);

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

Ytrain(isnan(Ytrain)) = 0;
Ytest(isnan(Ytest))=0;