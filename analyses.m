resultfile = 'results.mat';

rng(4492649)

% Offenders. Offenders 1-19 correspond to serial cases
uoffender = unique(offender);
offu = zeros(161,1);
for i = 1:length(uoffender); 
    ins = offender==uoffender(i); 
    offu(ins) = i; 
end

% Numbers of one-offs for the simulated datasets
sdatasizes = unique(floor(logspace(0,log10(1044),143))); 
nsizes = length(sdatasizes);

% Number of replicates
ntestpersize = 100;
% Number of bootstrap iterations for the AUC computation
nboot = 1000;


%%

% Analysis with simulated one-offs


AUCscomb = zeros(nsizes,ntestpersize,3);
runtimes = zeros(nsizes,ntestpersize);

% Accuracies for serial and one-off cases
sacccomb = zeros(nsizes,ntestpersize);
oacccomb = zeros(nsizes,ntestpersize);

sensscomb = zeros(nsizes,ntestpersize);
specscomb = zeros(nsizes,ntestpersize);

JRs = zeros(116,nsizes,ntestpersize);
JRavs = zeros(116,nsizes,ntestpersize);



for i = 1:nsizes
    sizei = sdatasizes(i);
    % Mapping from cases to offenders: (same offender for all one-offs)
    newpartcomb = [offu(46:end); 20*ones(sizei,1)];
    % Indicator for offenders with multiple cases
    newseriescomb = true(116+sizei,1);
    
    % Same as above, but with distinct offenders for one-offs.
    newpartition = [offu(46:end); 19 + (1:sizei)'];
    newseries = [true(116,1); false(sizei,1)];
    
    
    parfor j = 1:ntestpersize
        tic
        sdata  = simulateNewCases(data(1:45,:), sizei);
        
        newdata = [data(46:end,:);sdata];
        
        [aucj,predseries,~,sensscomb(i,j),specscomb(i,j)] = analyzeData(newdata,newpartcomb,newseriescomb,nboot);
        AUCscomb(i,j,:) = reshape(aucj,[1 1 3]);
        positives = (predseries==newpartcomb);
        sacccomb(i,j) = sum(positives(1:116))/116;
        oacccomb(i,j) = sum(positives(117:end))/sizei;
                
        [JRs(:,i,j),JRavs(:,i,j)] = computeJaccardRankings(newdata,newpartition,newseries);
        
        runtimes(i,j) = toc;
      
    end
    
    if rem(i,1) ==0
        disp([i sizei]);
        disp(sum(runtimes(i,:)));
    end
end

save(resultfile)
%%
% Analysis with real one-offs

realSizes = sdatasizes(sdatasizes<46);
nrsizes = length(realSizes);

AUCcomb = zeros(nrsizes,ntestpersize,3);

rsacccomb = zeros(nrsizes,ntestpersize);
roacccomb = zeros(nrsizes,ntestpersize);

senscomb = zeros(nrsizes,ntestpersize);
speccomb = zeros(nrsizes,ntestpersize);

JR = zeros(116,nrsizes,ntestpersize);
JRav = zeros(116,nrsizes,ntestpersize);


for i = 1:nrsizes
    sizei = realSizes(i);
    newpartcomb = [offu(46:end); 20*ones(sizei,1)];
    newseriescomb = true(116+sizei,1);
    
    newpartition = [offu(46:end); 19 + (1:sizei)'];
    newseries = [true(116,1); false(sizei,1)];
    
    
    parfor j = 1:ntestpersize
        tic
        % Choose j one-offs from the real cases
        randorder = randperm(45);
        oins = randorder(1:sizei);
        odata  = data(oins,:);
        
        newdata = [data(46:end,:);odata];
        
        [aucj,predseries,~,senscomb(i,j),speccomb(i,j)] = analyzeData(newdata,newpartcomb,newseriescomb,nboot);
        AUCcomb(i,j,:) = reshape(aucj,[1 1 3]);
        positives = (predseries==newpartcomb);
        rsacccomb(i,j) = sum(positives(1:116))/116;
        roacccomb(i,j) = sum(positives(117:end))/sizei;
        
        [JR(:,i,j),JRav(:,i,j)] = computeJaccardRankings(newdata,newpartition,newseries);

    end
    
    if rem(i,1) ==0
        disp([i sizei]);
    end
end

save(resultfile)