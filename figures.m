%%
clrs = {'r','b','c','y'};
lns = {'-',':'};
alfa = 0.025;
sets = {'Simulated','Real'};
bnds = [0 max(sdatasizes) 0.7 1];
bndsspec = [0 max(sdatasizes) 0.55 1];

bndsrank = [0 max(sdatasizes) 0 40];
bndsav = [0 max(sdatasizes) 0 1];


studies = [30 166 66];
ticks = [1 3 10 100 1000];
ticks = sort([ticks studies]);

pos = [2 2 18 10];
reso = '-r300';

% Means and averages of the measures
% s in the name refers to simulated one-offs, without s to real one-offs

% AUC
% The means (mAUCcomb, mAUCscomb) includes averages over the mean AUC
% estimate and lower and upper bounds over simulated datasets
% The quantiles (qAUCcomb, qAUCscomb) include lower and upper quantiles
% of the mean AUC over simulated datasets

mAUCcomb = squeeze(mean(AUCcomb,2));
mAUCscomb = squeeze(mean(AUCscomb,2));
qAUCcomb = quantile(AUCcomb(:,:,1),[alfa 1-alfa],2);
qAUCscomb = quantile(AUCscomb(:,:,1),[alfa 1-alfa],2);

% Sensitivity and specificity
% Computed at Youden's index J

msenscomb = mean(senscomb,2);
qsenscomb = quantile(senscomb,[alfa 1-alfa],2);
mspeccomb = mean(speccomb,2);
qspeccomb = quantile(speccomb,[alfa 1-alfa],2);

msensscomb = mean(sensscomb,2);
qsensscomb  = quantile(sensscomb,[alfa 1-alfa],2);
mspecscomb = mean(specscomb,2);
qspecscomb = quantile(specscomb,[alfa 1-alfa],2);

% Jaccard rankings

% Median ranks, variation and averages over datasets.

medJRs = squeeze(median(JRs,1));
medJR = squeeze(median(JR,1));

meanmedJRs = mean(medJRs,2);
meanmedJR = mean(medJR,2);
qmedJRs = quantile(medJRs,[alfa 1-alfa], 2);
qmedJR = quantile(medJR,[alfa 1-alfa], 2);

% Average over datasets, median and variation over cases

meanJRs = mean(JRs,3)';
meanJR = mean(JR,3)';

medmeanJRs = median(meanJRs,2);
medmeanJR = median(meanJR,2);
qmeanJRs = quantile(meanJRs,[alfa 1-alfa],2);
qmeanJR = quantile(meanJR,[alfa 1-alfa],2);

% Proportion of cases for which the top rank is the 

prop1JRs = squeeze(mean(JRs==1,1));
prop1JR = squeeze(mean(JR==1,1));

meanprop1JRs = mean(prop1JRs,2);
meanprop1JR = mean(prop1JR,2);
qprop1JRs = quantile(prop1JRs,[alfa 1-alfa],2);
qprop1JR = quantile(prop1JR,[alfa 1-alfa],2);

% Proportions of cases with median of the hits within top 5 / 20 after 
% ranking with Jaccard
% prop1: top5, prop20: top 20.

prop1JRavs = squeeze(mean(JRavs<=5,1));
prop1JRav = squeeze(mean(JRav<=5,1));

meanprop1JRavs = mean(prop1JRavs,2);
meanprop1JRav = mean(prop1JRav,2);
qprop1JRavs = quantile(prop1JRavs,[alfa 1-alfa],2);
qprop1JRav = quantile(prop1JRav,[alfa 1-alfa],2);

prop20JRavs = squeeze(mean(JRavs<=20,1));
prop20JRav = squeeze(mean(JRav<=20,1));

meanprop20JRavs = mean(prop20JRavs,2);
meanprop20JRav = mean(prop20JRav,2);
qprop20JRavs = quantile(prop20JRavs,[alfa 1-alfa],2);
qprop20JRav = quantile(prop20JRav,[alfa 1-alfa],2);

%%

% AUC as a function of dataset size

