% AV@GTCMT
% Objective: Use the one year's model (after removing 5% outliers) to test
% for either of the remaining years' data

close all;
fclose all;
clear all;
clc;

DATA_PATH = 'experiments/pitched_instrument_regression/data/';
write_file_name = 'middleAlto Saxophone2_designedFeatures_2013';

% Check for existence of path for writing extracted features.
root_path = deriveRootPath();
full_data_path = [root_path DATA_PATH];

if(~isequal(exist(full_data_path, 'dir'), 7))
    error('Error in your file path.');
end
  
load([full_data_path write_file_name]);


% Average the assessments to get one label.
labels = labels(:,2); %labels(:,3),labels(:,5)
NUM_FOLDS = length(labels);

% remove top 5% features and test
[Rsq, S, p, r, predictions] = crossValidation(labels, features, NUM_FOLDS);
err=abs(labels-predictions);
[sort_err,idx_err]=sort(err,'descend');
new_features=features;
%new_labels=predictions;
% new_labels = labels;

for i=1:floor(0.05*length(labels))
    
    new_features(idx_err(1),:)=[];
    labels(idx_err(1)) = [];

    NUM_FOLDS=NUM_FOLDS-1;
    [Rsq, S, p, r, new_predictions] = crossValidation(labels, new_features, NUM_FOLDS);
    %     uncomment the commented portion in the line below for spearman correlation
    [r, p] = corr(labels, new_predictions); %, 'type', 'Spearman');

    err=abs(labels-new_predictions);
    [sort_err,idx_err]=sort(err,'descend');

    fprintf(['\nResults complete.\nR squared: ' num2str(Rsq) ...
         '\nStandard error: ' num2str(S) '\nP value: ' num2str(p) ...
         '\nCorrelation coefficient: ' num2str(r) '\n']);
end

% training features from 2013
train_features = new_features;
train_labels = labels;
clear labels; clear features;

% test features from either 2014 or 2015
write_file_name = 'middleAlto Saxophone2_designedFeatures_2015';
root_path = deriveRootPath();
full_data_path = [root_path DATA_PATH];
load([full_data_path write_file_name]);
test_features = features;
test_labels = labels(:,1);
clear labels; clear features;

% Normalize
[train_features, test_features] = NormalizeFeatures(train_features, test_features);
% feature truncation
locations_truncated = (test_features >= 1) + (test_features <= 0);
test_features(test_features >= 1) = 1;
test_features(test_features <= 0) = 0;

% remove top 2 most truncated features
countTruncation = sum(locations_truncated);
[val,loc]=max(countTruncation);
train_features(:,loc)=[];
test_features(:,loc)=[];
countTruncation(loc)=[];
[val,loc]=max(countTruncation);
train_features(:,loc)=[];
test_features(:,loc)=[];

% Train the classifier and get predictions for the current fold.
svm = svmtrain(train_labels, train_features, '-s 4 -t 0 -q');
predictions = svmpredict(test_labels, test_features, svm, '-q');
  
% prediction truncation
% predictions(predictions>=1) = 1;
% predictions(predictions<=0) = 0;

[Rsq, S, p, r] = myRegEvaluation(test_labels, predictions); 
%       spearman correlation
[r, p] = corr(test_labels, predictions); %, 'type', 'Spearman');

fprintf(['\nResults complete.\nR squared: ' num2str(Rsq) ...
         '\nStandard error: ' num2str(S) '\nP value: ' num2str(p) ...
         '\nCorrelation coefficient: ' num2str(r) '\n']);

figure; plot(test_labels,predictions,'*'); xlabel('Test Labels'); ylabel('Prediction');