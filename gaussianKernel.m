function sim = gaussianKernel(x1, x2, sigma)
x1 = x1(:); x2 = x2(:);
sim = 0;


denom = 2* sigma^2;
num = sum((x1-x2).^2);
t = num/denom;
sim = exp(-t);
    
end