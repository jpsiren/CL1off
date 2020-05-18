function logml = computeLogmlTaulu(data,partition)

nloci = size(data,2);

counts = laskeCounts(data,partition);

sumcounts = squeeze(sum(counts,1))';

if size(sumcounts,2)~=nloci
    sumcounts = sumcounts';
end

apu = squeeze( sum(gammaln(counts+0.5),1))';
if size(apu,2)~=nloci
    apu = apu';
end

logml = -gammaln(sumcounts+1) + ...
    apu - ...
    2*gammaln(0.5);
%logml = -sum(gammaln(sumcounts+2),2) + ...
%    squeeze( sum(sum(gammaln(counts+1),2),1)) - ...
%    2*nloci*gammaln(1);

%------------------------------------------------------
