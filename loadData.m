[N,T] = xlsread('Italian mixed sample (victim order).xlsx');

series = N(:,1);
offender = N(:,2);

%Selecting variables:
%col 74,78,89,110 count variables
%col 109 contains NAN values
%cols 138:147 are sum variables.
%col 148 (age of the victim), not available for all
%cols 149:207 are offender related
%cols 210-216 are sum variables (but what?)


varColumns = [15 26 27 29:40 43:48 51:57 59:62 67:70 75 79:83 86:88 90:97 102:103 ...
106 108 111:120 122 124:129 133:147];


varNames = T(1,varColumns);

data = N(:,varColumns)+1;

data(data>2) = -1;

%NaN entries treated as missing

for i = 1:numel(data);
    if isequaln(data(i),NaN)
        data(i) = -1;
    end
end

