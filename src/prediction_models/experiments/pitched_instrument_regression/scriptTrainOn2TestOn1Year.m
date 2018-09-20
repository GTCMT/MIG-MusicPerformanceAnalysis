%% script to train on 2 years of data and test on 1 yr
% performs outlier removal on training data also

close all;
fclose all;
clear all;
clc;

%% specify experiment parameters
% specify data folder
dataFolder = 'dataPyin'; % change to 'dataPyin' torun for pYin features
% specify label
l = 3; % 1: musicality, 2: note accuracy, 3: rhythmic accuracy, 4: tone quality
% specify feature type
feature_type = 'NonScore'; % options are 'Score', 'NonScore', 'Combined'

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

% read stored feature matrices and labels
num_years = 3;
year = {'2013', '2014', '2015'};
feat_mat = cell(num_years, 1);
label_vect = cell(num_years, 1);
for j =1:num_years
    filename = [full_data_path , 'middleAlto Saxophone2_', feature_type, '_', year{j}, '.mat'];
    load(filename);
    feat_mat{j} = features;
    label_vect{j} = labels(:,l);
end


%% train and test sequentially

% assign variables to store resutls
result_test = zeros(num_years, 4); % 4 for the number of test parameters

% iterate over different test years
for test_idx = 1:num_years
    % create dummy variables for storage
    dummy_features = feat_mat;
    dummy_labels = label_vect;
    
    % define test features and labels
    testing_features = dummy_features{test_idx};
    testing_labels = dummy_labels{test_idx};
    
    % define train features
    dummy_features(test_idx) = [];
    dummy_labels(test_idx) = [];
    training_features = [];
    training_labels = [];
    for j = 1:num_years-1
        training_features = [training_features; dummy_features{j}];
        training_labels = [training_labels; dummy_labels{j}];
    end
    
    %% perform outlier removal in training set
    NUM_FOLDS = length(training_labels);
    [~, ~, ~, ~, predictions] = crossValidation(training_labels, training_features, NUM_FOLDS);
    err = abs(training_labels - predictions);
    [sort_err,idx_err] = sort(err,'descend');
    new_features = training_features;
    loopLen = floor(0.05*length(training_labels));
    
    for i=1:loopLen
        new_features(idx_err(1), :) = [];
        training_labels(idx_err(1)) = [];
        
        NUM_FOLDS = NUM_FOLDS - 1;
        [~, ~, ~, ~, new_predictions] = crossValidation(training_labels, new_features, NUM_FOLDS);
        
        err=abs(training_labels - new_predictions);
        [sort_err,idx_err] = sort(err,'descend');
        
        %fprintf(['\nResults complete.\nR squared: ' num2str(Rsq) ...
        %    '\nStandard error: ' num2str(S) '\nP value: ' num2str(p) ...
        %    '\nCorrelation coefficient: ' num2str(r) '\n']);
    end
    % plot trainin results 
    figure; plot(training_labels, new_predictions,'*'); xlabel('Test Labels'); ylabel('Prediction');
    
    % reassign training features and labels
    training_features = new_features;
    
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
    result_test(test_idx, :) = [r , p, Rsq, S];

    % print testing results
    fprintf(['\nResults complete.\nR squared: ' num2str(Rsq) ...
         '\nStandard error: ' num2str(S) '\nP value: ' num2str(p) ...
         '\nCorrelation coefficient: ' num2str(r) '\n']);
    
     % plot testing results 
    figure; plot(testing_labels,predictions,'*'); xlabel('Test Labels'); ylabel('Prediction');
end

