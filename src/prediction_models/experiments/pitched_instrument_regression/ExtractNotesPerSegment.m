close all;
clear all;
clc

% AV@GTCMT
% Objective: extract non score based designed features for segment specified in the for loop for the
% Band option and instrument specified in the variables BAND_OPTION and
% INSTRUMENT_OPTION respectively.
% The getFeatureForSegment function stores the extracted features and their
% labels in the folder 'data' in a mat file named as 'BandOption InstrumentOption SegmentNumber'

stats = zeros(2,4);
BAND_OPTION = 'middle';
INSTRUMENT_OPTION = 'Alto Saxophone';
year_option = '2015';
NUM_FEATURES = 24;


thres = 0.1;
thinning = false;
notes = getNotesForSegmentPyin(BAND_OPTION, INSTRUMENT_OPTION, 2, year_option, NUM_FEATURES, thres, thinning);

len = [];
for i = 1:numel(notes)
    len = [len; length(notes{i})];
end
stats(1,1) = mean(len);
stats(2,1) = std(len);

thres = 0.2;
thinning=false;
notes = getNotesForSegmentPyin(BAND_OPTION, INSTRUMENT_OPTION, 2, year_option, NUM_FEATURES, thres, thinning);

len = [];
for i = 1:numel(notes)
    len = [len; length(notes{i})];
end
stats(1,2) = mean(len);
stats(2,2) = std(len);

thres = 0.1;
thinning = true;
notes = getNotesForSegmentPyin(BAND_OPTION, INSTRUMENT_OPTION, 2, year_option, NUM_FEATURES, thres, thinning);

len = [];
for i = 1:numel(notes)
    len = [len; length(notes{i})];
end
stats(1,3) = mean(len);
stats(2,3) = std(len);

thres = 0.2;
thinning=true;
notes = getNotesForSegmentPyin(BAND_OPTION, INSTRUMENT_OPTION, 2, year_option, NUM_FEATURES, thres, thinning);

len = [];
for i = 1:numel(notes)
    len = [len; length(notes{i})];
end
stats(1,4) = mean(len);
stats(2,4) = std(len);