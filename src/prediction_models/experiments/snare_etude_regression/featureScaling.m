%% feature scaling
% Chih-Wei Wu, 2013/09, GTCMT
% objective : scale features to range of 0~1
% input : vFeatures = m*n feature matrix
% output: vFeaturesN = m*n normalized feature matrix
%         minList = min scalar for each feature
%         maxList = max scalar for each feature
% usage 1 : 
% vFeatureS = featureScaling(vFeatures, minList, maxList)
%
% usage 2 : 
% [vFeatureS, minList, maxList] = featureScaling(vFeatures)

function [vFeaturesS, varargout] = featureScaling(vFeatures, varargin )

[featureNum, dataNum] = size(vFeatures);
vFeaturesS = zeros(featureNum, dataNum);

if nargin == 1
    %fprintf('Input argument number = %d\n', nargin);
    %initialization
    minList = zeros(featureNum,1);
    maxList = zeros(featureNum,1);
    
    for i = 1:featureNum
       minList(i) = min(vFeatures(i, :));
       maxList(i) = max(vFeatures(i, :));
       vFeaturesS(i,:) = (vFeatures(i,:) - minList(i))./(maxList(i) - minList(i) + realmin);
    end
    varargout = {minList, maxList};
    
elseif nargin == 3
    %fprintf('Input argument number = %d\n', nargin);
    minList = varargin{1};
    maxList = varargin{2};
    assert(length(minList) == length(maxList));
    assert(length(minList) == size(vFeatures, 1));
    
    for i = 1:featureNum
       vFeaturesS(i,:) = (vFeatures(i,:) - minList(i))./(maxList(i) - minList(i) + realmin);
    end
     
else
    fprintf('Wrong input argument number!\n');
    
end

