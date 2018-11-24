%% Feature vector creation
% AV@GTCMT and AP@GTCMT, 2015
% [features] = extractFeatures(audio, Fs, wSize, hop)
% objective: Create a feature vector of all the features called inside this
% function
%
% INPUTS
% audio: samples
% Fs: sampling frequency
% wSize: window size in samples
% hop: hop in samples
%
% OUTPUTS
% features: 1 x N feature vector (where N is the number of features getting extracted in the function)
%> 13 MFCCs
%>  'SpectralCentroid',
%>  'SpectralCrestFactor',
%>  'SpectralDecrease',
%>  'SpectralFlatness',
%>  'SpectralFlux',
%>  'SpectralKurtosis',
%>  'SpectralMfccs',
%>  'SpectralPitchChroma',
%>  'SpectralRolloff',
%>  'SpectralSkewness',
%>  'SpectralSlope',
%>  'SpectralSpread',
%>  'SpectralTonalPowerRatio',
%>  'TimeAcfCoeff',
%>  'TimeMaxAcf',
%>  'TimePeakEnvelope',
%>  'TimePredictivityRatio',
%>  'TimeRms',
%>  'TimeStd',
%>  'TimeZeroCrossingRate',
function [features] = extractStandardFeatures(audio, f0, Fs, wSize, hop)

FeatureNames = {
    'SpectralCentroid',
    'SpectralRolloff',
    'SpectralFlux',
    'TimeZeroCrossingRate',
    'SpectralMfccs'
};

note = noteSegmentation(audio, f0, Fs, hop, 50, 0.2 , -50, 'false');

% features are extracted at each note level
vmfcc_mn = zeros(size(note, 1), 13);
vmfcc_std = zeros(size(note, 1), 13);
tmp_v = zeros(size(note, 1), length(FeatureNames)-1);
tmp_s = zeros(size(note, 1), length(FeatureNames)-1);
for i=1:size(note,1)
    % ComputeFeature contains Prof. Lerch's code from Audio Content Analysis
    for j=1:length(FeatureNames)
        if j~=5
            [tmp_v(i,j),tmp_s(i,j), ~] = ComputeFeature (FeatureNames{j}, note(i).audio, Fs, [], wSize, hop);
        else
            [tmp_mfcc_mn, tmp_mfcc_std, ~] = ComputeFeature (FeatureNames{j}, note(i).audio, Fs, hann(wSize,'periodic'), wSize, hop);
            vmfcc_mn(i,:) = tmp_mfcc_mn;
            vmfcc_std(i,:) = tmp_mfcc_std;
        end
    end
end
tmp_features = [tmp_v, tmp_s, vmfcc_mn, vmfcc_std];
features = [mean(tmp_features, 1), std(tmp_features, 1)];

end