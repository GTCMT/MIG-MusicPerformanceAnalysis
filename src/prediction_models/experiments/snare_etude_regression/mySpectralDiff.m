%% calculating the energy difference
% 
% input: X = a m*n spectrogram
%        
% output: freqWeight = freq weighting based on energy difference
%                      between secutive frames

function [nvtSpecDiff] = mySpectralDiff(X)

%initialization
[m , n] = size(X);
specDiff = zeros(1, n-1);

%calculate the difference

specDiff = diff(sqrt(abs(X)));


% truncate negative values
specDiff( specDiff < 0 ) = 0;

% sum up all freq bins
nvtSpecDiff = sum(specDiff,1);


% scaling
maxVal = max(max(nvtSpecDiff));
minVal = min(min(nvtSpecDiff));
nvtSpecDiff = (nvtSpecDiff - minVal)./(maxVal-minVal);
