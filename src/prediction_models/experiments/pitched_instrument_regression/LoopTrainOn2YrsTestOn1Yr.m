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

DATA_PATH = 'experiments/pitched_instrument_regression/data/';
% delFeat = [2,3,4,6,7,14,1,9,21,29,31,32,34,35,36,39,42,45]; %[24]; %[10:17,24]; %9, 12, 17, 21, % 23:30 amp features or 10:17

% Check for existence of path for writing extracted features.
root_path = deriveRootPath();
full_data_path = [root_path DATA_PATH];

if(~isequal(exist(full_data_path, 'dir'), 7))
    error('Error in your file path.');
end

results_mat_train = [];
results_mat_test = [];
FinalPredictions = [];

yr1 = 3; yr2 = 4; yr3 = 5;
for l = 2:5
    
write_file_name = ['Score_middleAltoSaxophone_segment2_pitchCrctd_featCrctd_201' num2str(yr1)];

% Check for existence of path for writing extracted features.
root_path = deriveRootPath();
full_data_path = [root_path DATA_PATH];

if(~isequal(exist(full_data_path, 'dir'), 7))
    error('Error in your file path.');
end
  
load([full_data_path write_file_name]);
% features(:,14)=features(:,14)./features(:,23);
% features(:,delFeat)=[];

features1 =features;

% Average the assessments to get one label.
labels1 = labels(:,l); %labels(:,3),labels(:,5)

write_file_name = ['Score_middleAltoSaxophone_segment2_pitchCrctd_featCrctd_201' num2str(yr2)];
load([full_data_path write_file_name]);
% features(:,14)=features(:,14)./features(:,23);
% features(:,delFeat)=[];

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

%     fprintf(['\nResults complete.\nR squared: ' num2str(Rsq) ...
%      '\nStandard error: ' num2str(S) '\nP value: ' num2str(p) ...
%      '\nCorrelation coefficient: ' num2str(r) '\n']);
end

result_train = [r;p;Rsq;S];
results_mat_train = [results_mat_train,result_train];

% figure; plot(labels,new_predictions,'*'); xlabel('Test Labels'); ylabel('Prediction');
% training features from 2013
train_features = new_features;
train_labels = labels;
clear labels; clear features;

% test features from either 2014 or 2015
write_file_name = ['Score_middleAltoSaxophone_segment2_pitchCrctd_featCrctd_201' num2str(yr3)];
root_path = deriveRootPath();
full_data_path = [root_path DATA_PATH];
load([full_data_path write_file_name]);
% features(:,14)=features(:,14)./features(:,23);
% features(:,delFeat)=[];

test_features = features;
test_labels = labels(:,l-1);
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
[r_s, p_s] = corr(test_labels, predictions, 'type', 'Spearman');

FinalPredictions=[FinalPredictions,predictions];

result_test = [r;p;r_s; p_s; Rsq;S];
results_mat_test = [results_mat_test,result_test];

fprintf(['\nResults complete.\nR squared: ' num2str(Rsq) ...
         '\nStandard error: ' num2str(S) '\nP value: ' num2str(p) ...
         '\nCorrelation coefficient: ' num2str(r) '\n']);

% figure; plot(test_labels,predictions,'*'); xlabel('Test Labels'); ylabel('Prediction');
end

save(['predictions_E3_201' num2str(yr3)],'FinalPredictions');

% xlswrite('result_train_baseline_2013_14', results_mat_train);
% xlswrite('result_test_baseline_2015', results_mat_test);