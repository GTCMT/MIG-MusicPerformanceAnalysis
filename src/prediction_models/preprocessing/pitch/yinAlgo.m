%% YIN Algorithm for pitch extraction
% AP@GTCMT, 2015
% yin_results = yinAlgo(audio,yin_options)
% objective: Estimate pitch (monophonic) from an audio signal using ACF
%            algorithm. 
%            Should be called within the estimatePitchAlgo function
%
% INPUTS
% audio: Nx1 float array, the mono signal.
% yin_options: 1x1 struct containing the following:
%             sr: Sampling frequency (Fs)
%             hop: The number of samples between each pitch estimate
%             wsize: integration window size
%
% OUTPUTS
% yin_results: 1xM float: pitch estimates, in hertz.
% timeInSec: 1xM float, time stamp for the window

function [yin_results, timeInSec] = yinAlgo(audio, yin_options)

% intitializations
N = length(audio); %number of samples
sr = yin_options.sr; %sample rate
hop = yin_options.hop; %hop size
wSize = yin_options.wsize; %window size
audio = audio - mean(audio); %removing DC offest if any
numWindows = ceil((N-wSize)/hop)+2;
timeInSec = zeros(1,numWindows);
idx = 1;

for i = 1:numWindows
    timeInSec(i) = (idx-1)/sr;
    idx = idx + hop;
end

%[~, timeInSec] = Windows(audio, wSize, hop, sr);
yin_output = yin(audio,yin_options);
yin_results = yin_output.f0; %gives output in octaves re: 440 Hz
yin_results = 440*(2.^yin_results);

yin_results(isnan(yin_results)) = 0;
yin_results = [0,yin_results(1:end-1)];
end