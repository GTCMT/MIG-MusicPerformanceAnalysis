% Feature normalization (z-score)
% objective : normalize features
% reference : Introduction to audio content analysis p.65
% input : vFeatures = m*n feature matrix
% output: vFeaturesN = m*n normalized feature matrix
%         avgList = normalization mean
%         stdList = normalization std
% usage 1 : 
% vFeatureN = featureNormalization(vFeatures, avgList, stdList)
%
% usage 2 : 
% [vFeatureN, avgList, stdList] = featureNormalization(vFeatures)

function [vFeaturesN, varargout] = featureNormalization2(vFeatures, varargin )

[featureNum, dataNum] = size(vFeatures);
vFeaturesN = zeros(featureNum, dataNum);

if nargin == 1
    fprintf('Input argument number = %d\n', nargin);
    %need to find mean & std
    %initialization
    avgList = zeros(featureNum,1);
    stdList = zeros(featureNum, 1);
    
    for i = 1:featureNum

       avgList(i) = mean(vFeatures(i, :));
       stdList(i) = std(vFeatures(i, :));
       vFeaturesN(i, :) = (vFeatures(i,:) - avgList(i))/stdList(i);
    end
    varargout = {avgList, stdList};
    
elseif nargin == 3
    %applied input mean & std
    avgList = varargin{1};
    stdList = varargin{2};
    assert(length(avgList) == length(stdList));
    assert(length(avgList) == size(vFeatures, 1));
    for i = 1:featureNum
       vFeaturesN(i, :) = (vFeatures(i,:) - avgList(i))/stdList(i);
    end
     
else
    fprintf('Wrong input argument number!\n');
    
end

