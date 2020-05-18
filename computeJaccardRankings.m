function [JR,JRav] = computeJaccardRankings(data,partition,series)

n = size(data,1);
% Treating missing values as 0s
X = double(data==2);

JI = computeJaccard(X);
JI = JI-eye(n);

ns = sum(series);

JR = zeros(ns,1);
JRav = zeros(ns,1);

serinds = find(series);

for i = 1:ns;
    indi = serinds(i);
    parti = partition(indi);
    [~,jarj] = sort(JI(indi,:),'descend');
    hits = find(partition(jarj)==parti);
    
    JR(i) = hits(1);
    
    % Correct for series with multiple cases:
    fixedranks = hits - (0:(length(hits)-1))';
    JRav(i) = median(fixedranks);
end
    
