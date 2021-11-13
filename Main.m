% fprintf("Linear Kernel Implementation\n");
% C=1;
% model = svmTrain(Xtrain,Ytrain,C,@Linearkernel);
% linearPreds = predictLinearSVM(model,Xtest);
% 
% %Evaluation Params
% iswrong = ~(linearPreds==Ytest);
% misclassrate = sum(iswrong)/numel(iswrong);
% confusionchart(Ytest,linearPreds,"RowSummary","row-normalized");
% EvalLinear = evaluate(Ytest,linearPreds);
% fprintf("Confusion Matrix=\n");
% disp(EvalLinear.cfm);
% fprintf("Precision=");
% disp(EvalLinear.precision);
% fprintf("Recall=");
% disp(EvalLinear.recall);
% fprintf("Accuracy=");
% disp(EvalLinear.accuracy*100);

fprintf("Gaussian Kernel:\n");
C = 1; sigma = 0.1;
model= svmTrain(Xtrain, Ytrain, C, @(x1, x2) gaussianKernel(x1, x2, sigma));
GaussianPreds = predictGaussianSVM(model,Xtest);
iswrong = ~(GaussianPreds==Ytest);
misclassrategauss = sum(iswrong)/numel(iswrong);
confusionchart(Ytest,GaussianPreds,"RowSummary","row-normalized");
EvalGauss = evaluate(Ytest,GaussianPreds);
fprintf("Confusion Matrix=\n");
disp(EvalGauss.cfm);
fprintf("Precision=");
disp(EvalGauss.precision);
fprintf("Recall=");
disp(EvalGauss.recall);
fprintf("Accuracy=");
disp(EvalGauss.accuracy*100);