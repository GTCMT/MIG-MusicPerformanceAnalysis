close all
clear all
clc

dataread = importdata('/Users/apple/Desktop/TONAS/TONAS-Metadata-mod.txt');
i = 1;
filenames = cell(length(dataread)-1,1);
for i=2:length(dataread)
    for j=1:length(dataread{i,1})
       if mod(j,2) == 0 
           filenames(i-1) = strcat(filenames(i-1),dataread{i,1}(j)); 
       end
    end
end

wSize = 1024;
hop = 512;
path = '/Users/apple/Desktop/TONAS/';
txtpath = '.f0.Corrected';
len_trg_set = length(filenames);

errCent_rms_wav = zeros(len_trg_set,1);
fn_wav = zeros(len_trg_set,1);
fp_wav = zeros(len_trg_set,1);
errCent_rms_acf = zeros(len_trg_set,1);
fn_acf = zeros(len_trg_set,1);
fp_acf = zeros(len_trg_set,1);


for i = 1:1
    i
    name = filenames{i,1};
    name2 = filenames{i,1}(1:length(filenames{i,1})-4);
    wavfilepath = strcat(path,name);
    txtfilepath = strcat(path,name2,txtpath);
    [x, fs] = audioread(wavfilepath);
    annotation_data = dlmread(txtfilepath);
    annotation = annotation_data(:,3);
    
    %estimation_wav = estimatePitchAlgos(x,fs,hop, wSize,'wav');
    %estimation_acf = estimatePitchAlgos(x,fs,hop, wSize,'acf');
    estimation_yin = estimatePitchAlgos(x,fs,hop, wSize,'yin');
    %[errCent_rms_wav(i), fn_wav(i), fp_wav(i)] = myEvaluation(estimation_wav, annotation);
    %[errCent_rms_acf(i), fn_acf(i), fp_acf(i)] = myEvaluation(estimation_acf, annotation);
    [errCent_rms_yin, fn_yin, fp_yin] = myEvaluation(estimation_yin, annotation);
    
end
