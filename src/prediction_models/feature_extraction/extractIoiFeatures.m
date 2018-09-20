%% Extract IOI related features
% Input:
%   onsetInSec: 1 by n float vector, onset time in sec
% Output:
%   vIoi: 7 by 1 float vector, the resulting IOI feature vector

function [vIoi] = extractIoiFeatures(onsetInSec)

IOI = diff(onsetInSec, [], 2); %IOI (sec)
nBins = 50;
fs = []; %fs is not needed for computing these features
[nelement, xcenters] = hist(IOI, nBins); %histogram

%normalize IOI histogram
histSum = sum(nelement);
nelementN = nelement / histSum;

%IOI histogram features
IOIpeakCrest = IOIPeakCrest(nelementN, xcenters);
IOIbinDiff = mean(diff(xcenters));
IOIskew = FeatureSpectralSkewness(nelementN', fs);
IOIkurto = FeatureSpectralKurtosis(nelementN', fs);
IOIrolloff = FeatureSpectralRolloff(nelementN', fs, 0.85);
% IOIflatness = FeatureSpectralFlatness(nelementN', fs);
IOItonalPower = FeatureSpectralTonalPowerRatio(nelementN', fs);

vIoi = [IOIpeakCrest; IOIbinDiff; IOIskew; IOIkurto; IOIrolloff; ...
        IOItonalPower];