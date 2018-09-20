% main function for visualizing the data distributions
% CW @ GTCMT 2016
% Instruction:
% This script is to visualize the distributions of the judges' gradings.
% To use this script, please first define the following parameters:
% 1. band_list: a cell vector of the groups of interest
% 2. instrument_list: a cell vector of the instrument of interest
% 3. segment_option: int, the index of segment of interest (see below)
% 4. year_option: which year do you want to plot for (2013, 2014, 2015)
% The segment number in the assessment table: 
% Rows (10 segments):
%   1. lyricalEtude
%   2. technicalEtude
%   3. scalesChromatic
%   4. scalesMajor
%   5. sightReading
%   6. malletEtude
%   7. snareEtude
%   8. timpaniEtude
%   9. readingMallet
%   10. readingSnare
% 4. categoryInd: int, the index of category of interest (see README.txt)
clear all; close all; clc;

%=== define list of interest
band_list = {
    'middle';
%     'concert';
%     'symphonic';
    };

instrument_list = {
    'Alto Saxophone';
    %'Bb Clarinet';
    %'Flute';
    %'Trumpet';
    %'Trombone';
%     'Percussion';
    };
segment_option = 2;
year_option = '2013'

%=== main loop for visualization
count = 0;
for i = 1:length(band_list)

    for j = 1:length(instrument_list)
        count = count + 1;
        
        % define parameters
        band_option = band_list{i};
        instrument_option = instrument_list{j};
        
        % get segment
        if strcmp(instrument_option, 'Percussion')
            segment_option = 7; 
            categoryInd = 3; %1)musicality 2)noteAccu 3)rhythmicAccu
        else
            segment_option = 2; 
            categoryInd = 5; %2)musicality 3)noteAccu 4)rhythmicAccu
        end
        segmentName = getSegmentName(segment_option);
        
        % get information 
        [assessments, categoryName, idx] = getDistributionInfo(band_option, instrument_option, segment_option, year_option);
        subplot(length(band_list), length(instrument_list), count);
        histogram(assessments(:, categoryInd), 10);
        axis([0 1 0 100]);
        legend(instrument_list{j});
        title(strcat(band_list{i}, ',', categoryName{categoryInd}, ',', segmentName));
    end
end

