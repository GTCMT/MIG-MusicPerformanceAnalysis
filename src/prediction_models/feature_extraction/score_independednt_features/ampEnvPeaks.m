%% Change in Amplitude Envelope
% AP@GTCMT, 2015
% ampenv_peaks = ampEnvPeaks(audio_segment,fs)
% objective: Find sudden changes in amplitude of a note segment over time
%
% INPUTS
% audio_segment: nx1 float array, returned by a pitch based note segmentor
% fs: sampling rate
%
% OUTPUTS
% ampenv_peaks: no. of sharp amplitude chages within the note segment

function ampenv_peaks = ampEnvPeaks(audio_segment, fs)

% initializations
wSize = 1024; 
hop = 256;
frames = Windows(audio_segment,wSize,hop,fs);
N = size(frames,2);

% calculation of frame energy
spec_energy  = max(abs((frames)));

%calculation of delta energy
spec_energy_shifted = circshift(spec_energy,1,2);
del_energy = zeros(1,length(spec_energy)-1);
del_energy(1:end) = spec_energy(2:end) - spec_energy_shifted(2:end);
del_energy = smooth(del_energy);
[~, locs] = findpeaks(del_energy);
% plot(del_energy);
ampenv_peaks = length(locs)/N;

end