h1 = figure;
subplot(1,2,1);
hold on

p = zeros(1,2);

p(1) = plot(sdatasizes',mAUCscomb(:,1),[clrs{1} lns{1}]);
p(2) = plot(realSizes',mAUCcomb(:,1),[clrs{2} lns{1}]);
plot(sdatasizes',mAUCscomb(:,2:3),[clrs{1} lns{2}]);
plot(realSizes',mAUCcomb(:,2:3),[clrs{2} lns{2}]);


xlabel('Number of one-offs');
ylabel('AUC');
title('Uncertainty in estimates')


set(gca,'FontSize',7);
 a = gca;
a.XScale = 'log';
axis(bnds);
a.XTick = ticks;

for i = 1:length(studies)
    sti = studies(i);
    plot([sti sti], bnds(3:4),'k:');
end

legend(p,sets,'Location','Best');


subplot(1,2,2);
hold on

p(1) = plot(sdatasizes',mAUCscomb(:,1),[clrs{1} lns{1}]);
p(2) = plot(realSizes',mAUCcomb(:,1),[clrs{2} lns{1}]);
%
plot(sdatasizes',qAUCscomb,[clrs{1} lns{2}]);
plot(realSizes',qAUCcomb,[clrs{2} lns{2}]);

xlabel('Number of one-offs');
ylabel('AUC');
title('Variation among simulations')

set(gca,'FontSize',7);
a = gca;
a.XScale = 'log';
axis(bnds);
a.XTick = ticks;

for i = 1:length(studies)
    sti = studies(i);
    plot([sti sti], bnds(3:4),'k:');
end
legend(p,sets,'Location','Best');


set(h1, 'Units','centimeters', 'Position',pos)
 filename = 'AUC.png';
 print(h1,filename,'-dpng',reso);
 close(h1);
 
 %%

h1 = figure;
subplot(1,2,1);
hold on

p = zeros(1,2);

p(1) = plot(sdatasizes',msensscomb,[clrs{1} lns{1}]);
p(2) = plot(realSizes',msenscomb,[clrs{2} lns{1}]);
plot(sdatasizes',qsensscomb,[clrs{1} lns{2}]);
plot(realSizes',qsenscomb,[clrs{2} lns{2}]);


xlabel('Number of one-offs');
ylabel('Sensitivity');


set(gca,'FontSize',7);
 a = gca;
a.XScale = 'log';
axis(bndsspec);
a.XTick = ticks;

for i = 1:length(studies)
    sti = studies(i);
    plot([sti sti], bndsspec(3:4),'k:');
end

legend(p,sets,'Location','Best');



subplot(1,2,2);
hold on

p(1) = plot(sdatasizes',mspecscomb,[clrs{1} lns{1}]);
p(2) = plot(realSizes',mspeccomb,[clrs{2} lns{1}]);
plot(sdatasizes',qspecscomb,[clrs{1} lns{2}]);
plot(realSizes',qspeccomb,[clrs{2} lns{2}]);


xlabel('Number of one-offs');
ylabel('Specificity');

set(gca,'FontSize',7);
a = gca;
a.XScale = 'log';
axis(bndsspec);
a.XTick = ticks;

for i = 1:length(studies)
    sti = studies(i);
    plot([sti sti], bndsspec(3:4),'k:');
end

legend(p,sets,'Location','Best');



set(h1, 'Units','centimeters', 'Position',pos)
 filename = 'sensspec.png';
 print(h1,filename,'-dpng',reso);
 close(h1);

 
 %%

h1 = figure;
subplot(1,2,1);
hold on

p = zeros(1,2);

p(1) = plot(sdatasizes',meanmedJRs,[clrs{1} lns{1}]);
p(2) = plot(realSizes',meanmedJR,[clrs{2} lns{1}]);
plot(sdatasizes',qmedJRs,[clrs{1} lns{2}]);
plot(realSizes',qmedJR,[clrs{2} lns{2}]);


xlabel('Number of one-offs');
ylabel('Rank');
title('Variation over simulated datasets');


set(gca,'FontSize',7);
 a = gca;
a.XScale = 'log';
axis(bndsrank);
a.XTick = ticks;

for i = 1:length(studies)
    sti = studies(i);
    plot([sti sti], bndsrank(3:4),'k:');
end

legend(p,sets,'Location','Best');


subplot(1,2,2);
hold on

p(1) = plot(sdatasizes',medmeanJRs,[clrs{1} lns{1}]);
p(2) = plot(realSizes',medmeanJR,[clrs{2} lns{1}]);
plot(sdatasizes',qmeanJRs,[clrs{1} lns{2}]);
plot(realSizes',qmeanJR,[clrs{2} lns{2}]);



xlabel('Number of one-offs');
ylabel('Rank');
title('Variation over cases');


set(gca,'FontSize',7);
a = gca;
a.XScale = 'log';
axis(bndsrank);
a.XTick = ticks;

for i = 1:length(studies)
    sti = studies(i);
    plot([sti sti], bndsrank(3:4),'k:');
end

legend(p,sets,'Location','Best');


set(h1, 'Units','centimeters', 'Position',pos)
 filename = 'rank.png';
 print(h1,filename,'-dpng',reso);
 close(h1);

 

 %%

h1 = figure;
hold on

p = zeros(1,2);

p(1) = plot(sdatasizes',meanprop1JRs,[clrs{1} lns{1}]);
p(2) = plot(realSizes',meanprop1JR,[clrs{2} lns{1}]);
plot(sdatasizes',qprop1JRs,[clrs{1} lns{2}]);
plot(realSizes',qprop1JR,[clrs{2} lns{2}]);


xlabel('Number of one-offs');
ylabel('Proportion of rank 1');
title('Variation over simulated datasets');


set(gca,'FontSize',7);
 a = gca;
a.XScale = 'log';
axis(bnds);
a.XTick = ticks;

for i = 1:length(studies)
    sti = studies(i);
    plot([sti sti], bnds(3:4),'k:');
end

legend(p,sets,'Location','Best');



set(h1, 'Units','centimeters', 'Position',pos)
 filename = 'rank1prop.png';
 print(h1,filename,'-dpng',reso);
 
close(h1);

%%

h1 = figure;

subplot(1,2,1);
hold on

p = zeros(1,2);

p(1) = plot(sdatasizes',meanprop1JRavs,[clrs{1} lns{1}]);
p(2) = plot(realSizes',meanprop1JRav,[clrs{2} lns{1}]);
plot(sdatasizes',qprop1JRavs,[clrs{1} lns{2}]);
plot(realSizes',qprop1JRav,[clrs{2} lns{2}]);


xlabel('Number of one-offs');
ylabel('Proportion');
title('Proportion in top 5');


set(gca,'FontSize',7);
 a = gca;
a.XScale = 'log';
axis(bndsav);
a.XTick = ticks;

for i = 1:length(studies)
    sti = studies(i);
    plot([sti sti], bndsav(3:4),'k:');
end

legend(p,sets,'Location','Best');

subplot(1,2,2);

hold on

p = zeros(1,2);

p(1) = plot(sdatasizes',meanprop20JRavs,[clrs{1} lns{1}]);
p(2) = plot(realSizes',meanprop20JRav,[clrs{2} lns{1}]);
plot(sdatasizes',qprop20JRavs,[clrs{1} lns{2}]);
plot(realSizes',qprop20JRav,[clrs{2} lns{2}]);


xlabel('Number of one-offs');
ylabel('Proportion');
title('Proportion in top 20');


set(gca,'FontSize',7);
 a = gca;
a.XScale = 'log';
axis(bndsav);
a.XTick = ticks;

for i = 1:length(studies)
    sti = studies(i);
    plot([sti sti], bndsav(3:4),'k:');
end

legend(p,sets,'Location','Best');



set(h1, 'Units','centimeters', 'Position',pos)
 filename = 'avrankprop.png';
 print(h1,filename,'-dpng',reso);
 
close(h1);
 