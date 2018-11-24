clear all;
close all;
clc;

% AV@GTCMT
% Objective: Test if removing 5% of outliers is helping to improve the
% correlation. Code is run on the feature mat files stored in data folder
% in a leave one song out validation using SVR
% DATA_PATH holds the path of the mat file i.e. the path of 'data' folder
% and the write_file_name has the name of the feature mat file
% Specify the number of folds for the crossvalidation in NUM_FOLDS
% variable.

DATA_PATH = 'experiments/pitched_instrument_regression/data/';
write_file_name = 'AllDataScoreNonScore131415';

% Check for existence of path for writing extracted features.
root_path = deriveRootPath();
full_data_path = [root_path DATA_PATH];

if(~isequal(exist(full_data_path, 'dir'), 7))
    error('Error in your file path.');
end
  
load([full_data_path write_file_name]);

% % % To perform the same experiment with bag of features (standard audio features) plus the designed 
% features_designed=features;
% 
% DATA_PATH = 'experiments\pitched_instrument_regression\ICMPC_baseline_altosax_middleschool\';
% write_file_name = 'middleAlto Saxophone2';
% 
% load([full_data_path write_file_name]);
% features=[features,features_designed];

Rsq_before = zeros(1,4);
S_before = zeros(1,4);
p_before = zeros(1,4);
r_before = zeros(1,4);
p_s_before = zeros(1,4);
r_s_before = zeros(1,4);

Rsq_all = zeros(1,4);
S_all = zeros(1,4);
p_all = zeros(1,4);
r_all = zeros(1,4);
p_s_all = zeros(1,4);
r_s_all = zeros(1,4);

Rsq_outliers = zeros(1,4);
S_outliers = zeros(1,4);
p_outliers = zeros(1,4);
r_outliers = zeros(1,4);

prediction_arr = [];

for l = 1:4
% Average the assessments to get one label.
labels_sel = labels(:,l); %labels(:,3),labels(:,5)
NUM_FOLDS = length(labels_sel);

% consider the PCA transformed features with 95% variability 
% [row,col]=size(features);
% dummy = ones(1,col);
% [normFeat, dum] = NormalizeFeatures(features,dummy);
% [coeff,score,latent,tsquared,explained,mu]=pca(normFeat);
% for i =1:length(explained)
%     if sum(explained(1:i))>=95
%         featNum=i;
%         break;
%     end
% end

% remove 5% outliers
[Rsq, S, p, r, predictions] = crossValidation(labels_sel, features, NUM_FOLDS);
% for PCA
% [Rsq, S, p, r, predictions] = crossValidation(labels, score(:,1:featNum), NUM_FOLDS);
err=abs(labels_sel-predictions);
[sort_err,idx_err]=sort(err,'descend');
% new_features=features;

new_features= features; %score(:,1:featNum);
new_labels = labels_sel;
lenLoop = floor(0.05*length(labels_sel));
dataID = 1:length(new_labels);

for i=1:lenLoop

    outlierIdx(i) = idx_err(1);
%     outlierIdx(i) = dataID(outlierIdx(i));
    dataID(outlierIdx(i)) = [];
   
    new_features(idx_err(1),:)=[];
    new_labels(idx_err(1)) = [];

    NUM_FOLDS=NUM_FOLDS-1;
    [Rsq, S, p, r, new_predictions] = crossValidation(new_labels, new_features, NUM_FOLDS);

    err=abs(new_labels-new_predictions);
    [sort_err,idx_err]=sort(err,'descend');

    if i == lenLoop
        fprintf(['\nResults complete.\nR squared: ' num2str(Rsq) ...
        '\nStandard error: ' num2str(S) '\nP value: ' num2str(p) ...
        '\nCorrelation coefficient: ' num2str(r) '\n']);
    end
end

[r_s_before(l), p_s_before(l)] = corr(new_labels, new_predictions, 'type', 'Spearman');
Rsq_before(l) = Rsq;
S_before(l)=S;
p_before(l)=p;
r_before(l)=r;

test_remaining = features(outlierIdx,:);
test_labels = labels_sel(outlierIdx,:);
[train_features, test_features] = NormalizeFeatures(new_features, test_remaining);

% Train the classifier and get predictions for the current fold.
svm = svmtrain(new_labels, train_features, '-s 4 -t 0 -q');
predictions = svmpredict(test_labels, test_features, svm, '-q');

final_predictions(dataID,1) = new_predictions;
final_predictions(outlierIdx,1) = predictions;

final_predictions(final_predictions>1)=1;
final_predictions(final_predictions<0)=0;
[Rsq, S, p, r] = myRegEvaluation(labels_sel, final_predictions);  

prediction_arr = [prediction_arr,final_predictions];

[r_s_all(l), p_s_all(l)] = corr(labels_sel, final_predictions, 'type', 'Spearman');
Rsq_all(l) = Rsq;
S_all(l)=S;
p_all(l)=p;
r_all(l)=r;

% correlation of just the outliers
[Rsq, S, p, r] = myRegEvaluation(test_labels, predictions);  
Rsq_outliers(l) = Rsq;
S_outliers(l)=S;
p_outliers(l)=p;
r_outliers(l)=r;

end

FinalResults = [r_all;p_all;r_s_all;p_s_all;Rsq_all;S_all];  
predictions = prediction_arr;
%save('predictions_allTogether','predictions');

