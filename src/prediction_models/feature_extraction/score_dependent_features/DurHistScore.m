function [durFeats] = DurHistScore(midi_mat_aligned, note_indices, note_onsets,fs, timeStep)
% function [durfeats] = DurHistScore(midi_mat)
% Computes duration histogram features
% of the score.
% Args: midi_mat_aligned(output of alignScore), 
%       note_indices(output of computeNoteOccurences),
%       note_onsets (onsets of inserted notes obtained
%                   using alignScore)
%       fs (Sampling feature)
%       timeStep (hop in seconds)
% Output: duration histogram features of first most occuring notes (6 dimensional)

%pre-process midi_mat_aligned and remove the insertions
midi_mat_aligned(note_onsets+1,:) = [];

note1_indices = note_indices;
% note2_indices = note_indices(2);

%Get corresponding note occurences of note 1&2 from student's performance
student_note1 = midi_mat_aligned(note1_indices, 7);
% student_note2 = midi_mat_aligned(note2_indices, 7);

% remove durations<=1frame length
student_note1(student_note1<=timeStep) = [];

if isempty(student_note1)
    durFeats = zeros(6,1);
else
    % Compute Histogram
    nbins = 100;
    [h1, xcenters1] = hist(student_note1, nbins);
    % [h2, xcenters2] = histcounts(student_note2, nbins);

    % Normalize Histogram
    h1_norm = h1/sum(h1);
    % h2_norm = h2/sum(h1);

    %duration feats
    peakCrest1 = IOIPeakCrest(h1_norm, xcenters1);
    binDiff1 = mean(diff(xcenters1));
    skew1 = FeatureSpectralSkewness(h1_norm', fs);
    kurto1 = FeatureSpectralKurtosis(h1_norm', fs);
    rolloff1 = FeatureSpectralRolloff(h1_norm', fs, 0.85);
    % flatness1 = FeatureSpectralFlatness(h1_norm', fs);
    tonalPower1 = FeatureSpectralTonalPowerRatio(h1_norm', fs);

    % peakCrest2 = IOIPeakCrest(h2_norm, xcenters2);
    % binDiff2 = mean(diff(xcenters2));
    % skew2 = FeatureSpectralSkewness(h2_norm', fs);
    % kurto2 = FeatureSpectralKurtosis(h2_norm', fs);
    % rolloff2 = FeatureSpectralRolloff(h2_norm', fs, 0.85);
    % flatness2 = FeatureSpectralFlatness(h2_norm', fs);
    % tonalPower2 = FeatureSpectralTonalPowerRatio(h2_norm', fs);

    durFeats = [peakCrest1;binDiff1;skew1;kurto1;rolloff1;tonalPower1];  %;...
    %     peakCrest2;binDiff2; skew2;kurto2;rolloff2;flatness2;tonalPower2];
end
end