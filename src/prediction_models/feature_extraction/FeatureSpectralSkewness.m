% ======================================================================
%> @brief computes the spectral skewness from the magnitude spectrum
%> called by ::ComputeFeature
%>
%> @param X: spectrogram (dimension FFTLength X Observations)
%> @param f_s: sample rate of audio data (unused)
%>
%> @retval v spectral skewness
% ======================================================================
function [vssk] = FeatureSpectralSkewness (X, f_s)

    % compute mean and standard deviation
    mu_x    = mean(abs(X), 1);
    std_x   = std(abs(X), 1);

    % compute skewness
    X       = X - repmat(mu_x, size(X,1), 1);
    vssk    = sum ((X.^3)./(repmat(std_x, size(X,1), 1).^3*size(X,1)));
end