%% onset detection with adaptive thresholding
% [onsetTimeInSec] = myOnsetDetection(nvt, fs, windowSize, hopSize)
% input: 
%   x: N by 1 float vector, input signal
%   fs: float, sampling frequency in Hz
%   windowSize: int, number of samples per block
%   hopSize: int, number of samples per hop
% output: 
%   onsetTimeInSec: n by 1 float vector, onset time in second

function [onsetTimeInSec] = myOnsetDetection(nvt, fs, windowSize, hopSize)

thres = myMedianThres(nvt, 13, 0.15);

filtered_nvt = nvt - thres;
filtered_nvt(filtered_nvt<0) = 0;

[~, peaks] = findpeaks(filtered_nvt);

onsetTimeInSec = peaks.*hopSize/fs;

% figure;
% time_in_sec = [1:length(nvt)]*hopSize/fs;
% plot(time_in_sec, filtered_nvt,'g','linewidth',2)
% hold on
% plot(time_in_sec, nvt,'r')
% xlabel('Time (s)')
% ylabel('Novelty')
% title(['Output of ' mfilename ' for x2.wav'])
% xlim([0.97 1.05])
% saveas(gcf,['../Report/Figures/' mfilename '_x2.jpg'],'jpg')
% saveas(gcf,['../Report/Figures/' mfilename '_x2.fig'],'fig')

end