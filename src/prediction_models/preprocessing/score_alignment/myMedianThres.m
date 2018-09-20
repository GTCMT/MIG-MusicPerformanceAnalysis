%% Adaptive threshold: median filter
% [thres] = myMedianThres(nvt, order, lambda)
% input: 
%   nvt: m by 1 float vector, the novelty function
%   order: int, size of the sliding window in samples
%   lambda: float, a constant coefficient for adjusting the threshold
% output:
%   thres = m by 1 float vector, the adaptive median threshold

function [thres] = myMedianThres(nvt, order, lambda)
% YOUR CODE HERE: 

% Padding zeros before and after the Novelty function for window centering
nvt_pad = [zeros(floor(order/2),1); nvt; zeros(floor(order/2),1)];

DC_thres = max(nvt)*lambda;
thres = DC_thres*ones(numel(nvt),1);
for i = 1:numel(nvt)-1
    window = nvt_pad(i:i+order);
    thres(i) = thres(i) + median(window);
end


% figure;
% time_in_sec = [1:length(nvt)]*256/44100;
% plot(time_in_sec, thres,'g','linewidth',2)
% hold on
% plot(time_in_sec, nvt,'r')
% xlabel('Time (s)')
% ylabel('Novelty')
% title(['Output of ' mfilename ' for order=' num2str(order) ', lambda=' num2str(lambda)])
% saveas(gcf,['../Report/Figures/' mfilename '_ord' num2str(order) '_lam' num2str(lambda) '.jpg'],'jpg')
% saveas(gcf,['../Report/Figures/' mfilename '_ord' num2str(order) '_lam' num2str(lambda) '.fig'],'fig')
end