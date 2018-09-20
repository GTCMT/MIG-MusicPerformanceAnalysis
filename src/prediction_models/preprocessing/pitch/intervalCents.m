%% Interval Cents
% CL@GTCMT, 2015
% cents = intervalCents(freq_1, freq_2)
% objective: Determine the interval between two frequencies. 
%
% freq_1: float, first frequency value, in hertz.
% freq_2: float, second frequency value, in hertz.
% cents: float, the interval between the frequencies. Positive if |freq_2|
%        is higher than |freq_1|.
%
% Dependency: yin --> http://www.auditory.org/postings/2002/26.html

function cents = intervalCents(freq_1, freq_2)
  cents = 1200 * log2(freq_2 / freq_1);
end

