function [outliers, mu, sigma] = checkDurSegments(segmentText,segmentNum,tolerance)

formatSpec = '%f %f';
sizeA = [2 5];
dur_data = [];
for i = 1:length(segmentText);
    fileID = fopen(segmentText{i}, 'r');
    tline = fgetl(fileID);
    A = fscanf(fileID,formatSpec,sizeA);
    dur_data = [dur_data; A(2,:)]; %take the durations only
    fclose(fileID);
end

%obtaining parameters for gaussian model -- mu and sigma
pd = fitdist(dur_data(:,segmentNum), 'Normal');
index_below = (dur_data(:,segmentNum))<pd.mu-tolerance*pd.sigma;
index_above = (dur_data(:,segmentNum))<pd.mu-tolerance*pd.sigma;
outliers = index_below | index_above;

mu = pd.mu;
sigma = pd.sigma;

end

