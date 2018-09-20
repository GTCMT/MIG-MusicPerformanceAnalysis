%% Windowing Function
% frames = Windows(x, wSize, hop)
% objective: Return overlapping windows given a array, window size and hop size  
%
% INPUTS
% x: N x 1 float array, audio signal 
% wSize: window size
% hop: hop size
% fs = sampling frequency
%
% OUTPUTS
% frames: wSize x n matrix of frames, n being the number of windows
% timeInSec: timestamp for the window in seconds

function [frames, timeInSec] = Windows(audio, wSize, hop, fs)

% zeropadding in the beginning
zeropadaudio = [zeros(wSize/2,1);audio;zeros(wSize/2,1)];
N = length(zeropadaudio); %length of audio file

% creating frames based on wSize and hop
idx = 1; % sample index 
i = 1;
numWindows = ceil((N-wSize)/hop);
frames = zeros(wSize,numWindows);
timeInSec = zeros(1,numWindows);

for i = 1:numWindows
    frames(1:min(idx+wSize,N)-idx,i) = zeropadaudio(idx:min(idx+wSize,N)-1);
    timeInSec(i) = (idx-1)/fs;
    idx = idx + hop;
end

end