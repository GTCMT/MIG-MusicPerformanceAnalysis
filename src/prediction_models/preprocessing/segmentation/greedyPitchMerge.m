%% Greedy Pitch Merge
% CL@GTCMT 2015
% new_notes = greedyPitchMerge(notes, interval_thresh_cents)
% objective: Remove suprious notes on note boundaries.
% algorithm: Merge adjacent notes where difference in average pitch is 
%            above |interval_thresh_cents|, in order of lowest difference.
% notes: Nx1 struct array of notes, ordered by occurence in time.
% interval_thresh_cents: merge adjacent notes closer in frequency than this
%                        given interval.
% new_notes: Nx1 struct array of thinned notes.
%
% See noteSegmentation header comment for description of note struct.

function new_notes = greedyPitchMerge(notes, interval_thresh_cents)
num_notes = size(notes, 1);
new_notes = notes;

% First, find the intervals
intervals = zeros(num_notes - 1, 1);  
% Index corresponds to smaller index in the note-pair.
for(note_idx = 1:num_notes - 1)
  left_note = new_notes(note_idx);
  right_note = new_notes(note_idx + 1);
  cur_interval = abs(intervalCents(left_note.mean_pitch_hz, ...
                                           right_note.mean_pitch_hz));
  intervals(note_idx) = cur_interval;
end

% Merge smallest interval first.
[min_interval, min_idx] = min(intervals);
while(min_interval <= interval_thresh_cents)
  left_note = new_notes(min_idx);
  right_note = new_notes(min_idx + 1);
  
  % Merge two notes.
  new_note = mergeNotes(left_note, right_note);
  
  % Update note vector.
  new_notes(min_idx) = new_note;
  new_notes(min_idx + 1) = [];
  num_boundaries = size(intervals, 1);
  
  % Update note differences.
  for(boundary_idx = min_idx-1:min_idx)
    % Bounds check.
    if(boundary_idx >=1 && boundary_idx + 1 <= num_boundaries)
      left_pitch = new_notes(boundary_idx).mean_pitch_hz;
      right_pitch = new_notes(boundary_idx + 1).mean_pitch_hz;
      cur_interval = ...
        abs(intervalCents(left_pitch, right_pitch));
      intervals(boundary_idx) = cur_interval;
    end
  end
  
  if(min_idx < num_boundaries)
    intervals(min_idx + 1) = [];
  elseif(min_idx == num_boundaries)
    intervals(min_idx) = [];
  end
  
  % Find next minimum pitch difference.
  [min_interval, min_idx] = min(intervals);
end

end

