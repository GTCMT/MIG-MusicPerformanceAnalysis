%% Evaluation: train SVR model using selected data
% Chih-Wei Wu, GTCMT, 2016/01
clear all; close all; clc;
%% ==== 0) Add required folders ===========================================
addpath('../../../../../FBA2013/src/prediction_models/evaluation')

%% ==== 1) load data ======================================================
data_baseline = [];
% load /Users/cw/Documents/CW_FILES/02_Github_repo/GTCMT/FBA_cw_local_workspace/experiment_data/middle_baseline_2013.mat
% data_baseline = [data_baseline; summaryFeatures];
% load /Users/cw/Documents/CW_FILES/02_Github_repo/GTCMT/FBA_cw_local_workspace/experiment_data/middle_baseline_2014.mat
% data_baseline = [data_baseline; summaryFeatures];
load /Users/cw/Documents/CW_FILES/02_Github_repo/GTCMT/FBA_cw_local_workspace/experiment_data/middle_baseline_2015.mat
data_baseline = [data_baseline; summaryFeatures];

data_nonscoreDesigned = [];
% load /Users/cw/Documents/CW_FILES/02_Github_repo/GTCMT/FBA_cw_local_workspace/experiment_data/middle_rhythmic_2013.mat
% data_nonscoreDesigned = [data_nonscoreDesigned; summaryFeatures];
% load /Users/cw/Documents/CW_FILES/02_Github_repo/GTCMT/FBA_cw_local_workspace/experiment_data/middle_rhythmic_2014.mat
% data_nonscoreDesigned = [data_nonscoreDesigned; summaryFeatures];
load /Users/cw/Documents/CW_FILES/02_Github_repo/GTCMT/FBA_cw_local_workspace/experiment_data/middle_rhythmic_2015.mat
data_nonscoreDesigned = [data_nonscoreDesigned; summaryFeatures];

data_scoreDesigned = [];
load /Users/cw/Documents/CW_FILES/02_Github_repo/GTCMT/FBA_cw_local_workspace/experiment_data/middle_scoreFeat_2013.mat
data_scoreDesigned = [data_scoreDesigned; summaryFeatures];
load /Users/cw/Documents/CW_FILES/02_Github_repo/GTCMT/FBA_cw_local_workspace/experiment_data/middle_scoreFeat_2014.mat
data_scoreDesigned = [data_scoreDesigned; summaryFeatures];
% load /Users/cw/Documents/CW_FILES/02_Github_repo/GTCMT/FBA_cw_local_workspace/experiment_data/middle_scoreFeat_2015.mat
% data_scoreDesigned = [data_scoreDesigned; summaryFeatures];


% data = [data_scoreDesigned(:, 1:end-3), data_nonscoreDesigned];
% data = [data_baseline];
data = [data_scoreDesigned];
% data = [data_nonscoreDesigned];

%% ==== 2) Experiment setting =============================================
savepath = '/Users/cw/Documents/CW_FILES/02_Github_repo/GTCMT/FBA_cw_local_workspace/experiment_data/svrModel_middle_2013_2014_scoreFeat_musicality.mat';
dataID = 1:size(data, 1);
select = -2; %-2 musicality, -1 note acc, 0 rhythm acc
numLabels = 3;
%% ==== 3) Main loop ======================================================
trial      = floor( length(data)*0.05 );
outlierIdx = zeros(trial, 1);
outlierID = zeros(trial, 1);

for k = 1:trial
    [numSamples, numFeatures] = size(data);
    prediction = zeros(numSamples, 1);
    residual   = zeros(numSamples, 1);

    %leave one out loop
    for i = 1:numSamples

        %split the data
        choosen = data(i, :);
        ind = find([1:numSamples] ~= i);
        others  = data(ind, :);

        %select score category
        cate = numFeatures + select;
        trainData   = others(:, 1:(numFeatures-numLabels));
        trainLabels = others(:, cate); %hard-coded
        testData    = choosen(:, 1:(numFeatures-numLabels));
        testLabels  = choosen(:, cate);
        
        %== normalize training data
        trainData = trainData';
        [trainData, minList, maxList] = featureScaling(trainData);
        trainData = trainData';
        
        %== apply the same parameter, normalize testing data
        testData   = choosen(:, 1:(numFeatures-numLabels));
        testData   = testData';
        [testData] = featureScaling(testData, minList, maxList);
        testData   = testData';
        testLabels = choosen(:, cate);
        
        %train SVR model
        svrModel      = svmtrain(trainLabels, trainData, '-s 4 -t 0 -q');

        %test SVR model
        testResults   = svmpredict(testLabels, testData, svrModel, '-q');
        
        prediction(i) = testResults;
        residual(i)   = testResults - testLabels;

    end
    
    %evaluate
    y = data(:, cate);
    f = prediction;
    [Rsq(k), S(k), p(k), r(k)] = myRegEvaluation(y, f);
    
    %take out outliers
    [~, outlierIdx(k)] = max(abs(residual));
    outlierID(k) = dataID(outlierIdx(k));
    dataID(outlierIdx(k)) = [];
    
    ind2  = find([1:size(data,1)] ~= outlierIdx(k));
    data = data(ind2, :);
    fprintf('\n\n========Results=======\n');
    fprintf('The  p is %g \n', p(k));
    fprintf('The  r is %g \n', r(k));
    fprintf('The  R^2 is %g \n', Rsq(k));
    fprintf('The  S is %g \n', S(k));

end

%% ==== 4) Visualization
plot(r, 'r'); hold on;
plot(p, 'g'); hold on;
plot(S, 'b'); hold on;
plot(Rsq, 'k'); 
legend('r', 'p', 'S', 'Rsq');
xlabel(' # outlier removed');
ylabel(' values ');

figure;
scatter(y, f);
xlabel('ground truth');
ylabel('prediction');
axis([0 1 0 1]);

%% ==== 5) Save results
save(savepath, 'svrModel', 'minList', 'maxList');
fprintf('\n==== Mission Complete, saving file to the directory!====\n');

