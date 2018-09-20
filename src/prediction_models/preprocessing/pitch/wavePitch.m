%% WAVEPITCH Determine the pitch of a frame
% freq = wavePitch(data,fs,oldFreq)
% objective: Calculate fundamental pitch of a single frame  
%
% INPUTS
% data: 1xwSize float array, single frame of audio signal where wSize is
%       the window Size. data should be at least 256 samples long. 1024 
%       is recommended. It also must be a multiple of 64.
% fs: sampling frequency
% oldFreq: fundamental pitch from from previous window
%
% OUTPUTS
% freq: fundamental pitch of the frame in Hz
%
%   Copyright 2005 Ross Maddox (University of Michigan)
%              and Eric Larson (Kalamazoo College)

function freq = wavePitch(data,fs,oldFreq)

if (nargin < 1) 
    return;
end
if (nargin < 2) 
    fs = 44100; 
end
if (nargin < 3) 
    oldFreq = 0; 
end
oldMode = 0;
if(oldFreq)
  oldMode = fs/oldFreq;
end
dataLen = length(data);
freq = 0;              % The freq to return
lev = 6;               % Six levels of analysis
globalMaxThresh = .75; % Thresholding of maximum values to consider
maxFreq = 3000;        % Yields minimum distance to consider valid
diffLevs = 3;          % Number of differences to go through (3 is diff @ third neighbor)

maxCount(1) = 0;
minCount(1) = 0;

a(1,:) = data;
aver = mean(a(1,:));
globalMax = max(a(1,:));
globalMin = min(a(1,:));
maxThresh = globalMaxThresh*(globalMax-aver) + aver; % Adjust for DC Offset 
minThresh = globalMaxThresh*(globalMin-aver) + aver; % Adjust for DC Offset

%% Begin pitch detection %%

for (i = 2:lev)
    newWidth = dataLen/2^(i - 1);
    
    %% Perform the FLWT %%
    j = 1:newWidth;
    d(i,j) = a(i-1,2*j) - a(i-1,2*j-1);
    a(i,j) = a(i-1,2*j-1) + d(i,j)/2;
    
    %% Find the maxes of the current approximation %%
    minDist = max(floor(fs/maxFreq/2^(i-1)),1);
    maxCount(i) = 0;
    minCount(i) = 0;
    climber = 0; % 1 if pos, -1 if neg
    if (a(i,2) - a(i,1) > 0)
        climber = 1;
    else
        climber = -1;
    end
    
    canExt = 1; % Tracks whether an extreme can be found (based on zero crossings)
    tooClose = 0; % Tracks how many more samples must be moved before another extreme
    
    for (j = 2:newWidth-1)
        test = a(i,j) - a(i,j - 1);
        if (climber >= 0 && test < 0)
            if(a(i,j - 1) >= maxThresh && canExt && ~tooClose)
                maxCount(i) = maxCount(i) + 1;
                maxIndices(i,maxCount(i)) = j - 1;
                canExt = 0;
                tooClose = minDist;
            end
            climber = -1;
        elseif (climber <= 0 && test > 0)
            if(a(i,j - 1) <= minThresh && canExt && ~tooClose)
                minCount(i) = minCount(i) + 1;
                minIndices(i,minCount(i)) = j - 1;
                canExt = 0;
                tooClose = minDist;
            end
            climber = 1;
        end
        if (a(i,j) <= aver && a(i,j - 1) > aver) || (a(i,j) >= aver && a(i,j - 1) < aver)
            canExt = 1;
        end
        if(tooClose)
            tooClose = tooClose - 1;
        end
    end
    
    %% Calculate the mode distance between peaks at each level %%
    
    if (maxCount(i) >= 2 && minCount(i) >=2)
        % Calculate the differences at diffLevs distances
        differs = [];
        for (j = 1:diffLevs) % Interval of differences (neighbor, next-neighbor...)
            k = 1:maxCount(i) - j;   % Starting point of each run
            differs = [differs abs(maxIndices(i,k+j) - maxIndices(i,k))];
            k = 1:minCount(i) - j;   % Starting point of each run
            differs = [differs abs(minIndices(i,k+j) - minIndices(i,k))];
        end
        dCount = length(differs);
        % Find the center mode of the differences
        
        numer = 1;   % Require at least two agreeing differs to yield a mode
        mode(i) = 0; % If none is found, leave as zero
        
        for (j = 1:dCount)
            % Find the # of times that distance j is within minDist samples of another distance 
            numerJ = length(find( abs(differs(1:dCount) - differs(j)) <= minDist));
            
            % If there are more, set the new standard
            if (numerJ >= numer && numerJ > floor(newWidth/differs(j))/4)
                if (numerJ == numer)
                    if oldMode && abs(differs(j) - oldMode/(2^(i-1)) ) < minDist
                        mode(i) = differs(j);
                    elseif ~oldMode && (differs(j) > 1.95*mode(i) && differs(j) < 2.05*mode(i))
                        mode(i) = differs(j);
                    end
                else
                    numer = numerJ;
                    mode(i) = differs(j);
                end
            elseif numerJ == numer-1 && oldMode && abs(differs(j)-oldMode/(2^(i-1))) < minDist
                mode(i) = differs(j);
            end
        end
        
        %% Set the mode via averaging %%
        
        if (mode(i))
            mode(i) = mean(differs(find( abs(mode(i) - differs(1:dCount)) <= minDist) ));
        end
        
        %% Determine if the modes are shared %%
        
        if(mode(i-1) && maxCount(i - 1) >= 2 && minCount(i - 1) >= 2)
            % If the modes are within a sample of one another, return the calculated frequency 
            if (abs(mode(i-1) - 2*mode(i)) <= minDist )
                freq = fs/mode(i-1)/2^(i-2);
                return; 
            end
        end
    end
end