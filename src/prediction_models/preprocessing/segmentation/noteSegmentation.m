%% Note Segmentation
% CL@GTCMT 2015
% notes = noteSegmentation(audio, pitches_hz, Fs, hop_size, 
%                          interval_thresh_cents, min_note_secs,
%                          power_thresh_db)
% objective: Segment audio into notes using only pitch information. Pitches
%            are smoothed with a median filter, quantized, and boundaries 
%            are detected at changes in quantized values. Then, adjacent 
%            notes whose average pitches (unquantized) are within a certain
%            interval are merged together, starting with the note-pair 
%            closest in pitch.
%
% audio: Nx1 float array, Audio signal to segment.
% Fs: int, Sample rate.
% pitches_hz: 1xM float array, frequency estimates.
% hop_size: int, duration between pitch estimates, in samples.
% interval_thresh_cents: float, adjacent notes closer in pitch than this
%                        interval are merged. 
% min_note_secs: float, notes with shorter duration than this threshold are
%                merged with an adjacent note.
% power_thresh_db: float, notes with an amplitude below this threshold are
%                  removed from the list. In decibels. 
% notes: Nx1 struct array of notes, the segmented notes.
%   note.audio: Nx1 float array, the audio signal for the note. Useful for
%               debugging.
%   note.start: int, the index into the original audio signal where the 
%               note starts. Duration unit is windows.
%   note.stop: int, the index into the original audio signal where the note
%              ends. Duration unit is windows.
%   note.duration: int, the length of the note, in windows.
%   note.pitches_hz: float, the pitch estimates for the note, in hertz.
%   note.mean_pitch_hz: float, the mean pitch for the note, in hertz.

function notes = noteSegmentation(audio, pitches_hz, Fs, hop_size, ...
                                  interval_thresh_cents, min_note_secs, ...
                                  power_thresh_db, thinning)
% Number of necessary sequential pitch estimates for a note to be valid.
min_note_windows = floor(min_note_secs * Fs / hop_size);
num_windows = size(pitches_hz, 2);

% Smooth pitches.
pitches_hz_smooth = medfilt1(pitches_hz, 5);

% Quantize to semitone.
quantized_pitches = quantizePitch(pitches_hz_smooth);

% Find note boundaries.
boundaries = [];
past_pitch = -1;
for(window_idx = 1:num_windows)
  cur_pitch = quantized_pitches(window_idx);
  if(past_pitch ~= cur_pitch)
    boundaries = [boundaries; window_idx];
  end
  past_pitch=cur_pitch;
end
boundaries=[boundaries;num_windows];

% Derive notes from boundaries.
num_notes = size(boundaries, 1) - 1;
notes(num_notes) = struct();
notes = notes.';
for(note_idx = 1:num_notes)
  note_start_idx = boundaries(note_idx);
  note_stop_idx = boundaries(note_idx + 1)-1;
  note_start = ((boundaries(note_idx) - 1) * hop_size) + 1;
  note_stop = ((boundaries(note_idx + 1) - 1) * hop_size) + 1;
  if note_stop > length(audio)
     warning('note segmentation exceeds audio length')
     if (note_idx == num_notes)
        note_stop = length(audio);
     else
        error('Error in note segmentation'); 
     end
  end
  cur_pitches_hz = pitches_hz_smooth(1, note_start_idx:note_stop_idx);

  notes(note_idx).audio = audio(note_start:note_stop);
  notes(note_idx).start = note_start_idx;
  notes(note_idx).stop = note_stop_idx;
  notes(note_idx).duration = note_stop_idx - note_start_idx+1;
  notes(note_idx).pitches_hz = cur_pitches_hz;
  notes(note_idx).mean_pitch_hz = mean(cur_pitches_hz);
end

% Merge adjacent notes which are close in frequency.
notes = greedyPitchMerge(notes, interval_thresh_cents);

% Remove zero pitch valued notes
num_notes = size(notes, 1);
store_notes=notes;
notes=[];
for(note_idx = 1:num_notes)
    if store_notes(note_idx).mean_pitch_hz~=0
        note=store_notes(note_idx);
        notes=[notes;note];
    end
end

% % check for merge criteria in only the contiguous notes
% num_notes = size(notes, 1);
% sub_notes=notes;
% notes=[];
% start_index = 1;
% end_index = 1;
% for note_idx=1:num_notes-1
%     if sub_notes(note_idx).stop+1~=sub_notes(note_idx+1).start
%         end_index = note_idx;
%         dummy = noteThinning(sub_notes(start_index:end_index),min_note_windows);
%         notes = [notes; dummy];
%         start_index = end_index + 1;
%     end
% end
% 
% dummy = noteThinning(sub_notes(start_index:end), min_note_windows);
% notes = [notes; dummy];
% 
% if isempty(notes)==1
%     notes=sub_notes;
% end

% Thin notes: coalesce spurious notes at boundaries.
if thinning == true
    notes = noteThinning(notes, min_note_windows);
end

% Remove notes below a power threshold.
old_notes = notes;
notes = []; % Can't preallocate without knowing how many we plan to store.
num_notes = size(old_notes, 1);
for (note_idx = 1:num_notes)
  note = old_notes(note_idx);
  note_power = mean(abs(note.audio));
  note_power = note_power * note_power;
  note_power_db = 10 * log10(note_power / 1);
  if(note.duration > min_note_windows && note_power_db > power_thresh_db)
    notes = [notes; note];
  end
end

end