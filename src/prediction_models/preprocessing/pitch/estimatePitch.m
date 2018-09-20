%% Estimate Pitch
% AP@GTCMT, 2015
% [f0, timeInSec] = estimatePitch(audio, Fs, hopSizeSamples, wSize, algo)
% objective: Estimate pitch (monophonic) from an audio signal.
%
% INPUTS
% audio: Nx1 float array, the mono signal.
% Fs: int, the sample rate.
% hop: The number of samples between each pitch estimation.
% wsize: integration window size
% algo: string specifying the type of algorithm to be used. Can take the
%       following values:-
%       'yin': for the yin algorithm
%       'acf': standard acf algorithm
%       'wav': wavelet based pitch tracker
% 
% OUTPUTS
% f0: 1xM float, pitch estimates, in hertz.
% timeInSec: 1xM float, time stamp for the window

function [f0, timeInSec] = estimatePitch(audio, Fs, hop, wSize, algo)

switch nargin
    case 0
        error('Audio and Fs must be entered as arguments to the function');
    case 1
        error('Fs has to be entered as arguments to the function ');
    case 2
        hop = 512;
        wSize = 1024;
        algo = 'acf';
    case 3
        wSize = 1024;
        algo = 'acf';
    case 4
        algo = 'acf';
end

algoOptions = struct();
algoOptions.sr = Fs;
algoOptions.hop = hop;
algoOptions.wsize = wSize;

if strcmp(algo,'yin') == 1
    [f0, timeInSec] = yinAlgo(audio,algoOptions);
elseif strcmp(algo,'acf') == 1
    [f0, timeInSec] = acf(audio,algoOptions);
elseif strcmp(algo,'wav') == 1
    [f0, timeInSec] = wavelet(audio,algoOptions);
else
    error('Choose algo as "yin", "acf" or "wav" only');
end


end
