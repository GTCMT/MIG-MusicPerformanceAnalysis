clear all;
close all;
clc;

% AV@GTCMT
% Objective: Get training and testing accuracy by dividing the data of all the
% years by diving data within each year into 3 parts. 2 parts are used for training and getting training
% accuracy while 1 part is used for testing for testing accuracy
% The features used were computed and stored as mat files (5% outlier
% removal was performed)

% Check for existence of path for writing extracted features.
DATA_PATH = 'experiments/pitched_instrument_regression/dataPyin/';
root_path = deriveRootPath();
full_data_path = [root_path DATA_PATH];
if(~isequal(exist(full_data_path, 'dir'), 7))
    error('Error in your file path.');
end

l = 1;
write_file_name = 'middleAlto Saxophone2_Combined_2013'; % features2015 labelM2015
load([full_data_path write_file_name]);
features2013 = features;
labelM2013 = labels(:,l);
write_file_name = 'middleAlto Saxophone2_Combined_2014'; % features2014 labelM2014
load([full_data_path write_file_name]);
features2014 = features;
labelM2014 = labels(:,l);
write_file_name = 'middleAlto Saxophone2_Combined_2015'; % features2013 labelM2013
load([full_data_path write_file_name]);
features2015 = features;
labelM2015 = labels(:,l);


NUM_FOLDS = 3; % training: start from single sample and go to length(labels);
% testing: each trained model is used to test all the test samples
% 3 folds, 2 for training and 1 for testing
div2013 = round(length(labelM2013)/NUM_FOLDS);
div2014 = round(length(labelM2014)/NUM_FOLDS);
div2015 = round(length(labelM2015)/NUM_FOLDS);

testing_data = [features2013(div2013+1:2*div2013,:); features2014(div2014+1:2*div2014,:); features2015(div2015+1:2*div2015,:)];
testing_label = [labelM2013(div2013+1:2*div2013,:); labelM2014(div2014+1:2*div2014,:); labelM2015(div2015+1:2*div2015,:)];

training_data = [features2013([1:div2013, 2*div2013+1]:end,:); features2014([1:div2014, 2*div2014+1]:end,:); features2015([1:div2015, 2*div2015+1]:end,:)];
training_label = [labelM2013([1:div2013, 2*div2013+1]:end,:); labelM2014([1:div2014, 2*div2014+1]:end,:); labelM2015([1:div2015, 2*div2015+1]:end,:)];



Rsq_test = zeros(length(training_label)-2,1);
S_test = Rsq_test;
p_test = S_test;
r_test = p_test;

Rsq_train = zeros(length(training_label)-2,1);
S_train = Rsq_train;
p_train = S_train;
r_train = p_train;

while NUM_FOLDS <= length(training_label)
    
    %   train on training and test on separate testing
    disp('test')
    [train_features, test_features] = NormalizeFeatures(training_data(1:NUM_FOLDS,:), testing_data);
    % % % % %% Train the classifier and get predictions for the current fold.
    svm = svmtrain(training_label(1:NUM_FOLDS), train_features, '-s 4 -t 0 -q');
    predictions = svmpredict(testing_label, test_features, svm, '-q');
    
    [Rsq_test(NUM_FOLDS-2), S_test(NUM_FOLDS-2), p_test(NUM_FOLDS-2), r_test(NUM_FOLDS-2)] = myRegEvaluation(testing_label, predictions);
    
    
    % % % % %% Train the classifier and get predictions for the current fold.
    %   within training data increasing folds
    disp('test')
    if NUM_FOLDS == length(training_label)
        [train_features, test_features] = NormalizeFeatures(training_data(1:NUM_FOLDS,:), training_data(1:NUM_FOLDS,:));
    else
        [train_features, test_features] = NormalizeFeatures(training_data(1:NUM_FOLDS,:), training_data(NUM_FOLDS+1:end,:));
    end
    
    svm1 = svmtrain(training_label(1:NUM_FOLDS), train_features, '-s 4 -t 0 -q');
    
    if NUM_FOLDS == length(training_label)
        predictions = svmpredict(training_label, test_features, svm, '-q');
        [Rsq_train(NUM_FOLDS-2), S_train(NUM_FOLDS-2), p_train(NUM_FOLDS-2), r_train(NUM_FOLDS-2)] = myRegEvaluation(training_label, predictions);
    else
        predictions = svmpredict(training_label(NUM_FOLDS+1:end), test_features, svm, '-q');
        [Rsq_train(NUM_FOLDS-2), S_train(NUM_FOLDS-2), p_train(NUM_FOLDS-2), r_train(NUM_FOLDS-2)] = myRegEvaluation(training_label(NUM_FOLDS+1:end), predictions);
    end
    
    NUM_FOLDS=NUM_FOLDS+1;
    
end
figure; plot([4:NUM_FOLDS],r_train,'*b'); hold on;plot([4:NUM_FOLDS],r_test,'or'); legend('train r value','test r value'); set(gca,'FontSize',16);
figure; plot([4:NUM_FOLDS],Rsq_train,'*b'); hold on;plot([4:NUM_FOLDS],Rsq_test,'or'); legend('train Rsq value','test Rsq value'); set(gca,'FontSize',16);
figure; plot([4:NUM_FOLDS],S_train,'*b'); hold on;plot([4:NUM_FOLDS],S_test,'or'); legend('train s value','test s value'); set(gca,'FontSize',16);
figure; plot([4:NUM_FOLDS],p_train,'*b'); hold on;plot([4:NUM_FOLDS],p_test,'or'); legend('train p value','test p value'); set(gca,'FontSize',16);

fprintf(['\nResults complete.\nR squared: ' num2str(Rsq_test(end)) ...
    '\nStandard error: ' num2str(S_test(end)) '\nP value: ' num2str(p_test(end)) ...
    '\nCorrelation coefficient: ' num2str(r_test(end)) '\n']);

