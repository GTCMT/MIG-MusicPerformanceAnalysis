

function [train, test] = stackFolds(dataFolds, testFoldIndex)

train = [];
numFolds = length(dataFolds);
foldIndices = 1:numFolds;
test = dataFolds{testFoldIndex, 1};
foldIndices(testFoldIndex) = [];

for i = 1:length(foldIndices)
    train = [train; dataFolds{foldIndices(i), 1}];
end

end