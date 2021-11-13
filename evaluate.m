function [EvalParams] = evaluate(Y,Ypred)
       TP=0;FP=0;TN=0;FN=0;
      for i=1:277
          if(Y(i)==1 && Ypred(i)==1)
              TP=TP+1;
          elseif(Y(i)==0 && Ypred(i)==1)
              FP=FP+1;
          elseif(Y(i)==0 && Ypred(i)==0)
              TN=TN+1;
          elseif(Y(i)==1 && Ypred(i)==0)
              FN=FN+1;
          end
      end
      
      precision = TP/(TP+FP);
      recall = TP/(TP+FN);
      accuracy = (TP+TN)/(TP+TN+FP+FN);
      
      cfm=[TP FP;FN TN];
      
      EvalParams.cfm=cfm;
      EvalParams.precision = precision;
      EvalParams.recall = recall;
      EvalParams.accuracy = accuracy;
end
