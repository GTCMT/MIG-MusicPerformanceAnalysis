%% map segment id to their corresponding names
% CW @ GTCMT 2016
% Input:
%   idx = int, index of the segments (1~10)
% Output:
%   segmentName = string, full name of the corresponding segment

function segmentName = getSegmentName(idx)

listOfSegment = {...
    'lyricalEtude';
    'technicalEtude';
    'scalesChromatic';
    'scalesMajor';
    'sightReading';
    'malletEtude';
    'snareEtude';
    'timpaniEtude';
    'readingMallet';
    'readingSnare'
    };
segmentName = listOfSegment{idx};

    

