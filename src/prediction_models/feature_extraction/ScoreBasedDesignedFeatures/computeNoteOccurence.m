function [note_indices] = computeNoteOccurence(midi_mat_score)
% function [note1_index, note2_index] = computeNoteOccurence(midi_mat_score)
% Computes the first and second most occuring duration
% in the score and returns their indices.
% Arg: midi_mat_score (readmidi('midi_file'))
% Output: Indices of first and highest occuring notes

dur_list = midi_mat_score(:,7);
[n,x] = hist(dur_list);
d = diff(x)/2;
edges = [0, x(1:end-1)+d, x(end)+d(end)];
[~,ind] = sort(n,'descend');
note1 = ind(1);
t1 = edges(note1);
t2 = edges(note1+1);


note_indices = find(dur_list >= t1 & dur_list <= t2);
%note_indices = {note1_indices; note2_indices};

end