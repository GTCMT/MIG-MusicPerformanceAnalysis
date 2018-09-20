%% scriptSaveAcfFeatures
% script to compute and save acf features for middle school
% AltoSaxophone segment 2 recordings

band = 'middle';
inst = 'Alto Saxophone';
segment = 2;
num_nonscore = 24;
num_score = 22;

year = '2013';
getFeatureForSegment(band, inst, segment, year, num_nonscore);
getScoredFeatureForSegment(band, inst, segment, year, num_score);

year = '2014';
getFeatureForSegment(band, inst, segment, year, num_nonscore);
getScoredFeatureForSegment(band, inst, segment, year, num_score);

year = '2015';
getFeatureForSegment(band, inst, segment, year, num_nonscore);
getScoredFeatureForSegment(band, inst, segment, year, num_score);

% remove 1st label (corresponding to artistry for 2013 and 2014 data)
load('data/middleAlto Saxophone2_NonScore_2013.mat');
labels(:,1) = [];
save('data/middleAlto Saxophone2_NonScore_2013.mat', 'features', 'labels');
load('data/middleAlto Saxophone2_Score_2013.mat');
labels(:,1) = [];
save('data/middleAlto Saxophone2_Score_2013.mat', 'features', 'labels');

load('data/middleAlto Saxophone2_NonScore_2014.mat');
labels(:,1) = [];
save('data/middleAlto Saxophone2_NonScore_2014.mat', 'features', 'labels');
load('data/middleAlto Saxophone2_Score_2014.mat');
labels(:,1) = [];
save('data/middleAlto Saxophone2_Score_2014.mat', 'features', 'labels');

% combine features
load('data/middleAlto Saxophone2_NonScore_2013.mat');
features1 = features;
load('data/middleAlto Saxophone2_Score_2013.mat');
features = [features1, features];
save('data/middleAlto Saxophone2_Combined_2013.mat', 'features', 'labels');

load('data/middleAlto Saxophone2_NonScore_2014.mat');
features1 = features;
load('data/middleAlto Saxophone2_Score_2014.mat');
features = [features1, features];
save('data/middleAlto Saxophone2_Combined_2014.mat', 'features', 'labels');

load('data/middleAlto Saxophone2_NonScore_2015.mat');
features1 = features;
load('data/middleAlto Saxophone2_Score_2015.mat');
features = [features1, features];
save('data/middleAlto Saxophone2_Combined_2015.mat', 'features', 'labels');