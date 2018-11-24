clear all;
close all;
clc;

% AV@GTCMT
% Objective: Apply principal component analysis (pca) to features and see inspect the correlation coefficient value.
% The number of principal components considered is varied by considering the cumulative variability of the transformed features. 
% Correlation values are stored after performing leave one song out validation for SVR
% Additionally, 5% outlier removal is carried out.
% 
% The DATA_PATH holds the path of the mat file i.e. the 'data' folder
% and the write_file_name has the name of the mat file
% Specify the number of folds for the crossvalidation in NUM_FOLDS
% variable. 

% mat file path and the mat file name
DATA_PATH = 'experiments/pitched_instrument_regression/data/';
write_file_name = 'middleAlto Saxophone2_designedFeatures_2014';

% Check for existence of path for writing extracted features.
root_path = deriveRootPath();
full_data_path = [root_path DATA_PATH];

if(~isequal(exist(full_data_path, 'dir'), 7))
    error('Error in your file path.');
end
  
load([full_data_path write_file_name]);

% Choose the label on which assessment is needed.
labels = labels(:,2); %labels(:,3),labels(:,5)
% select the size of the data to perform leave one file out validation
NUM_FOLDS = length(labels);

% normalize the features and compute their pca
[row,col]=size(features);
dummy = ones(1,col);
[normFeat, dum] = NormalizeFeatures(features,dummy);
[coeff,score,latent,tsquared,explained,mu]=pca(normFeat);

% initialize the variables
pcaCutoff = 30:5:100;
iter = 1;
RsqFinal = zeros(1,length(pcaCutoff));
SFinal = zeros(1,length(pcaCutoff));
pFinal = zeros(1,length(pcaCutoff));
rFinal = zeros(1,length(pcaCutoff));

% vary the number of features based on how much variablity is contained in the transformed features
for pc=30:5:100  
%     decide how many transformed features are to be considered
    for j =1:length(explained)
        if round(sum(explained(1:j)))>=pc
            featNum=j;
            break;
        end
    end

    if pc == 100
        featNum = length(explained);
    end
    
    % for PCA
    NUM_FOLDS = length(labels);
    [Rsq, S, p, r, predictions] = crossValidation(labels, score(:,1:featNum), NUM_FOLDS);
    
    err=abs(labels-predictions);
    [sort_err,idx_err]=sort(err,'descend');
    % for PCA
    new_features=score(:,1:featNum);
    new_labels = labels;

    for i=1:floor(0.05*length(labels))

        new_features(idx_err(1),:)=[];
        new_labels(idx_err(1)) = [];

        NUM_FOLDS = length(new_labels);
        [Rsq, S, p, r, new_predictions] = crossValidation(new_labels, new_features, NUM_FOLDS);

        err=abs(new_labels-new_predictions);
        [sort_err,idx_err]=sort(err,'descend');

    end
  RsqFinal(iter) = Rsq;
  SFinal(iter) = S;
  pFinal(iter) = p;
  rFinal(iter) = r;

  iter = iter+1;
end

figure; plot(pcaCutoff,RsqFinal,'*-'); hold on; plot(pcaCutoff,SFinal,'*-r'); hold on; plot(pcaCutoff,pFinal,'*-k'); hold on; plot(pcaCutoff,rFinal,'*-m');

