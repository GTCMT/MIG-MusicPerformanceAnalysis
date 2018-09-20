%% Create Training Data for Pitched Instruments
% CL@GTCMT 2015
% createTrainingDataPitchedInstruments(write_file_name, quick)
%
% objective: Create training data for the pitched instrument regression
%            experiment.
%
% write_file_name: string, name of file to write training data to.
% quick: boolean, true means only extract some of the data.
%
% WARNING: Does NOT work when extracting multiple segments.
 
function createTrainingDataPitchedInstruments(write_file_name, quick)
DATA_PATH = '../../../../data/';

% Check for existence of path for writing extracted features.
if(exist('write_file_name', 'var'))
  root_path = deriveRootPath();
  full_data_path = [root_path DATA_PATH];
  
  if(~isequal(exist(full_data_path, 'dir'), 7))
    error('Error in your file path.');
  end
else
  error('No file name specified.');
end

NUM_FEATURES = 16;
HOP_SIZE = 512;

% Scanning Options.
FBA_RELATIVE_PATH = '../../../../dataset/FBA2013';
BAND_OPTION = 'symphonic';
INSTRUMENT_OPTION = 'Bb Clarinet';
SEGMENT_OPTION = 2;
SCORE_OPTION = [];

% Read data from the database.
disp('Scanning database for files and metadata...');
audition_metadata = scanFBA(FBA_RELATIVE_PATH, ...
                            BAND_OPTION, INSTRUMENT_OPTION, ...
                            SEGMENT_OPTION, SCORE_OPTION);
disp('Done scanning database.');
                          
% Figure out size of data, for preallocating memory.
assessments = audition_metadata.assessments{1};
assessments = assessments(1, :);
assessments = assessments(assessments ~= -1);
num_labels = size(assessments, 2);
num_students = size(audition_metadata.file_paths, 1); 

% For prototyping.
if(quick)
  num_students = 20;
end

% Preallocate memory.
features = zeros(num_students, NUM_FEATURES);
labels = zeros(num_students, num_labels);

disp('Extracting features...');

% One student at a time.
for(student_idx = 1:num_students)
  disp(['Processing student: ' num2str(student_idx)]);
  file_name = audition_metadata.file_paths{student_idx};
  segments = audition_metadata.segments{student_idx};
  student_assessments = audition_metadata.assessments{student_idx};

  % Retrieve audio for each segment.
  [segmented_audio, Fs] = scanAudioIntoSegments(file_name, segments);
  current_audio = segmented_audio{1};

  % Normalize audio;
  normalized_audio = mean(current_audio, 2);
  normalized_audio = normalized_audio ./ max(abs(normalized_audio));

  % Extract features.
  features(student_idx, :) = ...
      extractFeaturesPitchedInstruments(normalized_audio, Fs, HOP_SIZE);

  % Store all assessments.
  segment_assessments = student_assessments(1, :);
  segment_assessments = segment_assessments(segment_assessments ~= -1);

  labels(student_idx, :) = segment_assessments;
end

% Write results to the file.
disp('Done extracting features. Writing results to file.');
save([full_data_path write_file_name], 'features', 'labels');
disp('Done writing file.');

end