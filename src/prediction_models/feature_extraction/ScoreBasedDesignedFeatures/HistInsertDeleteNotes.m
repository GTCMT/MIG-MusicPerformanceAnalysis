%% Number of insertions and deletions of notes that student has played compared to the score
% AV@GTCMT
% [insNote, delNote, HistVec] = HistInsertDeleteNotes(f0, aligndMid, scoreMid)
% objective: Find the number of notes inserted or deleted by the student
% while playing the score
%
% Steps
% -> Discretize the median pitch value of each note of the student between
% the boundaries given by the DTW note alignment 
% -> plot histogram in cents (0-11 values in cents)
% -> compare with score histogram (find the best alignment between the histograms to counter the tuning problem)
% -> count the number of insertions, count the number of deleted notes by
% comparing the score and the student's histogram
% assumption: equitempered scale
% 
% INPUTS
% f0: pitch values in Hz of the student playing
% fs: fs of the audio file from which f0 was extracted
% hop: hop with which f0 was calculated
% aligndMid: DTW aligned midi matrix (after doing readmidi) of the student playing with the score
% scoreMid: midi matrix (after doing readmidi) of  the score
%
% OUTPUTS
% insNote: number of insertions of notes by the student compared to the score
% delNote: number of deletion of notes by the student compared to the score
% HistVec: vector with features like skewness, kurtosis etc on the
% histogram subraction of reference score and student's notes

function [insNote, delNote, HistVec] = HistInsertDeleteNotes(f0, fs, hop, aligndMid, scoreMid)

timeStep = hop/fs;
[rwSdnt,colSdnt] = size(aligndMid);
[rwSc,colSc] = size(scoreMid);
mean_pitch_hz = zeros(rwSdnt,1);
meanPitchInCents_student = zeros(rwSdnt,1);
meanPitchInCents_score = zeros(rwSc,1);

edgesHist = -0.5:1:11.5;

for i=1:rwSdnt
    strtTime = round(aligndMid(i,6)/timeStep);
    endTime = round(aligndMid(i,6)/timeStep + aligndMid(i,7)/timeStep + 1);
    mean_pitch_hz(i,1)=median(f0(strtTime:endTime));
    meanPitchInCents_student(i,1) = mod(abs(round(12*log2(mean_pitch_hz(i)/440))),12);
end

for i = 1:rwSc
    meanPitchInCents_score(i,1) = mod(abs(scoreMid(i,4)-69),12);
end

[Nstudent]=histcounts(meanPitchInCents_student,edgesHist);
[HistScore]=histcounts(meanPitchInCents_score,edgesHist);

% HistSubtr = Nscore - Nstudent;
% insNote = abs(sum(HistSubtr(HistSubtr<0)));
% delNote = abs(sum(HistSubtr(HistSubtr>0)));

minIns = Inf; minDel = Inf; amtShift = 0;
for i = 0:length(Nstudent)-1
    ShiftHistStudent = circshift(Nstudent,i,2);
    HistSubtrTemp = HistScore - ShiftHistStudent;
    insTemp = abs(sum(HistSubtrTemp(HistSubtrTemp<0)));
    delTemp = abs(sum(HistSubtrTemp(HistSubtrTemp>0)));
    if ((insTemp+delTemp)<(minIns+minDel))
        minIns = insTemp;
        minDel = delTemp;
        amtShift = i;
    end
end

ShiftHistStudent = circshift(Nstudent,amtShift,2);
insNote = minIns;
delNote = minDel;

% plot for debugging purposes
% ShiftNstudent = circshift(Nstudent,amtShift,2);
% newBins = edgesHist(1:end-1)+0.5; figure; bar(newBins,HistScore); hold on; bar(newBins,ShiftNstudent,'r');

HistSubtr = abs(HistScore - ShiftHistStudent);

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



