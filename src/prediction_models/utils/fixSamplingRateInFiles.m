function fixSamplingRateInFiles(file_path)

[x,fs] = audioread(file_path);
if (fs ~= 44100)
    x_resampled = resample(x, 44100, fs);
    x_resampled = mean(x_resampled, 2);
    x_resampled = x_resampled ./ max(abs(x_resampled));
end

file_path = file_path(1:end-4);
file_path = [file_path, '.wav'];
audiowrite(file_path, x_resampled, 44100);

end