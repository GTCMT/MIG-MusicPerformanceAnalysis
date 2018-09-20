%% Remap segment numbers in audio to segment numbers in assessment table 
% CW@GTCMT 2015
% segment_option_remapped = segmentRemap(segment_option, instrument_option)
%
% segment_option = N*1 int vector, specify your target segments, ex: [3; 5]
% instrument_option = string specifying instrument as it appears in the xls
% segment_option_remapped = N*1 int vector, segment number as in the xls
%
% The segment number in the assessment table: 
% Rows (10 segments):
% 1. lyricalEtude
% 2. technicalEtude
% 3. scalesChromatic
% 4. scalesMajor
% 5. sightReading
% 6. malletEtude
% 7. snareEtude
% 8. timpaniEtude
% 9. readingMallet
% 10. readingSnare

function segment_option_remapped = segmentRemap(segment_option, instrument_option)

L = length(segment_option);
segment_option_remapped = zeros(L, 1);

if strcmp(instrument_option, 'Percussion')
    segment_option_remapped(segment_option == 1) = 6;
    segment_option_remapped(segment_option == 2) = 7;
    segment_option_remapped(segment_option == 3) = 8;
    segment_option_remapped(segment_option == 4) = 3;
    segment_option_remapped(segment_option == 5) = 4;
    segment_option_remapped(segment_option == 6) = 9;
    segment_option_remapped(segment_option == 7) = 10;   
elseif strcmp(instrument_option, 'Bb Clarinet')
    segment_option_remapped(segment_option == 1) = 1;
    segment_option_remapped(segment_option == 2) = 2;
    segment_option_remapped(segment_option == 3) = 3;
    segment_option_remapped(segment_option == 4) = 4;
    segment_option_remapped(segment_option == 5) = 5;
elseif strcmp(instrument_option, 'Oboe')
    segment_option_remapped(segment_option == 1) = 1;
    segment_option_remapped(segment_option == 2) = 2;
    segment_option_remapped(segment_option == 3) = 3;
    segment_option_remapped(segment_option == 4) = 4;
    segment_option_remapped(segment_option == 5) = 5;
elseif strcmp(instrument_option, 'Trumpet')
    segment_option_remapped(segment_option == 1) = 1;
    segment_option_remapped(segment_option == 2) = 2;
    segment_option_remapped(segment_option == 3) = 3;
    segment_option_remapped(segment_option == 4) = 4;
    segment_option_remapped(segment_option == 5) = 5;
elseif strcmp(instrument_option, 'Flute')
    segment_option_remapped(segment_option == 1) = 1;
    segment_option_remapped(segment_option == 2) = 2;
    segment_option_remapped(segment_option == 3) = 3;
    segment_option_remapped(segment_option == 4) = 4;
    segment_option_remapped(segment_option == 5) = 5;
elseif strcmp(instrument_option, 'Trombone')
    segment_option_remapped(segment_option == 1) = 1;
    segment_option_remapped(segment_option == 2) = 2;
    segment_option_remapped(segment_option == 3) = 3;
    segment_option_remapped(segment_option == 4) = 4;
    segment_option_remapped(segment_option == 5) = 5;
elseif strcmp(instrument_option, 'Alto Saxophone')
    segment_option_remapped(segment_option == 1) = 1;
    segment_option_remapped(segment_option == 2) = 2;
    segment_option_remapped(segment_option == 3) = 3;
    segment_option_remapped(segment_option == 4) = 4;
    segment_option_remapped(segment_option == 5) = 5;
else
  warning(['Segments for ' instrument_option ' have not been mapped ' ...
           'yet. Define the mapping yourself in '...
           'scanning/segmentRemap.m.']);
    
  segment_option_remapped = segment_option;
end





