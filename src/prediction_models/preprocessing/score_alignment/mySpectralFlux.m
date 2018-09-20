%% Novelty function: spectral flux
% [nvt] = myPeakEnv(x, w, windowSize, hopSize)
% input: 
%   x: N by 1 float vector, input signal
%   windowSize: int, number of samples per block
%   hopSize: int, number of samples per hop
% output: 
%   nvt: n by 1 float vector, the resulting novelty function 

function [nvt] = mySpectralFlux(x, windowSize, hopSize)


% Padding zeros to signal for window centering
x = [zeros(windowSize/2,1);x ;zeros(windowSize/2,1)];

% %Padding zeros to signal if not appropriate size for blocking.
% if(mod(numel(x)-windowSize,hopSize)~=0)
% 	pad = zeros(hopSize-mod(numel(x)-windowSize,hopSize),1);
% 	x = [x; pad];
% end

%Initialize a matrix for all outputs.
numBlocks = ceil((numel(x)-windowSize)/hopSize);
SF_0 = zeros(numBlocks,1);

% Initialize output vector & past spectrum vector
Spec_0=zeros(windowSize,1);


for i=1:numBlocks
    window = hann(windowSize).*x(hopSize*(i-1)+1:hopSize*(i-1)+windowSize);
    Spec_1=fft(window);
    summed_dif = sum(abs(Spec_1)-abs(Spec_0))/2;
    SF_0(i) = sqrt(summed_dif^2)/(windowSize/2);
    Spec_0 = Spec_1;
end

% Compensate for time offset
SF_0 = SF_0(2:end);

% adding a leading 0 for compensating for the time block removed by diff
nvt = [0; SF_0];

% %% Plotting
% figure;
% time_in_sec = [1:length(SF_0)]*hopSize/44100;
% plot(time_in_sec,SF_0)
% % hold on
% % plot(true_onset_time,true_onset_value)
% xlabel('Time (s)')
% ylabel('Novelty')
% title(['Output of ' mfilename ' for x2.wav'])
% xlim([0.97 1.04])
% saveas(gcf,'../Report/Figures/mySpectralFlux_x2.jpg','jpg')
% saveas(gcf,'../Report/Figures/mySpectralFlux_x2.fig','fig')
end