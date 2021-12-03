opts = statset('display','iter','UseParallel',true); %Sets the display option
rng(5); %This sets our random state.

fun = @(train_data, train_labels, test_data, test_labels)...
    sum(predict(fitcsvm(train_data, train_labels,'Standardize',true,'KernelFunction','gaussian'), test_data) ~= test_labels);

[fs, history] = sequentialfs(fun, X, Y, 'cv', CV, 'options', opts,'nfeatures',noFeatures);

rng(3);
bc_Accuracy(noFeatures,6) = 0; %Initializes where we'll store our performance for each feature set and kernel
for count=1:noFeatures
    %MStore our best features
    bc_Accuracy(count,1) = count;
    
    %Linear
    bc_Model= fitcsvm(X(:,history.In(count,:)),Y,'BoxConstraint',1,'CVPartition',CV,'KernelFunction',...
        'linear','Standardize',true,'KernelScale','auto');
    %This averages our cross validated models loss. The lower the better the prediction
    % Compute validation accuracy
    bc_Accuracy(count,2) = (1 - kfoldLoss(bc_Model, 'LossFun', 'ClassifError'))*100;

    %Gaussian
    bc_Model= fitcsvm(X(:,history.In(count,:)),Y,'BoxConstraint',1,'CVPartition',CV,'KernelFunction',...
        'gaussian','Standardize',true,'KernelScale','auto');
    %This averages our cross validated models loss. The lower the better the prediction
    % Compute validation accuracy
    bc_Accuracy(count,3) = (1 - kfoldLoss(bc_Model, 'LossFun', 'ClassifError'))*100;
    

end

figure
plot(bc_Accuracy(:,2:6))
title('Model Perfomance')
xlabel('Number of Ranked Features')
ylabel('Model Perfomance(%)')
legend('Linear','Gaussian')
grid on;

cost.ClassNames = {'1' '0'};
cost.ClassificationCosts = [0 1;1 0];
rng(3);

bc_Model = fitcsvm(X(:,history.In(5,:)),Y,'KernelFunction','gaussian','Cost',cost,'Standardize',true,...
    'OptimizeHyperparameters','auto','HyperparameterOptimizationOptions',struct('UseParallel',true,...
    'ShowPlots',false,'MaxObjectiveEvaluations',80,'Repartition',true));

rng(3); 

constraint = bc_Model.BoxConstraints(1,:);
kernelScale = bc_Model.KernelParameters.Scale;

best_Model = fitcsvm(X(:,history.In(4,:)),Y,'CVPartition',CV,'KernelFunction',...
    'gaussian','Standardize',true,'BoxConstraint',constraint,'KernelScale',kernelScale,'Cost',cost);

validationAccuracy = (1 - kfoldLoss(best_Model, 'LossFun', 'ClassifError'))*100
bc_ModelLoss = kfoldLoss(best_Model)

[Y_pred, validationScores] = kfoldPredict(best_Model);
conMat=confusionmat(Y,Y_pred);

conMatHeat = heatmap(conMat,'Title','Breast Cancer Wisconsin Confusion Matrix','YLabel','True Diagnosis','XLabel','Predicted Diagnosis',...
    'XDisplayLabels',{'Healthy(1)','Patients(2)'},'YDisplayLabels',{'Healthy(1)','Patients(2)'},'ColorbarVisible','off');
%The following functions compute the precision and F1 Score
precisionFunc = @(confusionMat) diag(confusionMat)./sum(confusionMat,2);
recallFunc = @(confusionMat) diag(confusionMat)./sum(confusionMat,1);
f1ScoresFunc = @(confusionMat) 2*(precisionFunc(confusionMat).*recallFunc(confusionMat))./(precisionFunc(confusionMat)+recallFunc(confusionMat));
meanF1Func = @(confusionMat) mean(f1ScoresFunc(confusionMat));

falseNegativeRate = (conMat(2,1)/(conMat(2,1)+conMat(2,2)))*100

precision = precisionFunc(conMat)
recall = recallFunc(conMat)
f1Score = meanF1Func(conMat)
