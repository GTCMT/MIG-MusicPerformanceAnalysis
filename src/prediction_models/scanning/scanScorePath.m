function score_path = ...
    scanScorePath(BAND_OPTION, YEAR_OPTION, INSTRUMENT_OPTION, SEGMENT_OPTION)
%% AP@GTCMT 2018
% objective: returns the path to the midi score given the arguments
% :param BAND_OPTION: string, band name, 'middle', 'concert' or 'symphonic'
% :param YEAR_OPTION: string, year, e.g. '2013', '2014', '2015'
% :param INSTRUMENT_OPTION: string, instrument name, 
%                           e.g. 'Alto Saxophone', 'Bb Clarinet', 'Flute'
% :param SEGMENT_OPTION: int, 1-5
% :return score_path: path to the midi score, return empty matrix if file
%                     not available

slashtype = getSlashType();
root_path = deriveRootPath();

if strcmp(BAND_OPTION, 'middle')
    band_folder = 'middleschool';
elseif strcmp(BAND_OPTION, 'concert')
    band_folder = 'concertband';
elseif strcmp(BAND_OPTION, 'symphonic')
    band_folder = 'symphonicband';
end

if strcmp(INSTRUMENT_OPTION, 'Alto Saxophone')
    folder_string = 'altosax';
    file_string = [folder_string '_' num2str(SEGMENT_OPTION) '.mid' ];
elseif strcmp(INSTRUMENT_OPTION, 'Snare')
    folder_string = 'snare';
    file_string = 'snare.mid';
else
    % TODO: complete this for other instrument types
    score_path = [];
    return
end

data_path = [root_path '..' slashtype '..' slashtype '..' slashtype 'MIG-FbaData'];
score_path = [data_path slashtype 'FBA' YEAR_OPTION slashtype band_folder ...
    slashtype 'musicalscores' slashtype folder_string slashtype file_string];

if exist(score_path, 'file') ~= 2
    score_path = [];
end

end