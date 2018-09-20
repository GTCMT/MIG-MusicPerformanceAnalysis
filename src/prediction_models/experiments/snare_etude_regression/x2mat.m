%% x2mat function divided a signal into blocks


function [xmat] = x2mat(x, windowSize, hopSize)

N = length(x);
frameNum = floor((N - windowSize)/hopSize + 1);
%initialization
xmat = zeros(windowSize, frameNum);

for i = 1:frameNum
    start = (i-1)*hopSize + 1;
    xmat(:, i) = x(start: start + windowSize -1,1);
end




