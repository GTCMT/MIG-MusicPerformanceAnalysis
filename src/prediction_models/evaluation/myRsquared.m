%% my R_squared 
% objective : calculate R^2 (coefficient of determination)
% [rr] = myRsquared(real, predict); 
% description: 
% y = m*1 vector of observed data
% f = m*1 vector of modeled results
% rr = coefficient of determination from 0 to 1
% Chih-Wei Wu, GTCMT, 2014/08

function [rr] = myRsquared(y, f)

%from wiki pedia
y_mean = mean(y);

SS_tot = sum( (y - y_mean).^2);
SS_res = sum( (y - f).^2);

rr = 1 - SS_res / SS_tot;


%from paper
% N = length(y); 
% err = 1/N * sum( (y - f).^2);
% y_mean = mean(y);
% rr = 1 - (N*err)/sum( (y - y_mean).^2);