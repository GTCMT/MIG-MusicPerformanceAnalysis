%% Wavelet based algorithm for pitch detection 
% freq = wavelet(audio, wavelet_options)
% AP@GTCMT, 2015
% acf_results = acf(audio,acf_options)
% objective: Estimate pitch (monophonic) from an audio signal using wavelet
%            based algorithm. 
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
%
%   Copyright 2005 Ross Maddox (University of Michigan)
%              and Eric Larson (Kalamazoo College)

function [wavelet_results, timeInSec] = wavelet(audio,wavelet_options)
    
% intitializations
N = length(audio); %length of audio file
sr = wavelet_options.sr; %sample rate
hop = wavelet_options.hop; %hop size
wSize = wavelet_options.wsize; %window size

% checking for parameter values, else assign defaults
if isempty(hop) hop = 512; end
if isempty(wSize) wSize = 1024; end

% Frame wise pitch detection using wavepitch
[frames, timeInSec] = Windows(audio, wSize, hop, sr);
f0 = zeros(1,size(frames,2));

for i = 1:length(f0)
   if(i==1)
       f0(i) = wavePitch(frames(:,i),sr);
   else
       f0(i) = wavePitch(frames(:,i),sr,f0(i-1));
   end
end

wavelet_results = f0;

end