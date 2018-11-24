% Objective: Store (non-score based) designed features for each student for the specified
% segment
% Inputs:
% BAND_OPTION: band name i.e. concert band, middle school or
% symphonic band
% INSTRUMENT_OPTION: eg. alto sax, oboe
% SEGMENT_OPTION: eg. 1-5
% YEAR_OPTION: eg. 2013, 2014, 2015
% Output: Extracted features and labels get stored in 'data' folder with
% the name in variable write_file_name which includes the band option,
% instrument option and segment name

function getFeatureForSegmentPyin(BAND_OPTION, INSTRUMENT_OPTION, SEGMENT_OPTION, YEAR_OPTION, NUM_FEATURES)

if ismac
    % Code to run on Mac plaform
    slashtype='/';
elseif ispc
    % Code to run on Windows platform
    slashtype='\';
end

DATA_PATH = ['experiments' slashtype 'pitched_instrument_regression' slashtype 'dataPyin' slashtype];
write_file_name = [BAND_OPTION INSTRUMENT_OPTION num2str(SEGMENT_OPTION) '_NonScore' '_' num2str(YEAR_OPTION)];

% Check for existence of path for writing extracted features.
root_path = deriveRootPath();
full_data_path = [root_path DATA_PATH];

if(~isequal(exist(full_data_path, 'dir'), 7))
    error('Error in your file path.');
end

% NUM_FEATURES = 25;
HOP_SIZE = 256;
WINDOW_SIZE = 1024;
resample_fs = 44100;
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
if SEGMENT_OPTION == 2 % TODO: check if this applies for lyrical exercise also
    num_labels = 4;
else
    num_labels = size(assessments, 2);
end
num_students = size(audition_metadata.file_paths, 1);

% Preallocate memory.
features = zeros(num_students, NUM_FEATURES);
labels = zeros(num_students, num_labels);
student_ids = audition_metadata.student_ids;

disp('Extracting features...');

% One student at a time.
for student_idx = 1:num_students
    disp(['Processing student: ' num2str(student_idx), ', student_id: ' num2str(student_ids(student_idx))]);
    file_name = audition_metadata.file_paths{student_idx};
    path = audition_metadata.pyin_paths{student_idx};
    segments = audition_metadata.segments{student_idx};
    student_assessments = audition_metadata.assessments{student_idx};
    % Retrieve audio for each segment.
    [segmented_audio, Fs] = scanAudioIntoSegments(file_name, segments);
    current_audio = segmented_audio{1};
    
    if(Fs ~= resample_fs)
        disp(file_name);
        error('improper sampling frequency in file');
    end
    
    % Normalize audio;
    normalized_audio = mean(current_audio, 2);
    normalized_audio = normalized_audio ./ max(abs(normalized_audio));
    
    %% Extract features
    % extract the pYin pitch contour for the segment
    f0 = getPyinPitchForSegment(path, segments);
    % extract features
    f0_features = extractF0Features(normalized_audio, f0, resample_fs, HOP_SIZE);
    features(student_idx, :) = f0_features;
    
    %% Store all assessments.
    segment_assessments = student_assessments(student_assessments ~= -1);
    if SEGMENT_OPTION == 2 % TODO: check if this applies for lyrical exercise also
        % we are not considering ARTISTRY LABEL for tecnical exercise 
        % for 2013 and 2014
        if or(strcmp(YEAR_OPTION, '2013') == 1, strcmp(YEAR_OPTION, '2014') == 1)
            assert(size(segment_assessments, 2) == 5)
            segment_assessments(:,1) = [];
        end
    end
    labels(student_idx, :) = segment_assessments;
end

% Write results to the file.
disp('Done extracting features. Writing results to file.');
save([full_data_path write_file_name], 'features', 'labels', 'student_ids');
disp('Done writing file.');

end



