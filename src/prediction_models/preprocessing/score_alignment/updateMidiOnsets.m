function midi_mat_new = updateMidiOnsets(midi_mat_aligned, midi_mat_gt, onsetTime, tolerance)

% function midi_mat_new = updateMidiOnsets(midi_mat, onsetTime, fs, hopSize, tolerance)
% Input Arguments: 
% midi_mat: N x 7 matrix, after updating the time stamps using DTW
% onsetTime: M x 1 array, containing Onset time in seconds
% fs: Sampling frequency in Hertz
% hopSize: hop used in onset detection, should be same as one used for
%          align_score as well
% tolerance: Time in milliseconds of how far the actual onsets can be from
%            the midi note onsets. 100 milliseconds by default.


if (nargin < 3)
    tolerance = 100;        % tolerance is 100ms by default
end

N = length(midi_mat_aligned);
M = length(onsetTime);
tol_ms = tolerance*power(10,-3);    % tolerace in milliseconds
midi_mat_new = midi_mat_aligned;


% If more than 1 note have same onset (Caused by dtw alignment),
% Spread them equally before correcting the onsets to nearest actual onsets
% Needs to incorporate ground truth for correct spacing of notes.
% Equal spacing might be over-simplification

% k = 2;
% while(k<=N-1)
%     prevOnset = midi_mat_aligned(k-1,6);
%     midiOnset = midi_mat_aligned(k,6);
%     nextOnset = midi_mat_aligned(k+1,6);
%     if (abs(prevOnset-midiOnset)) < 0.02 && ...
%             (abs(midiOnset-nextOnset)) > tol_ms
%         midiOnset =  (prevOnset+nextOnset)/2;
%         midi_mat_new(k,6) = midiOnset;
%     end
%     k = k+1;
% end

%Incorporated ground truth intervals for spacing out repeated notes
note_repeats = diff(midi_mat_new(:,4));
num_repeats = 0;
for i = 1:N-1
    if note_repeats(i) == 0
        num_repeats = num_repeats + 1;
        continue;
    else
        if num_repeats == 0
            continue;
        else
            midi_mat_new = fix_repeats(midi_mat_new, midi_mat_gt, i, num_repeats);
            num_repeats = 0;
        end
    end
end

%Check if last note is a repeat
if num_repeats ~=0
    midi_mat_new = fix_repeats(midi_mat_new, midi_mat_gt, i+1, num_repeats);
end

% Correct onsets by updating onsets with nearest actual onsets given
% by the onset detection algorithm.
k = 1;
for i=1:N-1
    midiOnset = midi_mat_aligned(i,6);
    while(k<M)
        if ((abs(onsetTime(k)-midiOnset)) < tol_ms && ... % actual onset within tolerance
                onsetTime(k)<midi_mat_aligned(i+1,6) && onsetTime(k) < midiOnset)             % and within next onset
            midi_mat_new(i,6) = onsetTime(k);            
%         else
%             if (onsetTime(k) > midiOnset)                 % Verify only till current midiOnset
%                 break;
%             end
        end
        k = k+1;
    end
end
 
end

function midi_mat_aligned = fix_repeats(midi_mat_aligned, midi_mat_gt, note_pos, num_repeats)
    first_onset = midi_mat_aligned(note_pos-num_repeats, 6);
    last_offset = midi_mat_aligned(note_pos, 6);
    total_duration_beats = sum(midi_mat_gt(note_pos-num_repeats:note_pos, 2));
    for j = 1:num_repeats
        midi_mat_aligned(note_pos-num_repeats+j, 6) = ...
            first_onset + (last_offset-first_onset)*sum(midi_mat_gt(note_pos-num_repeats:note_pos-num_repeats+j-1,2))/total_duration_beats;
    end
end