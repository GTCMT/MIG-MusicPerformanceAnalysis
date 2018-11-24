clear all;
close all;
clc;

% AV@GTCMT
% Objective: To perform feature selection using forward and backward
% feature selection procedure. Maximum accuracy at each feature combination
% is plotted in the end.

DATA_PATH = 'experiments/pitched_instrument_regression/data/';
write_file_name = 'LatestScoreNonScoreConcat_2014';

% Check for existence of path for reading stored features and labels.
root_path = deriveRootPath();
full_data_path = [root_path DATA_PATH];

if(~isequal(exist(full_data_path, 'dir'), 7))
    error('Error in your file path.');
end
  
% delFeat = [24];
l1 = 2;
l2=1;
l3 = 2;
% select the size of the data to perform leave one file out validation
load([full_data_path write_file_name]);
% features(:,delFeat)=[];
features1 = features;
labels1 = labels(:,l1:l1+3);

write_file_name = 'LatestScoreNonScoreConcat_2015';
load([full_data_path write_file_name]);
% features(:,delFeat)=[];
train_features = [features1;features];
train_labels = [labels1;labels(:,l2:l2+3)];

write_file_name = 'LatestScoreNonScoreConcat_2013';
load([full_data_path write_file_name]);
% features(:,delFeat)=[];
test_features = features;
test_labels = labels(:,l3:l3+3);

[NUM_FOLDS,categry] = size(test_labels);
[numStu,numFeat]=size(test_features);

Rsq_allFeat=zeros(numFeat,categry);
S_allFeat=zeros(numFeat,categry);
p_allFeat=zeros(numFeat,categry);
r_allFeat=zeros(numFeat,categry);

for i = 1:numFeat
    for j = 1:categry
        % Evaluate model using cross validation.
        [train_norm, test_norm] = NormalizeFeatures(train_features(:,i), test_features(:,i));
        svm = svmtrain(train_labels(:,j), train_norm, '-s 4 -t 0 -q');
        predictions = svmpredict(test_labels(:,j), test_norm, svm, '-q');
        predictions(predictions>1)=1;
        predictions(predictions<0)=0;
        [Rsq_allFeat(i,j), S_allFeat(i,j), p_allFeat(i,j), r_allFeat(i,j)] = myRegEvaluation(test_labels(:,j), predictions);
    end
end

figure;
hold on;
for i = 1:22
    plot(r_allFeat(i,:)+i-1,'*');
end
hold off;

figure;
hold on;
for i = 23:numFeat
    plot(r_allFeat(i,:)+i-23,'*');
end
hold off;

