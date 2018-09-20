%% Amplitude Deviation Measure of Note Segment
% AP@GTCMT, 2015
% amp_dev_feature = ampHist(audio_segment,fs)
% objective: Find deviation in amplitude within a note segment
%
% INPUTS
% audio_segment: nx1 audio float array, returned by a pitch based note segmentor
%
% OUTPUTS
% amp_dev_feature: no. of frames for which signal amplitude exceeds more
% than 1 std from the mean ampltiude for the note

function amp_dev_feature = ampDev(audio_segment,fs)

% initializations
wSize = 1024; 
hop = 512;
frames = Windows(audio_segment,wSize,hop,fs);
N = size(frames,2);

% calculation of frame energy mean and std
frame_energy  = sum(abs(fft(frames)));
frame_energy_mean = mean(frame_energy);
frame_energy_std = std(frame_energy);

% finding num. of frames which exceed the ampltiude by 1 std
frame_deviation = frame_energy - frame_energy_mean;
frame_deviation(frame_deviation <= frame_energy_std) = 0;
frame_deviation(frame_deviation > frame_energy_std) = 1;
num_frames = sum(frame_deviation);

amp_dev_feature = num_frames/N;

end
