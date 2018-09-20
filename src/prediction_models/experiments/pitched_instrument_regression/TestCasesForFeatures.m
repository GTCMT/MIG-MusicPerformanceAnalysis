clear all;
close all;
clc;

% AV@GTCMT
% Objective: Generate test signals and check the feature values are as
% expected. Code similar to TestFeatures.m

addpath(pathdef);

% FileNumber='28610';
% data path on machine
% pathchk=['M:\My Documents\FBA2013data\middleschoolscores\' FileNumber '\'];
% pathchk=['/Users/Amruta/Documents/MS GTCMT/GRA work/FBA2013data/concertbandscores/' FileNumber '/'];
% [audio,Fs]=audioread([pathchk FileNumber '.mp3']);

Fs=44100; % 44.1 kHz
f=100;  % 100 Hz
t=0:(1/Fs):10;
t2= 10:(1/Fs):20;
t3= 20:(1/Fs):30;
t4= 30:(1/Fs):40;
t5= 40:(1/Fs):50;
t6= 50:(1/Fs):100;
t7= 100:(1/Fs):110;

audio = sin(2*pi*t*f)';
audio=[audio;sin(2*pi*t2*200)';sin(2*pi*t3*300)';sin(2*pi*t4*400)';sin(2*pi*t5*500)';sin(2*pi*t6*600)';sin(2*pi*t7*700)'];
plot(audio);

for seg =1
% segments = scanSegments(seg, str2num(FileNumber));

    hop=512; wSize=1024; algo='acf';  thresh1=0.1; thresh2=0.4;

%     strtsmpl=round(segments{1,1}(1)*Fs);
%     endsmpl=round(strtsmpl+segments{1,1}(2)*Fs);

    strtsmpl=1;
    endsmpl=length(audio);
    
%     audio=mean(audio,2);

    [f0, timeInSec] = estimatePitch(audio(strtsmpl:endsmpl), Fs, hop, wSize, algo);
    note = noteSegmentation(audio(strtsmpl:endsmpl), f0, Fs, hop, 50, 0.2 , -50);

    features(1,1) = PlayingNotes100CntsHist(f0);
    
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
    
    features(1,5)=mean(countGreaterStdDev);
    features(1,6)=std(countGreaterStdDev);
    features(1,7)=max(countGreaterStdDev);
    
    features(1,8)=mean(timbreMeasure(2,:)); % take 2nd MFCC
    features(1,9)=std(timbreMeasure(2,:));
    features(1,10)=max(timbreMeasure(2,:));
    features(1,11)=min(timbreMeasure(2,:));
    features(1,12)=max(timbreMeasure(2,:))-min(timbreMeasure(2,:));
    
    features(1,13)=mean(amp_hist_feature);
    features(1,14)=std(amp_hist_feature);
    features(1,15)=max(amp_hist_feature);
    features(1,16)=min(amp_hist_feature);
    features(1,17)=max(amp_hist_feature)-min(amp_hist_feature);
    
    features(1,18)=mean(ampenv_peaks);
    features(1,19)=std(ampenv_peaks);
    features(1,20)=max(ampenv_peaks);
    features(1,21)=min(ampenv_peaks);
    features(1,22)=max(ampenv_peaks)-min(ampenv_peaks);
    
    features(1,23) = numGoodNotes(note,thresh1,thresh2);
    
    features(1,24)=IOIfeatures(note);
end