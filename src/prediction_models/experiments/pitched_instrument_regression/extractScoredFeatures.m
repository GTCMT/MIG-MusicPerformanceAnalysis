%% Feature vector creation
% AV@GTCMT
% [features] = extractScoredFeatures(audio, Fs, wSize, hop)
% objective: Create a feature vector of all the non score based features called inside this
% function
%
% INPUTS
% audio: samples
% Fs: sampling frequency
% wSize: window size in samples
% hop: hop in samples
%
% OUTPUTS
% features: 1 x N feature vector (where N is the number of features getting extracted in the function)

function [features] = extractScoredFeatures(audio, Fs, wSize, hop, YEAR_OPTION, NUM_FEATURES)

if ismac
    % Code to run on Mac plaform
    slashtype='/';
elseif ispc
    % Code to run on Windows platform
    slashtype='\';
end

features=zeros(1,NUM_FEATURES);
algo='acf';
timeStep = hop/Fs;

[f0, ~] = estimatePitch(audio, Fs, hop, wSize, algo);

% get the score to pass to the feature extraction function
root_path = deriveRootPath();
scorePath = [root_path '..' slashtype '..' slashtype 'FBA' YEAR_OPTION slashtype 'midiscores' slashtype 'Alto Sax' slashtype 'Middle School' slashtype 'mid_alto_tech_' YEAR_OPTION '.mid'];
scoreMid = readmidi(scorePath);
[rwSc, clSc] = size(scoreMid);

[tf, flag] = findTuningFrequency(f0);
pitch_in_midi = 69+12*log2(f0/440);
pitch_in_midi(pitch_in_midi == -Inf) = 0;
pitch_in_midi2 = pitch_in_midi;

pitch_in_midi(pitch_in_midi~=0) = pitch_in_midi(pitch_in_midi~=0) - (tf/100);
tfCompnstdF0 = pitch_in_midi;
tfCompnstdF0(tfCompnstdF0~=0) = (2.^((pitch_in_midi(tfCompnstdF0~=0)-69)/12))*440;

if flag == 1
    pitch_in_midi2(pitch_in_midi2~=0) = pitch_in_midi2(pitch_in_midi2~=0) + (tf/100);
    tfCompnstdF02 = pitch_in_midi2;
    tfCompnstdF02(tfCompnstdF02~=0) = (2.^((pitch_in_midi2(tfCompnstdF02~=0)-69)/12))*440;
    [algndmid1, note_onsets1, dtw_cost1, path1] = alignScore(scorePath, tfCompnstdF0, audio, Fs, wSize, hop);
    [algndmid2, note_onsets2, dtw_cost2, path2] = alignScore(scorePath, tfCompnstdF02, audio, Fs, wSize, hop);
    if dtw_cost2 > dtw_cost1
       algndmidi = algndmid1;
       note_altrd = note_onsets1;
       dtw_cost = dtw_cost1;
       path = path1;
    else
       algndmidi = algndmid2;
       note_altrd = note_onsets2;
       dtw_cost = dtw_cost2;
       path = path2;
       tfCompnstdF0 = tfCompnstdF02;
    end
else
    [algndmidi, note_altrd, dtw_cost, path] = alignScore(scorePath, tfCompnstdF0, audio, Fs, wSize, hop);
end

[slopedev, ~] = slopeDeviation(path);
[rwStu, clStu] = size(algndmidi);

% features over each individual note and then its derived statistical features
NoteAvgDevFromRef = zeros(1,rwStu); NoteStdDevFromRef = zeros(1,rwStu); NormCountGreaterStdDev = zeros(1,rwStu);
ShortNotes = [];
numSampShortNotes = [];
for i=1:rwStu
    strtTime = round(algndmidi(i,6)/timeStep);
    endTime = round(algndmidi(i,6)/timeStep + algndmidi(i,7)/timeStep-1);
    pitchvals=(tfCompnstdF0(strtTime:endTime));
    if (numel(pitchvals) < 3) %note played is too short i.e. around 10 ms
        ShortNotes = [ShortNotes, i];
        numSampShortNotes = [numSampShortNotes, numel(pitchvals)];
    else
        [NoteAvgDevFromRef(1,i),NoteStdDevFromRef(1,i),NormCountGreaterStdDev(1,i)]=NoteSteadinessMeasureWithRefScore(pitchvals(pitchvals~=0), algndmidi(i,4));
    end
end
% Remove Short Notes
NoteAvgDevFromRef(ShortNotes) = [];
NoteStdDevFromRef(ShortNotes) = [];
NormCountGreaterStdDev(ShortNotes) = [];

features(1,1) = sum(algndmidi(:,7))/(sum(algndmidi(:,7))+sum(algndmidi(note_altrd+1,6)-(algndmidi(note_altrd,6)+algndmidi(note_altrd,7))));  % sum of silences between the number of notes in the score and the student (inserted notes)
features(1,2)=mean(NoteAvgDevFromRef);
features(1,3)=std(NoteAvgDevFromRef);
features(1,4)=max(NoteAvgDevFromRef);
features(1,5)=min(NoteAvgDevFromRef);
 
features(1,6)=mean(NoteStdDevFromRef);
features(1,7)=std(NoteStdDevFromRef);
features(1,8)=max(NoteStdDevFromRef);
features(1,9)=min(NoteStdDevFromRef); 
 
features(1,10)=mean(NormCountGreaterStdDev);
features(1,11)=std(NormCountGreaterStdDev);
features(1,12)=max(NormCountGreaterStdDev);
features(1,13)=min(NormCountGreaterStdDev);
 
features(1,14)=dtw_cost/length(path);
features(1,15)=slopedev;
 
[note_indices] = computeNoteOccurence(scoreMid);
vecDurFeat = DurHistScore(algndmidi, note_indices, note_altrd, Fs, timeStep);
features(1,16:21)=vecDurFeat';
features(1,22) = length(ShortNotes)*sum(numSampShortNotes)*timeStep / sum(algndmidi(:,7)); 
% features(1,23) = length(path);
% features(1,24) = length(f0);
      
end