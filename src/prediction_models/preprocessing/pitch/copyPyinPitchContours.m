function copyPyinPitchContours(BAND_OPTION, INSTRUMENT_OPTION, YEAR_OPTION)

% AP@GTCMT, 2017
% objective: copies the saved pYin pitch contours from the FBA data folder
% to the FBA repository
%
% INPUTS
% BAND_OPTION: string for one of the three band options we have
% INSTRUMENT_OPTIONS: string for one of the instrument options we have
% YEAR_OPTION: string for one of the year options we have
%
% OUTPUTS
% copies the already saved pYin pitch contours to FBA repository folders

%% set slashtype for different OS
if ismac
    % Code to run on Mac plaform
    slashtype='/';
elseif ispc
    % Code to run on Windows platform
    slashtype='\';
end

% Scanning Options.
if YEAR_OPTION == '2013'
    year_folder = '2013-2014';
elseif YEAR_OPTION == '2014'
    year_folder = '2014-2015';
elseif YEAR_OPTION == '2015'
    year_folder = '2015-2016';
else
    disp('Error in year option');
end

%% scan student IDs
disp('Scanning filepaths...');
% scan student IDs
student_ids = scanStudentIds(BAND_OPTION, INSTRUMENT_OPTION, YEAR_OPTION);
% get audio filepaths
FBA_RELATIVE_PATH = ['..' slashtype '..' slashtype '..' slashtype 'FBA2013data' slashtype year_folder];
root_path = deriveRootPath();
full_fba_relative_path = [root_path FBA_RELATIVE_PATH];
audio_file_paths = scanFilePaths(full_fba_relative_path, student_ids, YEAR_OPTION);
disp('Done scanning.');


if YEAR_OPTION == '2013'
    switch (BAND_OPTION)
        case 'concert'
            band_folder = [slashtype 'concertbandscores'];
        case 'middle'
            band_folder = [slashtype 'middleschoolscores'];
        case 'symphonic'
            band_folder = [slashtype 'symphonicbandscores'];
    end
else
    switch (BAND_OPTION)
        case 'concert'
            band_folder = [slashtype 'concertband'];
        case 'middle'
            band_folder = [slashtype 'middleschool'];
        case 'symphonic'
            band_folder = [slashtype 'symphonicband'];
    end
end

%% iterate over files
repo_path = [root_path '..' slashtype '..' slashtype 'FBA' YEAR_OPTION];
num_students = length(audio_file_paths);
for student_idx = 1:num_students
    path_to_file = audio_file_paths{student_idx};
    [audio_directory, current_id, ~] = fileparts(path_to_file);
    path_to_pyin_contour = [audio_directory slashtype current_id,'_pyin_pitchtrack.txt'];
    output_dir = [repo_path band_folder slashtype current_id slashtype];
    if exist(output_dir, 'dir') ~= 7
       system(['mkdir ', output_dir]); 
    end
    command = ['cp ',path_to_pyin_contour, ' ', output_dir];
    system(command);
    disp(['Completed: ', num2str(student_idx), ' ,out of: ', num2str(num_students)]);
end


end
