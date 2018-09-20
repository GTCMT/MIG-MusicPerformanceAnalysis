%% Scan audio into segments
% CL@GTCMT 2015
% [audio_segments, Fs] = scanAudioIntoSegments(file_name, segments)
% Read the audio file, and crop it into specified segments.
% file_name = string, the path to the audio file.
% segments = N*1 cell vector, each cell is a m*2 matrix,
%            1st column = starting time, 2nd column = duration (both in 
%            seconds).
% audio_segments = N*1 cell vector, each cell is a M*1 audio signal,
%                  N -> segment.
function [audio_segments, Fs] = scanAudioIntoSegments(file_name, segments)
  [audio, Fs] = audioread(file_name);
  num_segments = size(segments, 1);
  audio_segments = cell(num_segments,1);
  for (segment_idx = 1:num_segments)
    % Convert seconds to samples.
    segment_start = round(segments(segment_idx, 1) * Fs);
    segment_duration = round(segments(segment_idx,  2) * Fs);
    segment_stop = segment_start + segment_duration;
    audio_segments{segment_idx} = audio(segment_start:segment_stop, :);
  end

end

