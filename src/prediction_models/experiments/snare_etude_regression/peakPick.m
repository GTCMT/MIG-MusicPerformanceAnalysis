%% Adaptive Peak Picking
% input: nvt = novelty function
%        t = time stamp 
%        Gdma = threshold for each frame
%        fs = sampling frequency
%        hopSize
%        windowSize
% output: osTime = onset time in secs
%         loc = onset location in frames

function [onset, loc] = peakPick(nvt, Gdma, fs, windowSize, hopSize)

%find peaks row by row
[m1,n1] = size(nvt);

%initialization
peaks = zeros(m1,n1); %peak values
ht = hopSize/fs; %hop time
wt = windowSize/fs; %window time
t = (0:n1-1)*ht;


tmp = nvt;
tmp( tmp <= Gdma ) = 0;
dis = ceil(0.01/ht); % 10ms


[~, loc] = findpeaks(tmp,'MINPEAKDISTANCE', dis);

%[~, loc] = findpeaks(tmp);

onset = t(loc);






