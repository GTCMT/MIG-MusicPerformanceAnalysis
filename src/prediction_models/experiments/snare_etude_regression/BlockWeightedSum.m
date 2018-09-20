%% Loudness
% objective: calculate LU/LUFS according to EBU standard
% [LK] = LoudnessPerBlock(z, weight)
% z = numChannel * numFrame matrix
% weight = 1*numChannel vector
% z_block = 1*numFrame vector (weighted sum)
% CW @ GTCMT

function [z_block] = BlockWeightedSum(z, weight)

[numChannel, numFrame] = size(z);
z_block = zeros(1, numFrame);
for i = 1:numChannel    
    z_weight(i,:) = weight(i)*z(i, :); 
end

z_block = sum(z_weight, 1);