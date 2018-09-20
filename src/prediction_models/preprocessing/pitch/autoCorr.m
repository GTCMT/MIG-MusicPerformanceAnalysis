%% AutoCorrelation Calculation for ACF pitch extraction
% AP@GTCMT, 2015
% f0 = autoCorr(frame,fs)
% objective: Calculate auto-correlation of a audio frame 
%
% INPUTS
% frame: wSizex1 float array, single frame of audio signal where wSize is
%        the window Size
% fs: sampling frequency
%
% OUTPUTS
% f0: fundamental frequency of the frame in Hz

function f0 = autoCorr(frame,fs)

% Initialization
wSize = length(frame);
autoCorrelation = zeros(1,wSize); %initialize autocorrelation matrix
i = 1;

% centre clipping
threshold = 0.001;
frame(abs(frame)<threshold) = 0;

%{
while(i<=wSize);
    frameShifted = [zeros(i,1);frame(1:wSize-i)];
    autoCorrelation(i) = sum(frame.*frameShifted);
    i = i+1;
end
autoCorrelation = autoCorrelation/autoCorrelation(1);
%}

autoCorrelation = xcorr(frame, 'coeff');
autoCorrelation = autoCorrelation(length(frame):end);
maxOffset = round(fs/100); % considering 100Hz as lower freq
minOffset = round(fs/1000); % considering 1000Hz as higher freq

autoCorrelation = smooth(autoCorrelation,'moving',5);
% find 1st minimum to further narrow down search region
[~, indmin] = findpeaks(-autoCorrelation);
if(~isempty(indmin))
    if(minOffset<=indmin(1) && indmin(1)+3<maxOffset )
        minOffset = indmin(1);
    end
end

[maxima, indmax] = findpeaks(autoCorrelation(minOffset:maxOffset));

if (isempty(maxima) == 1)
f0 = 0;
else
[~,ind1] = max(maxima);
idx1 = indmax(ind1)+minOffset-1;
f0 = fs/idx1;
end

% spectra = abs(fft(frame));
% spectra = spectra(1:wSize/2);
% [maxSpectra, ind] = findpeaks(spectra);
% [~,maxInd] = max(maxSpectra);
% indMax = ind(maxInd);
% f0dash = fs*(indMax-1)/wSize;
% 
% if(abs(f0dash-f0) < 10)
%     f0 = f0dash;
% end


end