

function [dataFolds, fileIndices] = nfoldPartition(data, numFolds)

fileIndices = cell(numFolds, 1);
dataFolds = cell(numFolds, 1);
[numSamples, ~] = size(data);
orderInd = 1:numSamples;
orderInd = orderInd(:);
%orderInd_shuffled = shuffleRowData(orderInd);
orderInd_shuffled = orderInd;

for i = 1:numSamples
    
    foldInd = mod(i, numFolds);
    foldInd = foldInd + 1;
    fileIndices{foldInd, 1} = [fileIndices{foldInd, 1}; orderInd_shuffled(i)];
end 

for j = 1:numFolds
    dataFolds{j, 1} = data(fileIndices{j, 1}, :);    
end

end 