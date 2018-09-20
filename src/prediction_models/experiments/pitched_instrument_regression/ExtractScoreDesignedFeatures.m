close all;
clear all;
clc

% AV@GTCMT
% Objective: extract non score based designed features for segment specified in the for loop for the
% Band option and instrument specified in the variables BAND_OPTION and
% INSTRUMENT_OPTION respectively.
% The getFeatureForSegment function stores the extracted features and their
% labels in the folder 'data' in a mat file named as 'BandOption InstrumentOption SegmentNumber'

BAND_OPTION = 'middle';
INSTRUMENT_OPTION = 'Alto Saxophone';
year_option = '2013';
NUM_FEATURES = 22;

for segment = 2 % segment for which features are to be extracted
% %     uncomment the line below for extracting standard spectral features for the audio files
%     getStdFeaturesForSegment(BAND_OPTION, INSTRUMENT_OPTION, segment, year_option);
% % the line below is for extracting non score based designed features
    getScoredFeatureForSegment(BAND_OPTION, INSTRUMENT_OPTION, segment, year_option, NUM_FEATURES);
end