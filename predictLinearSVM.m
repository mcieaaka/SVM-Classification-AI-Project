function pred = predictLinearSVM(model, X)

if (size(X, 2) == 1)
    % Examples should be in rows
    X = X';
end

% Dataset 
m = size(X, 1);
p = zeros(m, 1);
pred = zeros(m, 1);

if strcmp(func2str(model.kernelFunction), 'Linearkernel')
    p = X * model.w + model.b;
end

pred(p >= 0) =  1;
pred(p <  0) =  0;

end

