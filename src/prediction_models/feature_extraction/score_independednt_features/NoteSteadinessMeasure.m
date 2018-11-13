%% Deviation in the pitch values of the input note
% AV@GTCMT, 2015
% [NoteDeviation]=NoteSteadinessMeasure(pitchvals)
% objective: Find the fluctuation in the input note pitch values
%
% INPUTS
% pitchvals: pitch values in Hz of the segmented note
%
% OUTPUTS
% NoteDeviation: single float values showing standard deviation in terms of MIDI notes across the input note
% NormCountGreaterStdDev: number of points in the note deviation that are beyond the 1 * std dev of the note

function [NoteDeviation, NormCountGreaterStdDev]=NoteSteadinessMeasure(pitchvals)

pitchvalsMidi=69+12*log2(pitchvals/440);
NoteDeviation=std(pitchvalsMidi);

% count the number of deviations more than 1 std dev
NormCountGreaterStdDev=sum(abs(pitchvalsMidi-mean(pitchvalsMidi))>NoteDeviation)/length(pitchvalsMidi);


end