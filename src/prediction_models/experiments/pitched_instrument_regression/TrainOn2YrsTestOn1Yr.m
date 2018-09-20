% AV@GTCMT
% Objective: Use the model trained on 2 years of data (after removing 5% of outliers)
% and test on the remaining year's data
% DATA_PATH holds the path of the mat file i.e. the path of 'data' folder
% and the write_file_name has the name of the feature mat file (line 13 and 29 for the train years)
% for the test year the write_file_name is on line 68
close all;
fclose all;
clear all;
clc;

DATA_PATH = 'experiments/pitched_instrument_regression/dataPyin/';
write_file_name = 'middleAlto Saxophone2_Combined_2013';

% Check for existence of path for writing extracted features.
root_path = deriveRootPath();
full_data_path = [root_path DATA_PATH];

if(~isequal(exist(full_data_path, 'dir'), 7))
    error('Error in your file path.');
end

l = 3;
unionSet = [12,26,34,38];%[1;2;3;4;5;7;8;9;11;12;13;14;15;16;18;19;20;21;22;23;25;26;27;29;30;31;33;34;35;36;37;38;39;40;41;42;43;44;45;46];
delFeat = 1:46; delFeat(unionSet)=[];
  
load([full_data_path write_file_name]);
%features(:,delFeat)=[];
features1 =features;

% Average the assessments to get one label.
labels1 = labels(:,l); %labels(:,3),labels(:,5)

write_file_name = 'middleAlto Saxophone2_Combined_2015';
load([full_data_path write_file_name]);
%features(:,delFeat)=[];

features = [features; features1];
labels = labels(:,l); %labels(:,3),labels(:,5)
labels = [labels; labels1];

NUM_FOLDS = length(labels);
% remove top 5% outliers and test
[Rsq, S, p, r, predictions] = crossValidation(labels, features, NUM_FOLDS);
err=abs(labels-predictions);
[sort_err,idx_err]=sort(err,'descend');
new_features=features;
%new_labels=predictions;
% new_labels = labels;
loopLen = floor(0.05*length(labels));

for i=1:loopLen
    
    new_features(idx_err(1),:)=[];
    labels(idx_err(1)) = [];

    NUM_FOLDS=NUM_FOLDS-1;
    [Rsq, S, p, r, new_predictions] = crossValidation(labels, new_features, NUM_FOLDS);

    err=abs(labels-new_predictions);
    [sort_err,idx_err]=sort(err,'descend');

    fprintf(['\nResults complete.\nR squared: ' num2str(Rsq) ...
     '\nStandard error: ' num2str(S) '\nP value: ' num2str(p) ...
     '\nCorrelation coefficient: ' num2str(r) '\n']);
end

figure; plot(labels,new_predictions,'*'); xlabel('Test Labels'); ylabel('Prediction');
% training features from 2013
train_features = new_features;
train_labels = labels;
clear labels; clear features;

% test features from either 2014 or 2015
write_file_name = 'middleAlto Saxophone2_Combined_2014';
root_path = deriveRootPath();
full_data_path = [root_path DATA_PATH];
load([full_data_path write_file_name]);
%features(:,delFeat)=[];

test_features = features;
test_labels = labels(:,l);
clear labels; clear features;

% Normalize
[train_features, test_features] = NormalizeFeatures(train_features, test_features);
% feature truncation
% test_features(test_features >= 1) = 1;
% test_features(test_features <= 0) = 0;
% locations_truncated = (test_features >= 1) + (test_features <= 0);

% remove top 2 most truncated features
% countTruncation = sum(locations_truncated);
% [val,loc]=max(countTruncation);
% train_features(:,loc)=[];
% test_features(:,loc)=[];
% countTruncation(loc)=[];
% [val,loc]=max(countTruncation);
% train_features(:,loc)=[];
% test_features(:,loc)=[];

% Train the classifier and get predictions for the current fold.
svm = svmtrain(train_labels, train_features, '-s 4 -t 0 -q');
predictions = svmpredict(test_labels, test_features, svm, '-q');

predictions(predictions>1)=1;
predictions(predictions<0)=0;
[Rsq, S, p, r] = myRegEvaluation(test_labels, predictions);  
result_test = [r;p;Rsq;S];

fprintf(['\nResults complete.\nR squared: ' num2str(Rsq) ...
         '\nStandard error: ' num2str(S) '\nP value: ' num2str(p) ...
         '\nCorrelation coefficient: ' num2str(r) '\n']);

figure; plot(test_labels,predictions,'*'); xlabel('Test Labels'); ylabel('Prediction');