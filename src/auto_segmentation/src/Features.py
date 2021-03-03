import numpy as np
import scipy as sc
from scipy import signal
import math


# ***************** Lerch's Features *******************

def FeatureSpectralCentroid(X, f_s):

    # X = X**2 removed for consistency with book

    norm = X.sum(axis=0, keepdims=True)
    norm[norm == 0] = 1

    vsc = np.dot(np.arange(0, X.shape[0]), X) / norm

    # convert from index to Hz
    vsc = vsc / (X.shape[0] - 1) * f_s / 2

    return np.squeeze(vsc)


def FeatureSpectralCrestFactor(X, f_s):

    norm = X.sum(axis=0)
    if np.ndim(X) == 1:
        if norm == 0:
            norm = 1
    else:
        norm[norm == 0] = 1

    vtsc = X.max(axis=0) / norm

    return (vtsc)


def FeatureSpectralFlux(X, f_s):

    # difference spectrum (set first diff to zero)
    X = np.c_[X[:, 0], X]

    afDeltaX = np.diff(X, 1, axis=1)
    # flux
    vsf = np.sqrt((afDeltaX**2).sum(axis=0)) / X.shape[0]

    return (vsf)

def FeatureTimeRms(x, iBlockLength, iHopLength, f_s):

    # number of results
    iNumOfBlocks = math.ceil(x.size / iHopLength)

    # compute time stamps
    t = (np.arange(0, iNumOfBlocks) * iHopLength + (iBlockLength / 2)) / f_s

    # allocate memory
    vrms = np.zeros(iNumOfBlocks)

    for n in range(0, iNumOfBlocks):

        i_start = n * iHopLength
        i_stop = np.min([x.size - 1, i_start + iBlockLength - 1])

        # calculate the rms
        vrms[n] = np.sqrt(np.dot(x[np.arange(i_start, i_stop + 1)], x[np.arange(i_start, i_stop + 1)]) / (i_stop + 1 - i_start))

    # convert to dB
    epsilon = 1e-5  # -100dB

    vrms[vrms < epsilon] = epsilon
    vrms = 20 * np.log10(vrms)

    return vrms


def FeatureTimeZeroCrossingRate(x, iBlockLength, iHopLength, f_s):

    # number of results
    iNumOfBlocks = math.ceil(x.size / iHopLength)

    # compute time stamps
    t = (np.arange(0, iNumOfBlocks) * iHopLength + (iBlockLength / 2)) / f_s

    # allocate memory
    vzc = np.zeros(iNumOfBlocks)

    for n in range(0, iNumOfBlocks):

        i_start = n * iHopLength
        i_stop = np.min([x.size - 1, i_start + iBlockLength - 1])

        # calculate the zero crossing rate
        vzc[n] = 0.5 * np.mean(np.abs(np.diff(np.sign(x[np.arange(i_start, i_stop + 1)]))))

    return vzc


def FeatureSpectralRolloff(X, f_s, kappa=0.85):

    X = np.cumsum(X, axis=0) / X.sum(axis=0, keepdims=True)

    vsr = np.argmax(X >= kappa, axis=0)

    # convert from index to Hz
    vsr = vsr / (X.shape[0] - 1) * f_s / 2

    return (vsr)

def FeatureSpectralMfccs(X, f_s, iNumCoeffs=24):

    # allocate memory
    v_mfcc = np.zeros([iNumCoeffs, X.shape[1]])

    # generate filter matrix
    H = ToolMfccFbL(X.shape[0], f_s)
    T = generateDctMatrixL(H.shape[0], iNumCoeffs)

    for n in range(0, X.shape[1]):
        # compute the mel spectrum
        X_Mel = np.log10(np.dot(H, X[:, n] + 1e-20))

        # calculate the mfccs
        v_mfcc[:, n] = np.dot(T, X_Mel)

    return (v_mfcc)


# see function mfcc.m from Slaneys Auditory Toolbox
def generateDctMatrixL(iNumBands, iNumCepstralCoeffs):
    T = np.cos(np.outer(np.arange(0, iNumCepstralCoeffs), (2 * np.arange(0, iNumBands) + 1)) * np.pi / 2 / iNumBands)

    T = T / np.sqrt(iNumBands / 2)
    T[0, :] = T[0, :] / np.sqrt(2)

    return (T)


def ToolMfccFbL(iFftLength, f_s):

    # initialization
    f_start = 133.3333

    iNumLinFilters = 13
    iNumLogFilters = 27
    iNumFilters = iNumLinFilters + iNumLogFilters

    linearSpacing = 66.66666666
    logSpacing = 1.0711703

    # compute band frequencies
    f = np.zeros(iNumFilters + 2)
    f[np.arange(0, iNumLinFilters)] = f_start + np.arange(0, iNumLinFilters) * linearSpacing
    f[np.arange(iNumLinFilters, iNumFilters + 2)] = f[iNumLinFilters - 1] * logSpacing**np.arange(1, iNumLogFilters + 3)

    # sanity check
    if f[iNumLinFilters - 1] >= f_s / 2:
        f = f[f < f_s / 2]
        iNumFilters = f.shape[0] - 2

    f_l = f[np.arange(0, iNumFilters)]
    f_c = f[np.arange(1, iNumFilters + 1)]
    f_u = f[np.arange(2, iNumFilters + 2)]

    # allocate memory for filters and set max amplitude
    H = np.zeros([iNumFilters, iFftLength])
    afFilterMax = 2 / (f_u - f_l)
    f_k = np.arange(0, iFftLength) / (iFftLength - 1) * f_s / 2

    # compute the transfer functions
    for c in range(0, iNumFilters):
        # lower filter slope
        i_l = np.argmax(f_k > f_l[c])
        i_u = np.max([0, np.argmin(f_k <= f_c[c]) - 1])
        H[c, np.arange(i_l, i_u + 1)] = afFilterMax[c] * (f_k[np.arange(i_l, i_u + 1)] - f_l[c]) / (f_c[c] - f_l[c])
        # upper filter slope
        i_l = i_u + 1
        i_u = np.max([0, np.argmin(f_k < f_u[c]) - 1])
        H[c, np.arange(i_l, i_u + 1)] = afFilterMax[c] * (f_u[c] - f_k[np.arange(i_l, i_u + 1)]) / (f_u[c] - f_c[c])

    return (H)
