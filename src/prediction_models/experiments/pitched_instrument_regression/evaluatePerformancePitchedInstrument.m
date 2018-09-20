%% Evaluate Regression for Pitched Instrument 
% CL@GTCMT 2015
% evaluatePerformancePitchedInstrument(read_file_name)
% objective: Evaluate regression model for pitched instrument experiment.
%
% read_file_name: string, name of file to read training data from.

function evaluatePerformancePitchedInstrument(read_file_name)
DATA_PATH = '../../../../data/';
NUM_FOLDS = 10;

% Check for existence of file with training data features and labels.
if(exist('read_file_name', 'var'))
  root_path = deriveRootPath();
  full_data_path = [root_path DATA_PATH];
  
  if(~isequal(exist(full_data_path, 'dir'), 7))
    error('Error in your file path.');
  end
else
  error('No file name specified.');
end

% Load training data.
load([full_data_path read_file_name]);

% Average the assessments to get one label.
labels = mean(labels, 2);

% Evaluate model using cross validation.
[Rsq, S, p, r] = crossValidation(labels, features, NUM_FOLDS);
fprintf(['\nResults complete.\nR squared: ' num2str(Rsq) ...
         '\nStandard error: ' num2str(S) '\nP value: ' num2str(p) ...
         '\nCorrelation coefficient: ' num2str(r) '\n']);
end

