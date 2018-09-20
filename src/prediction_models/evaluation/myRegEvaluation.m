%% my regression evaluation
% objective : evaluate the trained regression model
% [Rsq, S, p, r] = myRegEvaluation(y, f);
% description: 
% y = m*1 vector of observed data
% f = m*1 vector of modeled results
% Rsq = R squared value
% S = standard error of estimate
% p = p value 
% r = correlation coefficient between truth & prediction
% Chih-Wei Wu, GTCMT, 2014/08

function [Rsq, S, p, r] = myRegEvaluation(y, f)


Rsq = myRsquared(y, f);
[r, p] = corr(y, f);
S = rms( (f-y));
