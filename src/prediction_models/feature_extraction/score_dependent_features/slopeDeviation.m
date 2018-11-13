function [sl_dev, av_slope] = slope_deviation(path)
% Computes the deviation from the average slope of a given path
av_slope = (path(end, 2) - path(1,2))/(path(end,1) - path(1,1));
% dist = abs(path(2:end-1,2) - av_slope*path(2:end-1,1)) / sqrt(1 + av_slope*av_slope);
dist = abs(path(2:end-1,2) - av_slope*path(2:end-1,1)+av_slope*path(1,1) - path(1,2)) / sqrt(1 + av_slope*av_slope);
sl_dev = mean(dist);
% dist = zeros(size(path,1),1);
% for i = 1:size(path,1)
%     dist(i) = abs(det([path(end,:) - path(1,:); path(i,:) - path(1,:)]))/abs(norm(path(end,:) - path(1,:)));
% end
% sl_dev = sum(dist);

% dist = abs(path(:,1)*(path(end,2) - path(1,2)) - path(:,2)*(path(end,1) - path(1,1)) + path(end,1)*path(1,2) - path(end,2)*path(1,1));
% sl_dev = sum(dist)