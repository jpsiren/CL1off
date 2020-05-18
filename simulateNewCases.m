function sdata = simulateNewCases2(basedata,nsamples)

nbase = size(basedata,1);
npar = size(basedata,2);

randins = ceil(nbase*rand(nsamples,npar));
sdata = zeros(nsamples,npar);

for i = 1:npar
    sdata(:,i) = basedata(randins(:,i),i);
end 