import os
import sys
import warnings
from librosa.core import load
import numpy as np
from Features import *
import math
from functools import reduce
import time

warnings.simplefilter("ignore", UserWarning)


def blockAndRunLerch(y, fs, blockSize = 4096):

    features = 7
    iNumCoeff = 24

    featureRows = features + iNumCoeff

    hopSize = int(blockSize / 2)  # sets the hopsize to be 1/2 of blocksize for 50% overlap

    hops = np.arange(0, (len(y) - 1), hopSize)
    hops += blockSize
    big = max(hops[hops < (len(y) - 1)])
    numIterations = int((big - blockSize) / hopSize) + 1

    # allocates memory for feature array
    featureArr = np.zeros([featureRows, numIterations])

    freqs, tArr, X = sc.signal.spectrogram(y, nperseg=blockSize, noverlap=hopSize, mode='magnitude')

    featureArr[0, :numIterations] = FeatureTimeRms(y, blockSize, hopSize, fs)[0:numIterations]
    featureArr[1, :numIterations] = FeatureSpectralCrestFactor(X, fs)[0:numIterations]
    featureArr[2, :numIterations] = FeatureSpectralCentroid(X, fs)[0:numIterations]
    featureArr[3, :numIterations] = FeatureTimeZeroCrossingRate(y, blockSize, hopSize, fs)[0:numIterations]
    featureArr[4, :numIterations] = FeatureSpectralRolloff(X, fs, kappa=0.85)[0:numIterations]
    featureArr[5, :numIterations] = FeatureSpectralFlux(X, fs)[0:numIterations]
    featureArr[(features - 1):featureRows - 1, :numIterations] = FeatureSpectralMfccs(X, fs, iNumCoeff)[:, 0:numIterations]

    oneSec = np.arange(0, (len(y) - 1), hopSize)
    oneSec += blockSize
    secNum = max(oneSec[oneSec <= fs])
    blocksPerSec = int((secNum - blockSize) / hopSize) + 1
    numSecBlocks = int((numIterations - (numIterations % blocksPerSec)) / blocksPerSec)
    featArrCongregate = np.zeros([featureRows * 2, numSecBlocks])
    blockTimes = np.arange(float(numSecBlocks))
    row = 0
    for block in np.arange(numSecBlocks):
        row = 0
        startCol = block * blocksPerSec
        endCol = (block + 1) * blocksPerSec
        blockTimes[block] = (oneSec[startCol]) / fs
        while row < featureRows:
            featArrCongregate[row, block] = float(np.mean(featureArr[row, startCol:endCol]))
            featArrCongregate[row + 1, block] = float(np.std(featureArr[row, startCol:endCol]))

            row += 2


    dataX = featArrCongregate.T

    return dataX, blockTimes


def groundTruth(directory, blockTimes):
    # This function takes a directory path to a folder as input. This folder should have the annotation txt
    # files for the auditions that the user wants to read in.

    # Input: folder path directory
    # Output: text (a list of float values that is 5 x [a,b] for each text file read where a is the beginning time
    #               stamp of each segment and b is the duration of the segment in seconds)
    #         names (a list of the student IDs in the same corresponding order as text variable indices)

    t = open(directory, 'r')
    groundVec = np.zeros(len(blockTimes), dtype=int)
    truthWindows = []
    for x in t:
        num1 = float(x[0:x.index('\t1')])
        x2 = x[x.index('\t1'):]
        num2 = float(x2[x2.index('1')+len('\t1'):])+num1
        truthWindows.append([num1, num2])

    mask = []
    for i in truthWindows:
        mask = [i[0] <= blockTimes, i[1] >= blockTimes]
        maskVec = reduce(np.logical_and, mask)
        groundVec[maskVec==True] = 1
    y = np.array([groundVec + 1])
    return y, truthWindows, blockTimes


def fileWrite(audioDirectory, textDirectory='', writeDirectory='', writeFiles = True, newData = True):
    # This function takes a directory path to a folder as input. This folder should have the annotation mp3
    # files for the auditions that the user wants to read in.

    # Input: folder path directory
    # Output: data (each index represents the audio data of one file)

    files = []
    notFound = []

    if newData != True:
        for entry in os.listdir(textDirectory):
            if os.path.isfile(os.path.join(textDirectory, entry)) and entry[-4:] == '.txt':
                fileNum = entry[:-4]
                # print(fileNum)

                files.append(fileNum)
                try:
                    # y, fs = load(audioDirectory + '/' + fileNum + '.mp3', mono=True)
                    path = os.fspath(audioDirectory + '/' + fileNum + '/' + fileNum + '.mp3')
                    y, fs = load(path, mono=True)
                    tDirectory = textDirectory + '/' + entry
                    featureArr, blockTimes = blockAndRunLerch(y, fs)
                    groundVec, truthWindows, blockTimes = groundTruth(tDirectory, blockTimes)
                    featureOrder = ['rms', 'specCrest', 'specCent', 'zcr', 'specRolloff', 'specFlux', 'mfccCoeff']
                    if writeFiles:
                        np.savez(writeDirectory + '/' + fileNum, featureOrder, featureArr, groundVec.T, truthWindows, blockTimes)

                except FileNotFoundError:
                    notFound.append(fileNum)
                    print(fileNum)
                except ValueError:
                    print("error with: " + fileNum)
    else:
        for entry in os.listdir(audioDirectory):
            if os.path.isdir(os.path.join(audioDirectory, entry)):
                fileNum = entry

                files.append(fileNum)
                try:
                    path = os.fspath(audioDirectory + '/' + fileNum + '/' + fileNum + '.mp3')
                    y, fs = load(path, mono=True)
                    tDirectory = textDirectory + '/' + entry
                    featureArr, blockTimes = blockAndRunLerch(y, fs)
                    featureOrder = ['rms', 'specCrest', 'specCent', 'zcr', 'specRolloff', 'specFlux', 'mfccCoeff']
                    if writeFiles:
                        np.savez(writeDirectory + '/' + fileNum, featureOrder, featureArr, [], [],
                                 blockTimes)

                except FileNotFoundError:
                    notFound.append(fileNum)
                    print(fileNum)

    return files


def fileOpen(directory):
    np_load_old = np.load
    np.load = lambda *a, **k: np_load_old(*a, allow_pickle=True, **k)

    file = np.load(directory)
    featureOrder = file['arr_0']
    featureArr = file['arr_1']
    groundVec = file['arr_2']
    truthWindow = file['arr_3']
    blockTimes = file['arr_4']

    np.load = np_load_old

    return featureOrder, featureArr, groundVec, truthWindow, blockTimes
