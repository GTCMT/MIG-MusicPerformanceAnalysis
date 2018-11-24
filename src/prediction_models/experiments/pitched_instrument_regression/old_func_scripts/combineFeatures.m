%% script for combining features

cd('dataPyin/')
load('middleAlto Saxophone2_NonScore_2015.mat');
features1 = features;
load('middleAlto Saxophone2_Score_2015.mat');
features = [features, features1];
save('middleAlto Saxophone2_Combined_2015.mat', 'features', 'labels');

load('middleAlto Saxophone2_NonScore_2014.mat');
features1 = features;
load('middleAlto Saxophone2_Score_2014.mat');
features = [features, features1];
save('middleAlto Saxophone2_Combined_2014.mat', 'features', 'labels');

load('middleAlto Saxophone2_NonScore_2013.mat');
features1 = features;
load('middleAlto Saxophone2_Score_2013.mat');
features = [features, features1];
save('middleAlto Saxophone2_Combined_2013.mat', 'features', 'labels');

cd('../')