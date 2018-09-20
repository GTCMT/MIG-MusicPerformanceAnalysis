%% Amplitude Histogram of Note Segment
% AP@GTCMT, 2015
% amp_hist_feature = ampHist(audio_segment,fs)
% objective: Find uniformity of amplitude within a note segment
%
% INPUTS
% audio_segment: nx1 audio float array, returned by a pitch based note segmentor
%
% OUTPUTS
% amp_hist_feature: standard deviation of the amplitude of a note segment

function amp_hist_feature = ampHist(audio_segment,fs)

% initializations
wSize = 1024; 
hop = 256;
frames = Windows(audio_segment,wSize,hop,fs);

% calculation of frame energy
frame_energy  = sum(abs(frames));

% computation of amplitude histogram
% nbins = 100;
% amp_hist = hist(frame_energy, nbins);
% amp_hist = smooth(amp_hist);
% % plot(amp_hist);
% amp_hist_feature = kurtosis(amp_hist);

% Normalising kurtosis is hard and std dev was making more sense -- changed
% by AV
amp_hist_feature=std(frame_energy);

end
