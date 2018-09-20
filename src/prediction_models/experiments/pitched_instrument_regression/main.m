path = genpath('../..');
addpath(path);

createTrainingDataPitchedInstruments('initial', true);
% evaluatePerformancePitchedInstrument('initial');

rmpath(path);