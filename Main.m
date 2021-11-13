fprintf("Linear Kernel Implementation\n");
C=1;
model = svmTrain(Xtrain,Ytrain,C,@Linearkernel);
linearPreds = predictLinearSVM(model,Xtest);

