%% Extract baseline features for snare etude regression analysis
% Chih-Wei Wu, GTCMT, 2016/10
clear all; clc; close all;


%% ==== 0) Add required folders ===========================================
addpath('../../../../../FBA2013/src/prediction_models/scanning')
addpath('../../../../../FBA2013/src/prediction_models/feature_extraction/')
addpath('../../../../../FBA2013/src/prediction_models/feature_extraction/StandardFeatures')
addpath('../../../../../FBA2013/src/prediction_models/')


%% ==== 1) Enter year to be extracted =================================
year_option = '2015';

%% ==== 2) get student IDs and source path ============================
[musicality, noteAccuracy, rhythmAccuracy] ...
    = textread('/Users/cw/Documents/CW_FILES/04_Datasets/Database2/FBA middle/Grade/snareEtude_middle_2015.txt');
band_option = 'middle';
instrument_option = 'Percussion';
[student_ids] = scanStudentIds(band_option, instrument_option, year_option);
if strcmp(year_option, '2013')
    sourcefolder = '/Volumes/CW_MBP15/Datasets/FBA/2013-2014/middleschoolscores/';
    annfolder = strcat('../../../../../FBA2013/FBA2013/', 'middleschoolscores/');
elseif strcmp(year_option, '2014')
    sourcefolder = '/Volumes/CW_MBP15/Datasets/FBA/2014-2015/middleschool/';
    annfolder = strcat('../../../../../FBA2013/FBA2014/', 'middleschool/');    
elseif strcmp(year_option, '2015')
    sourcefolder = '/Volumes/CW_MBP15/Datasets/FBA/2015-2016/middleschool/';
    annfolder = strcat('../../../../../FBA2013/FBA2015/', 'middleschool/');
end
savepath = ['/Users/cw/Documents/CW_FILES/02_Github_repo/GTCMT/FBA_cw_local_workspace/experiment_data/middle_baseline_', year_option, '.mat'];

%% ==== 3) Main loop for all tracks
%set parameters
windowSize = 2^nextpow2(1024); 
hopSize = round((1/4)*windowSize); 
w = hann(windowSize); %hann window

%initialization
trackNum = length(student_ids);
numFeatures = 68;
summaryFeatures = zeros(numFeatures, trackNum); %hard-coded feature number


tic;
for i = 1:trackNum   
    %============== Signal input ==============
    %load individual data name from the folder
    filename = strcat(num2str(student_ids(i)), '.', 'mp3');
    annfilename = strcat(num2str(student_ids(i)), '_segment.', 'txt');
    sourcepath = strcat(sourcefolder, num2str(student_ids(i)), '/', filename);
    annpath = strcat(annfolder, num2str(student_ids(i)), '/', annfilename);
    fprintf('Working on data #%g...\n',i);
    fprintf('Current audio file name      = %s \n', sourcepath);
    fprintf('Current annotation file name = %s \n', annpath);
    

    %load wave file
    [x, fs] = audioread(sourcepath); 
    x = resample(x, 44100, fs);
    x = mean(x,2); %down-mixing   
    [col1, col2] = textread(annpath,'%s%s','headerlines',1);
    
    %==== read annotaions
    onsets = zeros(length(col1), 1);
    durations = zeros(length(col2), 1);
    for j = 1:length(col1)
        onsets(j) = str2double(col1{j});
        durations(j) = str2double(col2{j});
    end

    audioFrames = ceil((length(x) - windowSize)/hopSize + 1);
    onsetInFrames = round(onsets./(hopSize/fs)); 
    durationInFrames = round(durations./(hopSize/fs));
        
    for k = 2:2%numParts
        if durationInFrames(k) < 3          
            break;
        end
        
        %Select analysis region
        timeStartVector(1, k) = round(onsets(k)*fs); %start index (odd number)
        timeEndVector(1, k)   = round(onsets(k)*fs + durations(k)*fs); %start index + duration
        if timeEndVector(1,k) > length(x)
            timeEndVector(1,k) = length(x);
        end
        timeRegion = x(timeStartVector(1,k):timeEndVector(1,k));
        
        %scaling the waveform
        maxValue = max(abs(timeRegion));
        timeRegion = timeRegion/maxValue;
               
        %============== Feature Extraction ==============         
        aggNum = 43;
        
        %STFT
        X = spectrogram(timeRegion, windowSize, (windowSize - hopSize), windowSize, fs);
        X = abs(X);
        [m, n] = size(X);

        aggFrame = floor(n/aggNum);

        %Spectral features
        SCentroid = FeatureSpectralCentroid(X, fs);
        SRolloff  = FeatureSpectralRolloff(X, fs, 0.85);
        SFlux     = FeatureSpectralFlux(X, fs);
        SMfcc = FeatureSpectralMfccs(X, fs);

        %Temporal features
        TZC = FeatureTimeZeroCrossingRate(timeRegion, windowSize, hopSize, fs);
        TZC = TZC(:, 1:size(X, 2));

        STFeatures = [SCentroid; SRolloff; SFlux; TZC; SMfcc];
        STFeatures_mean = zeros(size(STFeatures, 1), aggFrame);
        STFeatures_std = zeros(size(STFeatures, 1), aggFrame);

        %feature aggregation
        for v = 1:aggFrame
            istart = (v - 1)*aggNum + 1;
            iend = istart + aggNum - 1;
            STFeatures_mean(:, v) = mean(STFeatures(:, istart:iend), 2);
            STFeatures_std(:, v) = std(STFeatures(:, istart:iend), 0, 2);   
        end

        %combine features into matrix
        featureMatrix_pre = [STFeatures_mean; STFeatures_std];

        %one track one feature vector
        featureMatrix = [mean(featureMatrix_pre, 2); std(featureMatrix_pre, [], 2)];
        
        summaryFeatures(:, i) = featureMatrix;
    end
        
end
toc;

%% ==== 4) Score normalization ============================================
%reserve non-zero instances
pIdx = find(musicality ~= 0 & noteAccuracy ~= 0 & rhythmAccuracy ~= 0);
summaryFeatures = summaryFeatures(:, pIdx);
musicality = musicality(pIdx);
noteAccuracy = noteAccuracy(pIdx);
rhythmAccuracy = rhythmAccuracy(pIdx);
%normalize by max scores
summaryFeatures = summaryFeatures';
musicality = musicality ./ 20;
noteAccuracy = noteAccuracy ./ 10;
rhythmAccuracy = rhythmAccuracy ./ 10;


%% ==== 5) Save extracted features ========================================
summaryFeatures = [summaryFeatures, musicality, noteAccuracy, rhythmAccuracy];
save(savepath, 'summaryFeatures');
fprintf('\n==== Mission Complete, saving file to the directory!====\n');
