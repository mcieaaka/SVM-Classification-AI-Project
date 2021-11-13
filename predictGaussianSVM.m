function pred = predictGaussianSVM(model, X)
if (size(X, 2) == 1)
    X = X';
end

% Dataset 
m = size(X, 1);
p = zeros(m, 1);
pred = zeros(m, 1);


if contains(func2str(model.kernelFunction), 'gaussianKernel')
    X1 = sum(X.^2, 2);
    X2 = sum(model.X.^2, 2)';
    K = bsxfun(@plus, X1, bsxfun(@plus, X2, - 2 * X * model.X'));
    K = model.kernelFunction(1, 0) .^ K;
    K = bsxfun(@times, model.y', K);
    K = bsxfun(@times, model.alphas', K);
    p = sum(K, 2);

end
pred(p >= 0) =  1;
pred(p <  0) =  0;

end

