function JI = computeJaccard(X);
% Computes Jaccard ranking between all rows of X, i.e. 1-(Jaccard distance)

JDV = pdist(X,'jaccard');
JD = squareform(JDV);
JI = 1-JD;