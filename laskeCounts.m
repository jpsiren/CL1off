function counts = laskeCounts(data,partition)

nloci = size(data,2);
ninds = size(data,1);
pops = unique(partition);
npops = max(pops);

nall = max(data(:));
counts = zeros(nall,nloci,npops);

for i = 1:ninds
    pop = partition(i);
    rivi = data(i,1:end);
    for l = 1:nall
        counts(l,:,pop) = counts(l,:,pop)+(rivi==l);
    end        
end

counts = counts(:,:,pops);
