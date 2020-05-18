function [partitionEst,clsdist,clsvarlog] = leaveOneOutClassify(data,partition,series);

n = size(data,1);m = size(data,2);

K = max(partition);

partitionEst = zeros(size(partition));
clsdist = -1e50*ones(n,K+1);
clsvarlog = -1e50*ones(K+1,m,n);

for i = 1:n
    ins = [1:(i-1) (i+1):n];
    trData = data(ins,:);
    tsData = data(i,:);
    trPartition = partition(ins);
    ncls = K + series(i);
    [partitionEst(i), clsdisti,clsvarlogi] = marginalClassify(trData,tsData,trPartition,ncls);
    if ~series(i)
        clsdisti = [clsdisti' -1e50];
        clsvarlogi = [clsvarlogi; repmat(-1e50,1,m)];
    end
    clsdist(i,:) = clsdisti;
    clsvarlog(:,:,i) = clsvarlogi;
    if rem(i,5)==0
        %disp(i);
    end
end