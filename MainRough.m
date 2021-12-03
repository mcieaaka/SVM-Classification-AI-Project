fprintf("Linear Kernel Implementation\n");
C=1;
model = svmTrain(Xtrain,Ytrain,C,@Linearkernel);
linearPreds = predictLinearSVM(model,Xtest);

%Evaluation Params
iswrong = ~(linearPreds==Ytest);
misclassrate = sum(iswrong)/numel(iswrong);
confusionchart(Ytest,linearPreds,"RowSummary","row-normalized");
EvalLinear = evaluate(Ytest,linearPreds);
fprintf("Confusion Matrix=\n");
disp(EvalLinear.cfm);
fprintf("Precision=");
disp(EvalLinear.precision);
fprintf("Recall=");
disp(EvalLinear.recall);
fprintf("Accuracy=");
disp(EvalLinear.accuracy*100);

% fprintf("Gaussian Kernel:\n");
% C = 1; sigma = 0.1;
% model= fitcsvm(Xtrain,Ytrain);
% disp(model)
% Label = predict(model,Xtest);
% ConfusionTrain = confusionchart(Ytest,Label);