function [model] = svmTrain(X,Y,C,kernelFunction)
    tol = 1e-3;
    max_passes = 20;
    
    m= size(X,1);
    n= size(X,2);
    
    Y(Y==2) = -1;
    Y(Y==4) = 1;
    alphas = zeros(m,1);
    b=0;
    E = zeros(m, 1);
    passes = 0;
    eta = 0;
    L = 0;
    H = 0;
    
    if strcmp(func2str(kernelFunction),'Linearkernel')
        K = X*X';
    end
    
    while passes < max_passes,
            
    num_changed_alphas = 0;
        for i = 1:m,

            % Calculate Ei = f(x(i)) - y(i) using (2). 
            % E(i) = b + sum (X(i, :) * (repmat(alphas.*Y,1,n).*X)') - Y(i);
            E(i) = b + sum (alphas.*Y.*K(:,i)) - Y(i);

            if ((Y(i)*E(i) < -tol && alphas(i) < C) || (Y(i)*E(i) > tol && alphas(i) > 0)),

                % In practice, there are many heuristics one can use to select
                % the i and j. In this simplified code, we select them randomly.
                j = ceil(m * rand());
                while j == i,  % Make sure i \neq j
                    j = ceil(m * rand());
                end

                % Calculate Ej = f(x(j)) - y(j) using (2).
                E(j) = b + sum (alphas.*Y.*K(:,j)) - Y(j);

                % Save old alphas
                alpha_i_old = alphas(i);
                alpha_j_old = alphas(j);

                % Compute L and H by (10) or (11). 
                if (Y(i) == Y(j)),
                    L = max(0, alphas(j) + alphas(i) - C);
                    H = min(C, alphas(j) + alphas(i));
                else
                    L = max(0, alphas(j) - alphas(i));
                    H = min(C, C + alphas(j) - alphas(i));
                end

                if (L == H),
                    % continue to next i. 
                    continue;
                end

                % Compute eta by (14).
                eta = 2 * K(i,j) - K(i,i) - K(j,j);
                if (eta >= 0),
                    % continue to next i. 
                    continue;
                end

                % Compute and clip new value for alpha j using (12) and (15).
                alphas(j) = alphas(j) - (Y(j) * (E(i) - E(j))) / eta;

                % Clip
                alphas(j) = min (H, alphas(j));
                alphas(j) = max (L, alphas(j));

                % Check if change in alpha is significant
                if (abs(alphas(j) - alpha_j_old) < tol),
                    % continue to next i. 
                    % replace anyway
                    alphas(j) = alpha_j_old;
                    continue;
                end

                % Determine value for alpha i using (16). 
                alphas(i) = alphas(i) + Y(i)*Y(j)*(alpha_j_old - alphas(j));

                % Compute b1 and b2 using (17) and (18) respectively. 
                b1 = b - E(i) ...
                     - Y(i) * (alphas(i) - alpha_i_old) *  K(i,j)' ...
                     - Y(j) * (alphas(j) - alpha_j_old) *  K(i,j)';
                b2 = b - E(j) ...
                     - Y(i) * (alphas(i) - alpha_i_old) *  K(i,j)' ...
                     - Y(j) * (alphas(j) - alpha_j_old) *  K(j,j)';

                % Compute b by (19). 
                if (0 < alphas(i) && alphas(i) < C),
                    b = b1;
                elseif (0 < alphas(j) && alphas(j) < C),
                    b = b2;
                else
                    b = (b1+b2)/2;
                end

                num_changed_alphas = num_changed_alphas + 1;

            end

        end

        if (num_changed_alphas == 0),
            passes = passes + 1;
        else
            passes = 0;
        end

        
        if exist('OCTAVE_VERSION')
            fflush(stdout);
        end
    end
    idx = alphas > 0;
    model.X= X(idx,:);
    model.y= Y(idx);
    model.kernelFunction = kernelFunction;
    model.b= b;
    model.alphas= alphas(idx);
    model.w = ((alphas.*Y)'*X)';

end