% AV@GTCMT
% Code to inspect the feature values for a single audio file

clear all;
close all;
clc;

% student id number 
FileNumber='28610';
% data path on machine
pathchk=['M:\My Documents\FBA2013data\middleschoolscores\' FileNumber '\'];
[audio,Fs]=audioread([pathchk FileNumber '.mp3']);

for seg =1:5
    segments = scanSegments(seg, str2num(FileNumber));

    hop=512; wSize=1024; algo='wav'; thresh1=0.1; thresh2=0.4;

    strtsmpl=round(segments{1,1}(1)*Fs);
    endsmpl=round(strtsmpl+segments{1,1}(2)*Fs);

    audio=mean(audio,2);

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