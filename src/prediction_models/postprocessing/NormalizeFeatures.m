%% Feature normalization
% AV@GTCMT, 2005
% [featr_train, featr_test] = NormalizeFeatures(train, test)
% objective: Whiten data by subtracting the mean and dividing by the 
%            standard deviation. Mean and standard deviation are computed 
%            from the training data but whitening is applied to both the 
%            training and the test data.
%
% train: NxM float array, training data, N -> number training data, 
%        M -> number features.
% test: LxM float array, test data, L -> number test data, 
%       M -> number features.
% featr_train: NxM float array, normalizes training data, 
%              N -> number training data, M -> number features.
% featr_test: LxM float array, normalized test data, L -> number test data, 
%             M -> number features.

function [featr_train, featr_test] = NormalizeFeatures(train, test)

% Preallocate memory.
num_features = size(train, 2);
num_train_data = size(train,1);
num_test_data = size(test,1);
featr_train = zeros(num_train_data, num_features);
featr_test = zeros(num_test_data, num_features);

% One feature at at time.
for (feature_idx = 1:num_features)
  cur_data = train(:, feature_idx);
  
  % If you run into any nan values, ignore them while calculating min value
  bad_data = cur_data(isnan(cur_data));
  if(~isempty(bad_data))
    warning(['Some nans exist in your data at feature ' ...
             num2str(feature_idx)]);
  end
  clean_data = cur_data(~isnan(cur_data));
  
  % Calculate mean and standard deviation.
  feature_min = min(clean_data);
  feature_max = max(clean_data);

  % In this case, all feature values are the same. 
  if(feature_max-feature_min == 0) 
      warning(['Max of feature ' num2str(feature_idx) ...
             ' is zero.']);
%       Whiten data.
      featr_train(:,feature_idx) = (train(:, feature_idx) - feature_min) / ...
                                   (realmin);
      featr_test(:,feature_idx) = (test(:, feature_idx) - feature_min) / ...
                                   (realmin);
  else

      % Whiten data.
      featr_train(:,feature_idx) = (train(:, feature_idx) - feature_min) / ...
                                   (feature_max-feature_min);
      featr_test(:,feature_idx) = (test(:, feature_idx) - feature_min) / ...
                                   (feature_max-feature_min);
end

end

