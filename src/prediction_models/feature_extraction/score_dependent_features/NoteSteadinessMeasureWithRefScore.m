%% Deviation in the pitch values of the input note from the given midi note
% AV@GTCMT
% [NoteDeviation]=NoteSteadinessMeasureWithRefScore(pitchvals)
% objective: Find the fluctuation in the input note pitch values from the
% given reference midi note
%
% INPUTS
% pitchvals: pitch values in Hz of the segmented note
% midi note: the correct note corresponding to the score
%
% OUTPUTS
% NoteAvgDevFromRef: mean value of notes deviating from the given midi note reference
% NoteAvgStdFromRef: standard deviation of difference between students' playing and expected midi note
% NormCountGreaterStdDev: number of points in the note deviation that are
% beyond the 1 * std dev of the note played in the score

function [NoteAvgDevFromRef,NoteStdDevFromRef,NormCountGreaterStdDev]=NoteSteadinessMeasureWithRefScore(pitchvals, midiNote)

pitchvalsMidi=69+12*log2(pitchvals/440);

% mean value of notes deviating from the given midi note reference
NoteAvgDevFromRef=mean((abs(pitchvalsMidi-midiNote)));
NoteStdDevFromRef=std((abs(pitchvalsMidi-midiNote)));
NormCountGreaterStdDev=sum(abs(pitchvalsMidi-midiNote)>NoteStdDevFromRef)/length(pitchvalsMidi);

end