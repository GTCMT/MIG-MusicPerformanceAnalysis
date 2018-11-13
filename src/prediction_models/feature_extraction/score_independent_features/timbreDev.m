%% Deviation in timbre across the input note
% AV@GTCMT, 2015
% timbreMeasure =timbreDev(AudioFile,fs)
% objective: Find changes in timbre across the given note (uses the MFCC implementation from labrosa)
%
% INPUTS
% AudioFile: audio samples corresponding to output from note segmentation
% fs: sampling frequency of the audio
%
% OUTPUTS
% timbreMeasure: 13x1 float vector corresponding to standard deviation
% across the 13 MFCC coefficients

function timbreMeasure =timbreDev(AudioFile,fs)

% hop=0.05; % hop in s
% frm=0.2; % frm in s
% addpath('./MFCC');
% mfcc features are extracted from labrosa toolbox default value of window
% size is 0.025 sec and hopsize is 0.010sec
coeff=melfcc(AudioFile,fs);%melfcc(AudioFile,fs, 'maxfreq', 8000, 'numcep', 13, 'nbands', 40, 'fbtype', 'fcmel', 'dcttype', 1, 'usecmp', 1, 'wintime',frm, 'hoptime', hop, 'preemph', 0, 'dither', 1);
timbreMeasure=std(coeff,0,2);

end