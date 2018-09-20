
function ioiFeatures = computeIoiFeatures(IOI, nBins, fs)
    
    ioiFeatures = zeros(7, 1);
    [nelement, xcenters] = hist(IOI, nBins); 

    %normalize IOI histogram
    histSum = sum(nelement);
    nelement_n = nelement / histSum;
    
    %IOI histogram features
    ioiFeatures(1) = IOIPeakCrest(nelement_n, xcenters);
    ioiFeatures(2) = mean(diff(xcenters));
    ioiFeatures(3) = FeatureSpectralSkewness(nelement_n', fs);
    ioiFeatures(4) = FeatureSpectralKurtosis(nelement_n', fs);
    ioiFeatures(5) = FeatureSpectralRolloff(nelement_n', fs, 0.85);
    ioiFeatures(6) = FeatureSpectralFlatness(nelement_n', fs);
    ioiFeatures(7) = FeatureSpectralTonalPowerRatio(nelement_n', fs);
end