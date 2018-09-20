%% ACF Algorithm for pitch extraction
% AP@GTCMT, 2015
% acf_results = acf(audio,acf_options)
% objective: Estimate pitch (monophonic) from an audio signal using ACF
%            algorithm. 
%            Should be called within the estimatePitchAlgo function
%
% INPUTS
% audio: Nx1 float array, the mono signal.
% acf_options: 1x1 struct containing the following:
%             sr: Sampling frequency (Fs)
%             hop: The number of samples between each pitch estimate
%             wsize: integration window size
%
% OUTPUTS
% acf_results: 1xM float: pitch estimates, in hertz.
% timeInSec: 1xM float, time stamp for the window

function [acf_results, timeInSec] = acf(audio, acf_options)

% intitializations
sr = acf_options.sr; %sample rate
hop = acf_options.hop; %hop size
wSize = acf_options.wsize; %window size
audio = audio - mean(audio); % removing DC offest if any


% checking for parameter values, else assign defaults
if isempty(hop) hop = 512; end
if isempty(wSize) wSize = 1024; end

% Splitting audio in frames of length wSize separated by hop
[frames, timeInSec] = Windows(audio, wSize, hop, sr);
[~, wid] = size(frames);
f0 = zeros(1, wid); %fundamental frequency matrix

% voicing detection
audioEnergy = sqrt(sum(audio.*audio)/length(audio));
voicingThres = 0.1;


for i = 1:wid
    frameEnergy  = sqrt(sum(frames(:,i).*frames(:,i))/wSize);
    if frameEnergy < audioEnergy*voicingThres
        f0(i) = 0;
    else
        f0(i) = autoCorr(frames(:,i),sr);
    end
end

acf_results = f0;
end