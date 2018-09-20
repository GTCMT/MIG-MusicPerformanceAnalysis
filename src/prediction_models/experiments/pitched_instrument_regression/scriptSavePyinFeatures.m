%% scriptSavePyinFeatures
% script to compute and save pYin features for middle school
% AltoSaxophone segment 2 recordings

band = 'symphonic';
inst = 'Alto Saxophone';
segment = 2;
num_nonscore = 24;
num_score = 22;

year = '2013';
getFeatureForSegmentPyin(band, inst, segment, year, num_nonscore);
getScoredFeatureForSegmentPyin(band, inst, segment, year, num_score);

year = '2014';
getFeatureForSegmentPyin(band, inst, segment, year, num_nonscore);
getScoredFeatureForSegmentPyin(band, inst, segment, year, num_score);

year = '2015';
getFeatureForSegmentPyin(band, inst, segment, year, num_nonscore);
getScoredFeatureForSegmentPyin(band, inst, segment, year, num_score);

% remove 1st label (corresponding to artistry for 2013 and 2014 data)
load('dataPyin/middleAlto Saxophone2_NonScore_2013.mat');
labels(:,1) = [];
save('dataPyin/middleAlto Saxophone2_NonScore_2013.mat', 'features', 'labels');
load('dataPyin/middleAlto Saxophone2_Score_2013.mat');
labels(:,1) = [];
save('dataPyin/middleAlto Saxophone2_Score_2013.mat', 'features', 'labels');

load('dataPyin/middleAlto Saxophone2_NonScore_2014.mat');
labels(:,1) = [];
save('dataPyin/middleAlto Saxophone2_NonScore_2014.mat', 'features', 'labels');
load('dataPyin/middleAlto Saxophone2_Score_2014.mat');
labels(:,1) = [];
save('dataPyin/middleAlto Saxophone2_Score_2014.mat', 'features', 'labels');

% combine features
load('dataPyin/middleAlto Saxophone2_NonScore_2013.mat');
features1 = features;
load('dataPyin/middleAlto Saxophone2_Score_2013.mat');
features = [features1, features];
save('dataPyin/middleAlto Saxophone2_Combined_2013.mat', 'features', 'labels');

load('dataPyin/middleAlto Saxophone2_NonScore_2014.mat');
features1 = features;
load('dataPyin/middleAlto Saxophone2_Score_2014.mat');
features = [features1, features];
save('dataPyin/middleAlto Saxophone2_Combined_2014.mat', 'features', 'labels');

load('dataPyin/middleAlto Saxophone2_NonScore_2015.mat');
features1 = features;
load('dataPyin/middleAlto Saxophone2_Score_2015.mat');
features = [features1, features];
save('dataPyin/middleAlto Saxophone2_Combined_2015.mat', 'features', 'labels');