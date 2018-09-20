%% Features on the duration histogram of the student in comparison with the score 
% AV@GTCMT
% HistVec = TempoHistFeat(aligndMid, scoreMid)
% objective: Compare the duration histogram of the student and the score.
% More similar the histograms, better it is.
% 
% INPUTS
% aligndMid: DTW aligned midi matrix (after doing readmidi) of the student playing with the score
% scoreMid: midi matrix (after doing readmidi) of  the score
%
% OUTPUTS
% HistVec: vector with features like skewness, kurtosis etc on the
% histogram subraction of reference score's duration and student's duration
% of played notes

function HistVec = TempoHistFeat(aligndMid, scoreMid)

studentDur = aligndMid(:,7) / sum(aligndMid(:,7));  %normalize the durations to compare with the score durations
scoreDur = scoreMid(:,7) / sum(scoreMid(:,7));     %normalize the durations
edgesHist = -0.25:0.25:10.25;
% dummy fs, since the statistical functions need it (internally fs is not being used)
fs = 8000;

HistStudent = histcounts(studentDur, edgesHist);
HistScore = histcounts(scoreDur, edgesHist);

HistSubtr = abs(HistScore - HistStudent);
% plot for debugging purposes
% newBins = edgesHist(1:end-1)+0.25; figure; bar(newBins,HistScore); figure; bar(newBins,HistScore); hold on; bar(newBins,HistStudent,'r');

TotVal = sum(HistSubtr);
if TotVal ~= 0
    NormHistSubtr = HistSubtr ./ TotVal;
else
    NormHistSubtr = HistSubtr;
end

HistpeakCrest = IOIPeakCrest(NormHistSubtr, edgesHist(1:end-1)+0.5);
Histskew = FeatureSpectralSkewness(NormHistSubtr', fs);
Histkurto = FeatureSpectralKurtosis(NormHistSubtr', fs);
Histrolloff = FeatureSpectralRolloff(NormHistSubtr', fs, 0.85);
Histflatness = FeatureSpectralFlatness(NormHistSubtr', fs);
HisttonalPower = FeatureSpectralTonalPowerRatio(NormHistSubtr', fs);

HistVec = [HistpeakCrest; Histskew; Histkurto; Histrolloff; ...
        Histflatness; HisttonalPower];

end