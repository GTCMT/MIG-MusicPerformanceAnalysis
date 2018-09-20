close all
clear all
clc


% test signal
fs = 44100;
freq1 =440;
time = 0:1/fs:1-1/fs;
x1 = sin(2*pi*freq1*time); %from 0 to 1 secs
freq2 = 880;
x2 = sin(2*pi*freq2*time); % from 1 to 2 secs
audio = [x1, x2];
audio = audio';


% calling the acf pitch detection function
acf_options = struct();
acf_options.sr = fs;
acf_options.hop = 512; % hop size
acf_options.wsize = 1024; % window size
[f0, timeInSec] = estimatePitchAlgos(audio,fs,acf_options.hop, acf_options.wsize,'acf');

% evaluation of algorithm
num_windows = length(f0);
freq = zeros(1,num_windows); % freq vector for evaluation purpose
i = 1;
while(i<=num_windows)
    if timeInSec(i) < 1
        freq(i) = freq1;
    else
        freq(i) = freq2;
    end 
    i = i+1;
end
%freq = 1000*log2(1+freq/1000); %Hz to mel
error = f0 - freq;
error_percent = (error./freq)*100;
avg_error = mean(error_percent)
plot(error_percent);

 

