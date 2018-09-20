%% IOI related features
% objective : histogram peak bandwidth
%
% Chih-Wei Wu, GTCMT, 2014/04

function [peakCrest] = IOIPeakCrest(nelementN, xcenters)

%peak find
[maxPeak, maxIdx] = max(nelementN);

expandFrames = 5;

iStart = maxIdx - expandFrames;
iEnd   = maxIdx + expandFrames;

if iStart < 1
    iStart = 1;
elseif iEnd > length(nelementN)
    iEnd = length(nelementN);
end


selectedRegion = nelementN(iStart : iEnd);

%selectedRegion = nelementN;

%calculate the crest factor
regionSum = sum(selectedRegion);

peakCrest = maxPeak / regionSum;


