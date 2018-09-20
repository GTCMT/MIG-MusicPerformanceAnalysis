function wrong_segments = checkNumSegments(segmentText)


formatSpec = '%f %f';
wrong_segments = [];
sizeA = [2 5];

for i = 1:length(segmentText);
    fileID = fopen(segmentText{i}, 'r');
    
    tline = fgetl(fileID); % this is the first line with file information
    
    A = fscanf(fileID,formatSpec);
    
    if (length(A) ~= 10)
        wrong_segments = [wrong_segments; 1];
    else
        wrong_segments = [wrong_segments; 0];
    end
    
    fclose(fileID);
end
