%% script toget baseline results for DL project
close all;
clear all;
clc;

%% specify experiment parameters
% specify data folder
dataFolder = 'dataPyin';
% specify band
band = 'middle';
% specify label
l = 1; % 1: musicality, 2: note accuracy, 3: rhythmic accuracy, 4: tone quality

%% define file paths and read feature data
if ismac
    % Code to run on Mac plaform
    slashtype='/';
elseif ispc
    % Code to run on Windows platform
    slashtype='\';
end
% Check for existence of path for writing extracted features.
DATA_PATH = ['experiments', slashtype, 'pitched_instrument_regression' slashtype, dataFolder, slashtype];
root_path = deriveRootPath();
full_data_path = [root_path DATA_PATH];

if(~isequal(exist(full_data_path, 'dir'), 7))
    error('Error in your file path.');
end
datafile = ['dataPyin/', band,'_BD_All.mat'];
load(datafile);

%% divide data into training, validation and test sets
% read the id sets
load(['dataPyin/DL_ids_', band,'.mat']);
[~, idxs] = intersect(student_ids, train_ids);
training_features = features(idxs, :);
training_features_copy = training_features;
training_labels = labels(idxs, l);
[~, idxs] = intersect(student_ids, val_ids);
val_features = features(idxs, :);
val_labels = labels(idxs, l);
[~, idxs] = intersect(student_ids, test_ids);
testing_features = features(idxs, :);
testing_labels = labels(idxs, l);
testing_ids = student_ids(idxs);

%% train and test
result = zeros(1, 4);
% % perform outlier removal in training set
% num_folds = length(training_labels);
% disp('Enter Crossvalidation');
% [~, ~, ~, ~, predictions] = crossValidation(training_labels, training_features, num_folds);
% disp('Exit Crossvalidation')
% err = abs(training_labels - predictions);
% [sort_err,idx_err] = sort(err,'descend');
% new_features = training_features;
% loopLen = floor(0.05*length(training_labels));
% 
% disp(loopLen)
% for k=1:loopLen
%     new_features(idx_err(1), :) = [];
%     training_labels(idx_err(1)) = [];
%     disp(k)
%     num_folds = num_folds - 1;
%     [~, ~, ~, ~, new_predictions] = crossValidation(training_labels, new_features, num_folds);
%     
%     err=abs(training_labels - new_predictions);
%     [sort_err,idx_err] = sort(err,'descend');
%     
% end
% 
% % reassign training features and labels
% training_features = new_features;

% Normalize features
[training_features, testing_features] = NormalizeFeatures(training_features, testing_features);

% train SVM model on new reduced training feature set
svm = svmtrain(training_labels, training_features, '-s 4 -t 0 -q');

% test SVM model on test set
predictions = svmpredict(testing_labels, testing_features, svm, '-q');
% clip predictions to range between 0 and 1
predictions(predictions>1)=1;
predictions(predictions<0)=0;
[Rsq, S, p, r] = myRegEvaluation(testing_labels, predictions);
result = [r , p, Rsq, S];

% print testing results
fprintf(['\nResults complete.\nR squared: ' num2str(Rsq) ...
    '\nStandard error: ' num2str(S) '\nP value: ' num2str(p) ...
    '\nCorrelation coefficient: ' num2str(r) '\n']);

% plot testing results
%figure; plot(testing_labels,predictions,'*'); xlabel('Test Labels'); ylabel('Prediction');

% %% Test on different band
% 
% band = 'middle';
% datafile = ['dataPyin/', band,'_BD_All.mat'];
% load(datafile);
% % read the id sets
% load(['dataPyin/DL_ids_', band,'.mat']);
% [~, idxs] = intersect(student_ids, test_ids);
% testing_features = features(idxs, :);
% testing_labels = labels(idxs, l);
% 
% % renormalize features
% [training_features, testing_features] = NormalizeFeatures(training_features_copy, testing_features);
% 
% % test SVM model on test set
% predictions = svmpredict(testing_labels, testing_features, svm, '-q');
% % clip predictions to range between 0 and 1
% predictions(predictions>1)=1;
% predictions(predictions<0)=0;
% [Rsq, S, p, r] = myRegEvaluation(testing_labels, predictions);
% result = [r , p, Rsq, S];
% 
% fprintf(['\nResults complete.\nR squared: ' num2str(Rsq) ...
%     '\nStandard error: ' num2str(S) '\nP value: ' num2str(p) ...
%     '\nCorrelation coefficient: ' num2str(r) '\n']);