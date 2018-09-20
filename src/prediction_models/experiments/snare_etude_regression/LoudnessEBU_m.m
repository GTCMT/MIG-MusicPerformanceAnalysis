%% LoudnessEBU
% objective: calculate LU/LUFS according to EBU standard
% [LUFS, LU] = LoudnessEBU(cFilePathToInputFile)
% input cFilePathToInputFile: path of wav file, only support fs=48kHz, ch=2
% output LUFS: Loudness unit full scale
%        LU: Loudness unit
% CW @ GTCMT

function [LUFS, LU, z_thres2] = LoudnessEBU_m(y, fs)
%wave read
%[y, fs] = audioread(cFilePathToInputFile);

%initialization
LUFS = 0;
LU   = 0;
FS = 48000;
weight = [1, 1];
windowSize = 0.4 * FS;
hopSize    = 0.25* windowSize;
[numSample, numChannel] = size(y);

%check if FS~=48kHz, numChannel~=2 or file doesn't read
if fs ~= FS
    fprintf('WARNING! LoudnessEBU only supports fs = 48000, it will be upsampled');
    temp = resample(y, FS, fs);
    y = temp;
elseif numChannel > 2
    error('WARNING! LoudnessEBU only supports channel <= 2');
end

%pre-filtering
[~,out] = PreFilter(y,fs);
[numSample, numChannel] = size(y);
y = out;

numFrame = floor((numSample - windowSize)/hopSize + 1);
z = zeros(numChannel, numFrame);

%mean square of every channel
for i = 1:numChannel
    y_current = y(:, i);
    y_blocks  = x2mat(y_current, windowSize, hopSize);
    z(i, :)   = mean( y_blocks.^2, 1);
end

% %weighted sum (weight = 1...)
[z_block] = BlockWeightedSum(z, weight);

lj = -0.691 + 10*log10(z_block);

%absolute gating
jg = z_block( lj > -70);
gatedLoudness1 = -0.691 + 10*log10( mean(jg));

%relative gating
z_thres2 = z_block( lj > gatedLoudness1 - 10);
gatedLoudness2 = -0.691 + 10*log10( mean(z_thres2));

%output
LUFS = gatedLoudness2;
LU = LUFS - (-23);

