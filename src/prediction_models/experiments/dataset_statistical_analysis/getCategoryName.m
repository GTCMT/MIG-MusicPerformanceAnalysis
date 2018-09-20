%% map category id to their corresponding names
% CW @ GTCMT 2016
% Input:
%   idx = int, index of the category (1~26)
% Output:
%   categoryName = string, full name of the corresponding category

function categoryName = getCategoryName(idx)

listOfCategory = {...
    'articulation';
    'artistry';
    'musicalityTempoStyle';
    'noteAccuracy';
    'rhythmicAccuracy';
    'toneQuality';
    'articulationStyle';
    'musicalityPhrasingStyle';
    'noteAccuracyConsistency';
    'tempoConsistency';
    'Ab';
    'A';
    'Bb';
    'B';
    'C';
    'Db';
    'D';
    'Eb';
    'E';
    'F';
    'Gb';
    'G';
    'chromatic';
    'musicalityStyle';
    'noteAccuracyTone';
    'rhythmicAccuracyArticulation';
    };
categoryName = listOfCategory{idx};

    

