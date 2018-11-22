%% script to test audio files status

BAND_OPTION = 'middle';
INSTRUMENT_OPTION = 'Alto Saxophone';
YEAR_OPTION = '2015';
SEGMENT_OPTION = 2;
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

FBA_RELATIVE_PATH = ['..' slashtype '..' slashtype '..' slashtype 'FBA2013data' slashtype year_folder];
% BAND_OPTION = 'middle';
% INSTRUMENT_OPTION = 'Oboe';
% SEGMENT_OPTION = 2;
SCORE_OPTION = [];

% Read data from the database.
disp('Scanning database for files and metadata...');
audition_metadata = scanFBA(FBA_RELATIVE_PATH, ...
                            BAND_OPTION, INSTRUMENT_OPTION, ...
                            SEGMENT_OPTION, SCORE_OPTION, YEAR_OPTION);
disp('Done scanning database.');

% Figure out size of data, for preallocating memory.
assessments = audition_metadata.assessments{1};
assessments = assessments(1, :);
assessments = assessments(assessments ~= -1);
num_labels = size(assessments, 2);
num_students = size(audition_metadata.file_paths, 1); 

%{
% Check for abnormal file sizes
curr_folder = pwd;
count = 0;
for student_idx = 1:num_students
    %disp(strcat('checking file:', num2str(student_idx)));
    file_path = audition_metadata.file_paths{student_idx};
    [path, name, ext] = fileparts(file_path);
    directory = [path slashtype];
    cd(directory);
    file_info = dir('*mp3');
    if length(file_info) > 1
        error('More than one file found in directory');
    end
    file_size = file_info(1).bytes;
    if file_size > 15000000
        count = count + 1;
        warning(file_path);
    end
    cd(curr_folder);
end
%}

% Check if we can load all files
fscount = 0;
for student_idx =1:num_students 
   disp(num2str(student_idx));
   [x,fs] = audioread(audition_metadata.file_paths{student_idx}); 
   if (fs ~= 44100)
       fscount = fscount + 1;
        warning(audition_metadata.file_paths{student_idx});
   end
end
