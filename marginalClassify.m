function [partition,clsdist,clsvarlog] = marginalClassify(trData,tsData,trPartition,ncls);

ninds = size(tsData,1);

if nargin < 4
    ncls = length(unique(trPartition));
end

nvar = size(trData,2);
partition = zeros(ninds,1);

notEmpty = unique(trPartition);
trLogmlTable = zeros(ncls,nvar);

trLogmlTable(notEmpty,:) = computeLogmlTable(trData,trPartition);
trLogml = sum(trLogmlTable,2);

data =  [trData; tsData(1,:)];
prt = [trPartition; 1];

for i = 1:ninds
    data(end,:) = tsData(i,:);
    
    newLogmlTable = zeros(size(trLogmlTable));
    
    for j = 1:ncls
        prt(end) = j;
        
        inx = (prt==j);
        
        newLogmlTable(j,:) = computeLogmlTable(data(inx,:),prt(inx));
    end
    clsvarlog = newLogmlTable-trLogmlTable;
    newLogml = sum(newLogmlTable,2);
    clsdist = newLogml-trLogml;
    [~,in] = max(clsdist);
        
    partition(i) = in;
end