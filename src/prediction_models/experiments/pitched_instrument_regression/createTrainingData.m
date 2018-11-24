function [features, labels, student_ids] = ...
    createTrainingData(BAND_OPTION, INSTRUMENT_OPTION, SEGMENT_OPTION, ...
    YEAR_OPTION, PITCH_OPTION, FEATURE_TYPE, QUICK)
%% AP@GTCMT 2018
% objective: creates the training data based on the given arguments
% :param BAND_OPTION: string, band name, 'middle', 'concert' or 'symphonic'
% :param INSTRUMENT_OPTION: string, instrument name, 
%                           e.g. 'Alto Saxophone', 'Bb Clarinet', 'Flute'
% :param SEGMENT_OPTION: int, 1-5
% :param YEAR_OPTION: string, year, e.g. '2013', '2014', '2015'
% :param PITCH_OPTION: string, pitch contour type, 'pyin' or 'acf'
% :param FEATURE_TYPE: string, type of feature, 'std', 'nonscore', 'score'
% :param quick: 1 for prototyping, 0 to consider all students
% :return features: NxF matrix, N - number of students, F - number of features
% :return labels: NxL matrix, N - number of students, L - number of labels
% :return student_ids: Nx1 matrix, N - number of students

% basic things first
SLASH_TYPE = getSlashType();
ROOT_PATH = deriveRootPath();
FBA_DATA_FOLDER = 'FBA2013data';

% define constants
HOP_SIZE = 256;
WINDOW_SIZE = 1024;
RESAMPLE_FS = 44100;
if strcmp(FEATURE_TYPE, 'std') 
    NUM_FEATURES = 68;
elseif strcmp(FEATURE_TYPE, 'nonscore')
    NUM_FEATURES = 24;
elseif strcmp(FEATURE_TYPE, 'score') 
    NUM_FEATURES = 22;
else
    warning('Invalid FEATURE_TYPE. Computing non-score based features')
    NUM_FEATURES = 24; 
end
YEAR_FOLDER = getYearFolderString(YEAR_OPTION);
FBA_RELATIVE_PATH = ...
    [ROOT_PATH SLASH_TYPE '..' SLASH_TYPE FBA_DATA_FOLDER SLASH_TYPE YEAR_FOLDER];
SCORE_OPTION = [];

% Read data from the database.
disp('Scanning database for files and metadata...');
audition_metadata = scanFBA(FBA_RELATIVE_PATH, ...
    BAND_OPTION, INSTRUMENT_OPTION, ...
    SEGMENT_OPTION, SCORE_OPTION, YEAR_OPTION);
disp('Done scanning database.');

% Figure out size of data, for preallocating memory.
assessments = audition_metadata.assessments{1}(1, :);
%% TODO: Complete this for other segments
if SEGMENT_OPTION == 2 
    num_labels = 4;
else
    assessments = assessments(assessments ~= -1);
    num_labels = size(assessments, 2);
end
num_students = size(audition_metadata.file_paths, 1);
% Reduce number of students for prototyping
if QUICK
    num_students = 10;
end

% Preallocate memory.
features = zeros(num_students, NUM_FEATURES);
labels = zeros(num_students, num_labels);
student_ids = audition_metadata.student_ids(1:num_students);

% One student at a time.
for student_idx = 1:num_students
    disp(['Processing student: ' num2str(student_idx), ...
        ', student_id: ' num2str(student_ids(student_idx))]);
    % Extract filename and other information
    file_name = audition_metadata.file_paths{student_idx};
    segments = audition_metadata.segments{student_idx};
    student_assessments = audition_metadata.assessments{student_idx};
    pyin_path = audition_metadata.pyin_paths{student_idx};
    score_path = audition_metadata.score_path;
    % Retrieve audio for each segment.
    [segmented_audio, Fs] = scanAudioIntoSegments(file_name, segments);
    current_audio = segmented_audio{1};
    
    % Sanity check
    if(Fs ~= RESAMPLE_FS)
        disp(file_name);
        error('improper sampling frequency in file');
    end
    
    % Normalize audio;
    normalized_audio = mean(current_audio, 2);
    normalized_audio = normalized_audio ./ max(abs(normalized_audio));
    
    % Extact pitch contour
    if strcmp(PITCH_OPTION, 'pyin')
        f0 = getPyinPitchForSegment(pyin_path, segments);
    elseif strcmp(PITCH_OPTION, 'acf')
        [f0, ~] = ...
            estimatePitch(normalized_audio, RESAMPLE_FS, HOP_SIZE, WINDOW_SIZE, 'acf'); 
    end
    
    % Extract features.
    if strcmp(FEATURE_TYPE, 'std') 
        features(student_idx, :) = ...
            extractStandardFeatures(normalized_audio, f0, RESAMPLE_FS, WINDOW_SIZE, HOP_SIZE);
    elseif strcmp(FEATURE_TYPE, 'nonscore')
        features(student_idx, :) = ...
            extractNonScoreFeatures(normalized_audio, f0, RESAMPLE_FS, HOP_SIZE, NUM_FEATURES);
    elseif strcmp(FEATURE_TYPE, 'score')
        features(student_idx, :) = ...
            extractScoreFeatures(normalized_audio, f0, RESAMPLE_FS, WINDOW_SIZE, HOP_SIZE, score_path, NUM_FEATURES);
    end
    
    % Store all assessments.
    %% TODO: complete this for other segments
    if SEGMENT_OPTION == 2
        segment_assessments = student_assessments(2:5);
    else
        segment_assessments = student_assessments(student_assessments ~= -1);
    end
    labels(student_idx, :) = segment_assessments;
end

end