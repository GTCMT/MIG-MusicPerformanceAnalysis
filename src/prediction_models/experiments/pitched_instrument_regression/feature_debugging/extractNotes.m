function notes = extractNotes(audio, f0, Fs, hop, thres, thinning)

% assign memory for outout

% declare hyper parameters
thresh1=0.1;
thresh2=0.4;

% perform note segmentation
notes = noteSegmentation(audio, f0, Fs, hop, 50, thres, -50, thinning);

end