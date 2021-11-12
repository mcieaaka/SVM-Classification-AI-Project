data = readtable("breast-cancer-wisconsin.csv");

len = length(data.class);
for i = 1:len
    if(data.class(i)==2)
        data.class(i)=0;
    else
        data.class(i)=1;
    end
end 
    

training_data = data(1:559,:);
testing_data = data(560:699,:);