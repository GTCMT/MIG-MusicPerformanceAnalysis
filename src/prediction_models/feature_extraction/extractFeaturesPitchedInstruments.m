% Extract Features for Pitched Instruments
% CL@GTCMT 2015
% features = extractFeaturesPitchedInstruments(audio, Fs, hop_size)
%
% audio: Nx1 float vector, audio signal from which to extract features.
% Fs: int, sample rate.
% hop_size: the time resolution when calculating instantaneous features.
% features: 1xM float vector, extracted features.
%
% Dependency: ACA_Matlab's FeatureTimeRms function.
function features = extractFeaturesPitchedInstruments(audio, Fs, hop_size)
  features = [];
  block_size = hop_size;
  num_mfccs = 13;
  
  % Get Instantaneous Data.
  pitches = estimatePitch(audio, Fs, hop_size);
  amplitudes = ComputeFeature('TimeRms', audio, Fs, [], ...
                              block_size, hop_size);
  mfccs = ComputeFeature('SpectralMfccs', audio, Fs, [], block_size, ...
                         hop_size);

  % Segment into notes.
  POWER_THRESHOLD_DB = -40;
  DURATION_THRESHOLD_SEC = 0.2;
  INTERVAL_THRESHOLD_CENTS = 60;

  notes = noteSegmentation(audio, pitches, Fs, hop_size, ...
                           INTERVAL_THRESHOLD_CENTS, ...
                           DURATION_THRESHOLD_SEC, POWER_THRESHOLD_DB);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Aggregate instantaneous features into note-level features.
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  num_notes = size(notes, 1);
  note_pitch_features = zeros(num_notes, 1);
  note_amplitude_features = zeros(num_notes, 1);
  note_mfccs = zeros(num_mfccs, num_notes, 1);
  for(note_idx = 1:num_notes)
    cur_note = notes(note_idx);
    start_idx = cur_note.start;
    stop_idx = cur_note.stop;
    
    % cur_duration = note.duration;
    
    % Pitch.
    cur_pitches = pitches(start_idx:stop_idx);
    note_pitch_features(note_idx) = std(cur_pitches);

    % Amplitude.
    cur_amplitudes = amplitudes(start_idx:stop_idx);
    note_amplitude_features(note_idx) = std(cur_amplitudes);

    % MFCCs.
    for(mfcc_idx = 1:num_mfccs)
      cur_mfccs = note_mfccs(mfcc_idx, note_idx, :);
      note_mfccs(mfcc_idx, note_idx) = std(cur_mfccs);
    end
  end
  durations = [notes.duration];
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Aggregate note-level features into song-level features.
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  feature_idx = 1;
  
  % Pitch.
  features(feature_idx) = mean(note_pitch_features);
  feature_idx = feature_idx + 1;
  
  % Amplitude.
  features(feature_idx) = mean(note_amplitude_features);
  feature_idx = feature_idx + 1;
  
  % MFCCs.
  for(mfcc_idx = 1:num_mfccs)
    cur_mfccs = mfccs(mfcc_idx, note_idx, :);
    features(feature_idx) = mean(cur_mfccs);
    feature_idx = feature_idx + 1;
  end
  
  % Durations.
  features(feature_idx) = mean(durations);
  feature_idx = feature_idx + 1;
  
%   % Duration beat histogram.
%   num_hist_bins = 100;
%   duration_histogram = histcounts([notes.duration], num_hist_bins);

end

