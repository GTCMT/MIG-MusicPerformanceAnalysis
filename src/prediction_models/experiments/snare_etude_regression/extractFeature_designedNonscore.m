%% Extract non-score designed features for snare etude regression analysis     
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
numFeatures = 18;
summaryFeatures = zeros(numFeatures, trackNum); %hard-coded feature number


tic;
for i = 1:trackNum   
    %============== Signal input ==============
    %load individual data name from the folder
    filename = strcat(num2str(student_ids(i)), '.', 'mp3');
    annfilename = strcat(num2str(student_ids(i)), '_segment.', 'txt');
    sourcepath = strcat(sourcefolder, num2str(student_ids(i)), '/', filename);
    annpath = strcat(annfolder, num2str(student_ids(i)), '/', annfilename);
    fprintf('\nWorking on data #%g...\n',i);
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
        maxValue = max(abs(timeRegion));
        timeRegion = timeRegion/maxValue;
        [~, ~, timeRegionAmpSquare] = LoudnessEBU_m(timeRegion, fs);
        timeRegionInDB = 10 * log10(timeRegionAmpSquare + realmin);       
        region = spectrogram(timeRegion, windowSize, (windowSize-hopSize), windowSize, fs);
        
        %Onset detection
        [nvt] = mySpectralDiff(region);
        order = fix(0.2/(hopSize/fs)); %200ms
        lamda = 0.1;
        
        %Thresholding    
        [G] = myAdapThres(nvt, order, lamda);
        
        %Peak picking
        [onsetInSec, onsetInFrame] = peakPick(nvt, G, fs, windowSize, hopSize); 

        
        %============== Feature Extraction ==============         
        %estimate IOI
        IOI = diff(onsetInSec, [], 2); %IOI (sec)
        nBins = 50;
        [nelement, xcenters] = hist(IOI, nBins); %histogram
        
        %normalize IOI histogram
        histSum = sum(nelement);
        nelementN = nelement / histSum;
        
        %IOI histogram features
        IOIpeakCrest = IOIPeakCrest(nelementN, xcenters);
        IOIbinDiff = mean(diff(xcenters));
        IOIskew = FeatureSpectralSkewness(nelementN', fs);
        IOIkurto = FeatureSpectralKurtosis(nelementN', fs);
        IOIrolloff = FeatureSpectralRolloff(nelementN', fs, 0.85);
        IOIflatness = FeatureSpectralFlatness(nelementN', fs);
        IOItonalPower = FeatureSpectralTonalPowerRatio(nelementN', fs);
        
        
        %Dynamic features        
        timeLength = length(timeRegion);
        timeSTD = std(timeRegion);
        timeRMSInDB = rms(timeRegionInDB);
        timeSTDInDB = std(timeRegionInDB);
        
        %Waveform histogram features
        timeNBins = 50;%round(abs(maxTime - minTime) / timeBinWidth);
        [timeNelement, timeXcenters] = hist(timeRegionInDB, timeNBins); %histogram
        
        %normalize histogram
        timeHistSum = sum(timeNelement);
        timeNelementN = timeNelement / timeHistSum;
        
        %compute features
        timeCrest = FeatureSpectralCrest(timeNelementN', fs);
        timeBinDiff = mean(diff(timeXcenters));
        timeSkew = FeatureSpectralSkewness(timeNelementN', fs);
        timeKurto = FeatureSpectralKurtosis(timeNelementN', fs);
        timeRolloff = FeatureSpectralRolloff(timeNelementN', fs, 0.85);
        timeFlatness = FeatureSpectralFlatness(timeNelementN', fs);
        timeTonalPower = FeatureSpectralTonalPowerRatio(timeNelementN', fs);
       
        %===== collect summary features
        summaryFeatures(1, i) = IOIpeakCrest;
        summaryFeatures(2, i) = IOIskew;
        summaryFeatures(3, i) = IOIkurto;
        summaryFeatures(4, i) = IOIrolloff;
        summaryFeatures(5, i) = IOIflatness;
        summaryFeatures(6, i) = IOItonalPower;
        summaryFeatures(7, i) = IOIbinDiff;
        summaryFeatures(8, i) = timeLength;
        summaryFeatures(9, i) = timeSTD;
        summaryFeatures(10, i) = timeRMSInDB;
        summaryFeatures(11, i) = timeSTDInDB;
        summaryFeatures(12, i) = timeCrest;
        summaryFeatures(13, i) = timeBinDiff;
        summaryFeatures(14, i) = timeSkew;
        summaryFeatures(15, i) = timeKurto;
        summaryFeatures(16, i) = timeRolloff;
        summaryFeatures(17, i) = timeFlatness;
        summaryFeatures(18, i) = timeTonalPower;


        
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


