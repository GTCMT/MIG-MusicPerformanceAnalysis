%% Feature vector creation
% AV@GTCMT and AP@GTCMT, 2015
% objective: Create a feature vector of all the Inter-onset-interval features called inside this
% function (This is just wraper code for pitched instruments to call Chihwei's IOI feature extraction code)
%
% INPUTS
% audio: samples
% Fs: sampling frequency
% wSize: window size in samples
% hop: hop in samples
%
% OUTPUTS
% features: 1 x N feature vector (where N is the number of features getting extracted in the function)

function [features] = extractIOIFeaturesCW(audio, Fs, wSize, hop)

    features=zeros(1,7);
    algo='acf';
%     algo='wav';
    
    [f0, ~] = estimatePitch(audio, Fs, hop, wSize, algo);
    note = noteSegmentation(audio, f0, Fs, hop, 50, 0.2 , -50);
    
    % feature over each individual note and then its derived statistical features
    for i=1:size(note,1)
        noteTiming(i) = note(i).start/Fs;
    end
    
%     Chihwei's function to extract IOI features
    [features] = extractIoiFeatures(noteTiming)';
    
      
end