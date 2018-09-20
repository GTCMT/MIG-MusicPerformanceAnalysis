function filepaths = scanSegmentFilePaths(student_ids, BAND_OPTION, YEAR_OPTION)

% AP@GTCMT, 2017
% objective: returns the path to the segments file for input student_ids
%
% INPUTS
% students_ids: 1xnum_students int, containing student ids
% BAND_OPTION: string for one of the three band options we have
% YEAR_OPTION:  string for one of the year options we have
%
% OUTPUTS
% filepaths:    1xnum_students cell, containing file paths

root_path = deriveRootPath();

if ismac
    % Code to run on Mac plaform
    slashtype='/';
elseif ispc
    % Code to run on Windows platform
    slashtype='\';
end
% //initialization
annPath = [root_path '..' slashtype '..' slashtype '..' slashtype 'MIG-FbaData' slashtype 'FBA' YEAR_OPTION];
N = length(student_ids);


if YEAR_OPTION == '2013'
    switch BAND_OPTION
        case 'concert'
            bandFolder = [slashtype 'concertbandscores'];
        case 'middle'
            bandFolder = [slashtype 'middleschoolscores'];
        case 'symphonic'
            bandFolder = [slashtype 'symphonicbandscores'];
    end
else
    switch BAND_OPTION
        case 'concert'
            bandFolder = [slashtype 'concertband'];
        case 'middle'
            bandFolder = [slashtype 'middleschool'];
        case 'symphonic'
            bandFolder = [slashtype 'symphonicband'];
    end
end

filepaths = cell(N,1);
for j = 1:N
    current_id = num2str(student_ids(j));
    file_name  = strcat(slashtype, current_id, '_', 'segment.txt');
    filepath   = strcat(annPath, bandFolder, slashtype, current_id, file_name);
    % //read segment file
    if exist(filepath, 'file') == 2
        filepaths{j} = filepath;
    else
        filepaths{j} = [];
    end
end
 
end