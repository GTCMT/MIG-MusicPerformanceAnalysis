% ======================================================================
%> @brief computes the spectral kurtosis from the magnitude spectrum
%> called by ::ComputeFeature
%>
%> @param X: spectrogram (dimension FFTLength X Observations)
%> @param f_s: sample rate of audio data (unused)
%>
%> @retval vsk spectral kurtosis
% ======================================================================
function [vsk] = FeatureSpectralKurtosis (X, f_s)

    % compute mean and standard deviation
    mu_x    = mean(abs(X), 1);
    std_x   = std(abs(X), 1);

    % remove mean
    X       = X - repmat(mu_x, size(X,1), 1);
    
    % compute kurtosis
    vsk     = sum ((X.^4)./(repmat(std_x, size(X,1), 1).^4*size(X,1)));
    vsk     = vsk-3;
end

