%% Feature vector creation
% AV@GTCMT and AP@GTCMT, 2015
% [features] = extractFeatures(audio, Fs, wSize, hop)
% objective: Create a feature vector of all the non score based features called inside this
% function
%
% INPUTS
% audio: samples
% Fs: sampling frequency
% wSize: window size in samples
% hop: hop in samples
%
% OUTPUTS
% features: 1 x N feature vector (where N is the number of features getting extracted in the function)

function [features] = extractFeatures(audio, Fs, wSize, hop)

    features=zeros(1,24);
    algo='acf';
%     algo='wav';
    thresh1=0.1;
    thresh2=0.4;
    
    [f0, ~] = estimatePitch(audio, Fs, hop, wSize, algo);
    note = noteSegmentation(audio, f0, Fs, hop, 50, 0.2 , -50);

    % feature over entire segment
    features(1,1) = PlayingNotes100CntsHist(f0);
    
    % feature over each individual note and then its derived statistical features
    for i=1:size(note,1)
        a = note(i).pitches_hz;
        b = note(i).audio;
        [stdDev(i) countGreaterStdDev(i)]=NoteSteadinessMeasure(a);
        
        timbreMeasure(:,i) =timbreDev(note(i).audio,Fs);

        amp_hist_feature(i) = ampHist(b,Fs);

        ampenv_peaks(i) = ampEnvPeaks(b, Fs);
        
    end
    
    features(1,2)=mean(stdDev);
    features(1,3)=std(stdDev);
    features(1,4)=max(stdDev);
     features(1,5)=min(stdDev);  %min is always 0
%      features(1,6)=max(stdDev)-min(stdDev);
    
    features(1,6)=mean(countGreaterStdDev);
    features(1,7)=std(countGreaterStdDev);
    features(1,8)=max(countGreaterStdDev);
     features(1,9)=min(countGreaterStdDev);   %min is always 0
%      features(1,11)=max(countGreaterStdDev)-min(countGreaterStdDev);
    
%     features(1,10)=mean(timbreMeasure(2,:)); % take 2nd MFCC
%     features(1,11)=std(timbreMeasure(2,:));
%     features(1,12)=max(timbreMeasure(2,:));
%     features(1,13)=min(timbreMeasure(2,:));
%     features(1,12)=max(timbreMeasure(2,:))-min(timbreMeasure(2,:));
    
    features(1,10)=mean(amp_hist_feature);
    features(1,11)=std(amp_hist_feature);
    features(1,12)=max(amp_hist_feature);
    features(1,13)=min(amp_hist_feature);
%     features(1,17)=max(amp_hist_feature)-min(amp_hist_feature);
    
    features(1,14)=mean(ampenv_peaks);
    features(1,15)=std(ampenv_peaks);
    features(1,16)=max(ampenv_peaks);
    features(1,17)=min(ampenv_peaks);
%     features(1,22)=max(ampenv_peaks)-min(ampenv_peaks);
    
    features(1,18) = numGoodNotes(note,thresh1,thresh2);
    features(1,19:24) = extractIOIFeaturesCW(audio, Fs, wSize, hop);
%     features(1,23)=IOIfeatures(note);
      
end