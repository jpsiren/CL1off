    function [AUC,predseries,preddist,sens,spec] = analyzeData(data,partition,isseries,nboot);

if nargin<4
    nboot = 0;
end



[predseries,lpreddist] = leaveOneOutClassify(data,partition,isseries);

nclasses = size(lpreddist,2);

matches = predseries==partition;
lpreddist = lpreddist - repmat(max(lpreddist,[],2),1,nclasses);
preddist = exp(lpreddist)./repmat(sum(exp(lpreddist),2),1,nclasses);
maxprob = max(preddist,[],2);
[X,Y,~,AUC] = perfcurve(matches,maxprob,true,'NBoot',nboot);

%Youden's J maximization location
[~,J] = max(Y(:,1)-X(:,1));

sens = Y(J,1);
spec = 1-X(J,1);