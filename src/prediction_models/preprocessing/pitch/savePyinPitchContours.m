function savePyinPitchContours(BAND_OPTION, INSTRUMENT_OPTION, YEAR_OPTION)

% AP@GTCMT, 2017
% objective: compute and save the pYin pitch contours for all corresponding
% files specified by the input parameters 
%
% INPUTS
% BAND_OPTION: string for one of the three band options we have
% INSTRUMENT_OPTIONS: string for one of the instrument options we have
% YEAR_OPTION: string for one of the year options we have  
%
% OUTPUTS
% saves the pYin pitch contours in the respective folders as the annotations

%% set slashtype for different OS
if ismac
    % Code to run on Mac plaform
    slashtype='/';
elseif ispc
    % Code to run on Windows platform
    slashtype='\';
end

%% specify pYin parameters
curr_folder = pwd;
path_to_sonic_annotator = 'pYin/exec/';
path_to_pyin_n3 = 'pYin/';
cd(path_to_pyin_n3);
path_to_pyin_n3 = [pwd slashtype 'pyin.n3'];
cd(curr_folder)


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

%% iterate over the files
num_students = length(audio_file_paths);
for student_idx = 1:num_students
    path_to_file = audio_file_paths{student_idx};
    [audio_directory, file_name, ext] = fileparts(path_to_file);
    cd(audio_directory);
    audio_directory = pwd;
    cd(curr_folder);
    path_to_file = [audio_directory slashtype file_name ext];
    output_dir = [audio_directory slashtype];
    extractPyinPitchContour(path_to_file, output_dir, path_to_sonic_annotator, path_to_pyin_n3); 
    cd(curr_folder);
    disp(['Completed: ', num2str(student_idx), ' ,out of: ', num2str(num_students)]);
end


end