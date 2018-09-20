%% Number of Good Notes in Performance
% AP@GTCMT, 2015
% numGoodNotesFeat = numGoodNotes(notes)
% objective: Compute of % of good notes in a performance based on deviation
% from average pitch
%
% INPUTS
% notes: Nx1 struct containing the note segments
% thresh1: cutoff on standard deviation value (in terms of MIDI)
% thresh2: acceptable percentage of pitch values that exceed 1* standard deviation 
%
% OUTPUTS
% numGoodNotesFeat: % of good notes in a performance based on deviation
% from average pitch

function numGoodNotesFeat = numGoodNotes(note,thresh1,thresh2)

numBadNotes = 0;
L = size(note,1);
for i=1:L
    a = note(i).pitches_hz;
    [NoteDeviation, countGreaterStdDev]=NoteSteadinessMeasure(a);
    if NoteDeviation > thresh1
        numBadNotes = numBadNotes + (countGreaterStdDev>thresh2);
    end
end

numGoodNotesFeat = 1 - numBadNotes/L;

end
