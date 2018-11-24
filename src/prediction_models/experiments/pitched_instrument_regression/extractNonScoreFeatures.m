function [features] = extractNonScoreFeatures(audio, f0, Fs, hop, NUM_FEATURES)

% assign memory for outout
features=zeros(1,NUM_FEATURES);

% declare hyper parameters
thresh1=0.1;
thresh2=0.4;

% perform note segmentation
note = noteSegmentation(audio, f0, Fs, hop, 50, 0.1 , -50, false);

% feature over entire segment
features(1,1) = PlayingNotes100CntsHist(f0);

% assign memory
stdDev = zeros(1, size(note,1));
countGreaterStdDev = zeros(1,size(note,1));
amp_hist_feature = zeros(1, size(note,1));
ampenv_peaks = zeros(1, size(note,1));
% feature over each individual note and then its derived statistical features
for i=1:size(note,1)
    a = note(i).pitches_hz;
    b = note(i).audio;
    [stdDev(i), countGreaterStdDev(i)]=NoteSteadinessMeasure(a);
    %timbreMeasure(:,i) =timbreDev(note(i).audio,Fs);
    amp_hist_feature(i) = ampHist(b,Fs);
    ampenv_peaks(i) = ampEnvPeaks(b, Fs);
end

features(1,2)=mean(stdDev);
features(1,3)=std(stdDev);
features(1,4)=max(stdDev);
features(1,5)=min(stdDev);  %min is always 0
%features(1,6)=max(stdDev)-min(stdDev);

features(1,6)=mean(countGreaterStdDev);
features(1,7)=std(countGreaterStdDev);
features(1,8)=max(countGreaterStdDev);
features(1,9)=min(countGreaterStdDev);   %min is always 0
% features(1,11)=max(countGreaterStdDev)-min(countGreaterStdDev);

features(1,10)=mean(amp_hist_feature);
features(1,11)=std(amp_hist_feature);
features(1,12)=max(amp_hist_feature);
features(1,13)=min(amp_hist_feature);
%features(1,17)=max(amp_hist_feature)-min(amp_hist_feature);

features(1,14)=mean(ampenv_peaks);
features(1,15)=std(ampenv_peaks);
features(1,16)=max(ampenv_peaks);
features(1,17)=min(ampenv_peaks);
%features(1,22)=max(ampenv_peaks)-min(ampenv_peaks);

features(1,18) = numGoodNotes(note,thresh1,thresh2);

% feature over each individual note and then its derived statistical features
note_timing = zeros(1, size(note,1));
for i=1:size(note,1)
    note_timing(i) = note(i).start/Fs;
end

% extract IOI histogram features
features(1, 19:24) = extractIoiFeatures(note_timing)';

end