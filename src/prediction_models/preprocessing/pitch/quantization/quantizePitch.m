%% Quantize Pitch
% CL@GTCMT, 2015
% [pitches_quantized, min_offset] = quantizePitch(pitches_hz)
% objective: Given pitch estimates, quantize them to equal-tempered 
%            semitones. 
% algorithm: The best offset from 440 tuning is selected by doing 
%            quantization at different offsets and using the offset that 
%            gave the minimum root-mean-square error.
%
% pitches_hz: Nx1 float array, the frequencies to quantize.
% pitches_quantized: Nx1 int array of quantized pitches.
% min_offset: The offset from A440 that resulted in the minimum
%             quantization error and therefore used to quantize the 
%             pitches.

function [pitches_quantized, min_offset] = quantizePitch(pitches_hz)
SEARCH_RANGE_CENTS = 50;
OFFSET_VAL_CENTS = 2;
pitches_quantized = [];
min_error = 10000; % Arbitrarily large.
min_offset = -1;

% Search for best offset.
cur_offset = -1 * SEARCH_RANGE_CENTS;
while(cur_offset <= SEARCH_RANGE_CENTS);
  [cur_pitches, error] = frequencyToMidi(pitches_hz, cur_offset);
  if(error < min_error)
    min_error = error;
    min_offset = cur_offset;
    pitches_quantized = cur_pitches;
  end
  
  cur_offset = cur_offset + OFFSET_VAL_CENTS;
end

end

