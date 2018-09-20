%% Frequency to Midi
% CL@GTCMT, 2015
% [midi_pitches, rms_error] = frequencyToMidi(pitches_hz, cent_offset)
% objective: Convert frequency to midi note-number. A440 is the reference
%            frequency.
%
% pitches_hz: Nx1 float array, the frequencies to convert to midi pitch.
% cent_offset: The offset from A440 when quantizing, in cents.
% midi_pitches: Nx1 int array of midi pitches.
% rms_error: The root-mean-square quantization error.

function [midi_pitches, rms_error] = frequencyToMidi(pitches_hz, ...
                                                     cent_offset)
  % Reference from A440, which has the MIDI pitch number 69.
  ref_freq = 440;
  ref_midi = 69;
  
  ref_freq = ref_freq * pow2(cent_offset / 1200);
  pitches_hz(pitches_hz == 0) = 0.01;
  midi_pitch_fraction = ref_midi + 12 * log2(pitches_hz / ref_freq);
  midi_pitches = round(midi_pitch_fraction);
  
  error = midi_pitches - midi_pitch_fraction;
  rms_error = sqrt(sum(error .* error));
end
