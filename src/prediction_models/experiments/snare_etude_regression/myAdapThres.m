%% calculate the adaptive threshold
% input: nvt = m*n novelty function
%        b = user defined 1*j window , j = order
%        lamda = a variable for controlling the sensitivity (% of max)
% output:Gdma = m*n adaptive threshold 

function [Gdma] = myAdapThres(nvt, order, lamda)

%signal-adaptive threshold
b = 1/order*ones(1,order); 
[~, n] = size(nvt);


maxVal = max(nvt, [] ,2);
for i = 1:n

    if i-order < 1            
        tmp = nvt(:,1) * ones(1, abs(i-order)); %take the first number
        Gdma(:,i) = lamda*maxVal + sum(b.* [tmp, nvt(:, 1:i)], 2);

    elseif i-order >= 1
        Gdma(:,i) = lamda*maxVal + sum(b.*nvt(:,(i-order):i-1), 2);
    end

end


%compensate the delay of the threshold 

shiftSize = round(0.5 * order); %1/2 order size

Gdma(:, 1:(end-shiftSize)) = Gdma(:, (shiftSize+1):end);


