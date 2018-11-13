%% script to perform N-fold cross validation over all years
% performs 5% outlier removal on training data also

%close all;
%close all;
%clear all;
%clc;

%% specify experiment parameters
% specify data folder
dataFolder = 'dataPyin';
dataFolder2 = 'data';
% specify label
l = 2; % 1: musicality, 2: note accuracy, 3: rhythmic accuracy, 4: tone quality
% specify feature type
feature_type = 'Combined'; % options are 'Score', 'NonScore', 'Combined'
% specify number of folds
NUM_FOLDS = 3;

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
    if size(labels, 2) ~= 4
       error('Improper data'); 
    end
    feat_mat{j} = features;
    label_vect{j} = labels(:,l);
end

% Check for existence of path for writing extracted features.
DATA_PATH = ['experiments', slashtype, 'pitched_instrument_regression' slashtype, dataFolder2, slashtype];
root_path = deriveRootPath();
full_data_path = [root_path DATA_PATH];

if(~isequal(exist(full_data_path, 'dir'), 7))
    error('Error in your file path.');
end

% read stored feature matrices and labels
feat_mat2 = cell(num_years, 1);
label_vect2 = cell(num_years, 1);
for j =1:num_years
    filename = [full_data_path , 'middleAlto Saxophone2_', feature_type, '_', year{j}, '.mat'];
    load(filename);
    feat_mat2{j} = features;
    if size(labels, 2) ~= 4
       error('Improper data'); 
    end
    label_vect2{j} = labels(:,l);
end

%% train and test for all folds sequentially

% assign variables to store resutls
result_test_pyin = zeros(NUM_FOLDS, 4); % 4 for the number of test parameters
result_test_acf = zeros(NUM_FOLDS, 4);

% get fold indices for the different folds
foldidx = cell(num_years,1);
for i = 1:num_years
    foldidx{i} = crossvalind('Kfold', length(label_vect{i}), NUM_FOLDS);
end

% iterate over different test years
for feature_type = 1%:2
    for i = 1:NUM_FOLDS
        %% Test for pYin features
        % initialize training and testing features and labels
        training_features = [];
        training_labels = [];
        testing_features = [];
        testing_labels = [];
        for year_idx = 1:num_years
            % create dummy variables for storage based on which feature type to
            % use
            % 1: pYin, 2:acf
            if feature_type == 1
                dummy_features = feat_mat{year_idx};
                dummy_labels = label_vect{year_idx};
            elseif feature_type ==2
                dummy_features = feat_mat2{year_idx};
                dummy_labels = label_vect2{year_idx};
            end
            % get testing features and labels
            testing_features = [testing_features; dummy_features(foldidx{year_idx} == i, :)];
            testing_labels = [testing_labels; dummy_labels(foldidx{year_idx} == i, :)];
            dummy_features(foldidx{year_idx} == i, :) = [];
            dummy_labels(foldidx{year_idx} == i, :) = [];
            
            % get training features and labels
            training_features = [training_features; dummy_features];
            training_labels = [training_labels; dummy_labels];
        end
        
        % perform outlier removal in training set
        num_folds = length(training_labels);
        [~, ~, ~, ~, predictions] = crossValidation(training_labels, training_features, num_folds);
        err = abs(training_labels - predictions);
        [sort_err,idx_err] = sort(err,'descend');
        new_features = training_features;
        loopLen = floor(0.05*length(training_labels));
        
        for k=1:loopLen
            new_features(idx_err(1), :) = [];
            training_labels(idx_err(1)) = [];
            
            num_folds = num_folds - 1;
            [~, ~, ~, ~, new_predictions] = crossValidation(training_labels, new_features, num_folds);
            
            err=abs(training_labels - new_predictions);
            [sort_err,idx_err] = sort(err,'descend');
            
            %fprintf(['\nResults complete.\nR squared: ' num2str(Rsq) ...
            %    '\nStandard error: ' num2str(S) '\nP value: ' num2str(p) ...
            %    '\nCorrelation coefficient: ' num2str(r) '\n']);
        end
        % plot trainin results
        %figure; plot(training_labels, new_predictions,'*'); xlabel('Test Labels'); ylabel('Prediction');
        
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
        if feature_type == 1
            result_test_pyin(i, :) = [r , p, Rsq, S];
        elseif feature_type ==2
            result_test_acf(i, :) = [r , p, Rsq, S];
        end
        
        
        % print testing results
        fprintf(['\nResults complete.\nR squared: ' num2str(Rsq) ...
            '\nStandard error: ' num2str(S) '\nP value: ' num2str(p) ...
            '\nCorrelation coefficient: ' num2str(r) '\n']);
        
        % plot testing results
        %figure; plot(testing_labels,predictions,'*'); xlabel('Test Labels'); ylabel('Prediction');
        
    end
end

