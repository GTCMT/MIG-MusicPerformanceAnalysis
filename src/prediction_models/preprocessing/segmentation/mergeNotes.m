%% Merge Notes
% CL@GTCMT 2015
% merged_note = mergeNotes(left_note, right_note)
% objective: Merge two adjacent notes into one. Helper function used in 
%            noteSegmentation.
% 
% left_note: note struct, occurs earlier in time.
% right_note: note struct, occurs later in time.
% merged_note: note struct, the result of merging the left and right notes.
%
% See noteSegmentation header comment for description of note struct.

function merged_note = mergeNotes(left_note, right_note)

merged_note = struct();

merged_note.audio = [left_note.audio; right_note.audio];
merged_note.start = left_note.start;
merged_note.stop = right_note.stop;
merged_note.duration = merged_note.stop - merged_note.start;
merged_note.pitches_hz = [left_note.pitches_hz right_note.pitches_hz];
merged_note.mean_pitch_hz = ...
    (left_note.duration * left_note.mean_pitch_hz + ...
     right_note.duration * right_note.mean_pitch_hz) / ...
    (left_note.duration + right_note.duration);

end

