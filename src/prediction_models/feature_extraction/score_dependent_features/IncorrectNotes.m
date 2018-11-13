%% Number of notes that student has played incorrectly compared to the score
% AV@GTCMT
% [insNote, delNote, HistVec] = IncorrectNotes(f0, aligndMid, scoreMid)
% objective: Compare (midi note number) what was expected in the score with the median value
% of the pitches in the onset+duration amount of region in the pitch
% contour
% 
% INPUTS
% f0: pitch values in Hz of the student playing
% fs: fs of the audio file from which f0 was extracted
% hop: hop with which f0 was calculated
% aligndMid: DTW aligned midi matrix (after doing readmidi) of the student playing with the score
% scoreMid: midi matrix (after doing readmidi) of  the score
%
% OUTPUTS
% NoIncNotes: number of notes incorrectly played by the student (compared to the notes expected in the score)

function NoIncNotes = IncorrectNotes(f0, fs, hop, aligndMid, scoreMid)

timeStep = hop/fs;
[rwSdnt,colSdnt] = size(aligndMid);
mean_pitch_hz = zeros(rwSdnt,1);
meanPitchInCents_student = zeros(rwSdnt,1);
meanPitchInCents_score = zeros(rwSdnt,1);

for i=1:rwSdnt
    strtTime = round(aligndMid(i,6)/timeStep);
    endTime = round(aligndMid(i,6)/timeStep + aligndMid(i,7)/timeStep + 1);
    mean_pitch_hz(i,1)=median(f0(strtTime:endTime));
    meanPitchInCents_student(i,1) = mod(abs(round(12*log2(mean_pitch_hz(i)/440))),12);
    meanPitchInCents_score(i,1) = mod(abs(scoreMid(i,4)-69),12);
end

NoIncNotes = sum(meanPitchInCents_student~=meanPitchInCents_score);

