%% script toget baseline results for DL project
close all;
clear all;
clc;

%% specify configuration
l = 1; % 1: musicality, 2: note accuracy, 3: rhythmic accuracy, 4: tone quality
segment_option = 4;
band_options = {'symphonic'};
instrument_options = {'Alto Saxophone','Bb Clarinet', 'Flute'};
year_options = {'2013', '2014', '2015'};
feature_options = {'std', 'nonscore'};
pitch_option = 'pyin'; % options are 'pyin' and 'acf'
quick = 0;
if strcmp(pitch_option, 'pyin') == 1
    data_folder = 'dataPyin/';
else
    data_folder = 'data/';
end

%% read and concatenate scale feature matrices

band = band_options{1};
disp(band);
fmat = [];
sid_scale = [];
year_cell = {};
inst_cell = {};
count = 0;
for i = 1:length(instrument_options)
    instrument = instrument_options{i};
    disp(instrument);
    for y = 1:length(year_options)
        year = year_options{y};
        disp(year);
        concat_feat = [];
        for f = 1:length(feature_options)
            feature = feature_options{f};
            disp(feature);
            feature_filestring = [data_folder, band, instrument, ...
                num2str(segment_option), '_', feature, '_', year, ...
                '', '.mat'];
            load(feature_filestring);
            concat_feat = [concat_feat, features];
        end
        fmat = [fmat; concat_feat];
        sid_scale = [sid_scale; student_ids];
        y_tmp = cell(length(student_ids), 1);
        y_tmp(:) = {year};
        year_cell = [year_cell; y_tmp];
    end
    num_new = length(sid_scale) - count;
    i_tmp = cell(num_new, 1);
    i_tmp(:) = {instrument};
    inst_cell = [inst_cell; i_tmp];
    count = length(sid_scale);
end


%% read and concatenate technical exercise score labels
segment_option = 2;
feature_options = {'nonscore'};
band = band_options{1};
disp(band);
lab = [];
sid_tech = [];
for i = 1:length(instrument_options)
    instrument = instrument_options{i};
    disp(instrument);
    for y = 1:length(year_options)
        year = year_options{y};
        disp(year);
        feature = feature_options{1};
        disp(feature);
        feature_filestring = [data_folder, band, instrument, ...
                num2str(segment_option), '_', feature, '_', year, ...
                '', '.mat'];
        load(feature_filestring);
        lab = [lab; labels];
        sid_tech = [sid_tech; student_ids];
    end
end

%% find intersection between student_ids
[~, scale_idxs, tech_idxs] = intersect(sid_scale, sid_tech);
rng(0,'twister');
features = fmat(scale_idxs, :);
s_ids = sid_scale(scale_idxs);
labels = lab(tech_idxs, l);
years = year_cell(scale_idxs);
instruments = inst_cell(scale_idxs);

%% run the cross validation on this set
n_fold = 10;
num_repeats = 10;
num_students = length(features);
Rsq = zeros(1, num_repeats);
S = zeros(1, num_repeats);
p = zeros(1, num_repeats);
r = zeros(1, num_repeats);
preds = zeros(num_students, num_repeats);
for i=1:num_repeats
    [Rsq(i), S(i), p(i), r(i), preds(:, i)] = ... 
        crossValidation(labels, features, n_fold);
end

disp(mean(Rsq));
disp(mean(S));
disp(mean(p));
disp(mean(r));
mean_pred = mean(preds, 2);
a = table(s_ids, instruments, years, labels, mean_pred, features);
