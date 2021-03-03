import numpy as np
from sklearn import svm
from DataParsing import*
import matplotlib.pyplot as plt
import math
import time

def overlayPred(procPred, gTruth, entry, num, plot=False, plotSave = False, saveLoc = ''):
    if plot:
        cArr = []
        sX = []
        sY = []
        x = np.arange(0, len(gTruth)) / 60
        for i in np.arange(0, len(gTruth)):
            if (procPred[i] != gTruth[i]):
                # false negative
                if (procPred[i] == 0):
                    cArr += ['red']
                    sX += [x[i]]
                    sY += [gTruth[i]]
                # false positive
                else:
                    cArr += ['blue']
                    sX += [x[i]]
                    sY += [gTruth[i]]
        fig = plt.figure(num, figsize=[15, 7])
        plt.plot(x, gTruth, label=entry[:-4])
        plt.plot(x, procPred/2)
        # plt.scatter(sX, sY, c=cArr)
        fig.suptitle(entry[:-4])
        plt.xlabel('Time (minutes)\nRed = False Negative; Blue = False Positive')
        plt.ylabel('Classification')
        if plotSave:
            plt.savefig(saveLoc + entry[:-4] + '.png')

def confusionMat(confResults, printCons=False):
    if printCons:
        tN = confResults[0]
        fP = confResults[1]
        fN = confResults[2]
        tP = confResults[3]
        print("\t\t\t\tPred Nonmusic, Pred Music")
        print("Actual Nonmusic \t" + str(tN) + ": " + str(tN/(tN + fP)) + "\t\t" + str(fP)) + ": " + str(fP/(tN + fP))
        print("Actual Music    \t" + str(fN) + ": " + str(fN/(fN + tP)) + "\t\t" + str(tP)) + ": " + str(tP/(fN + tP))

def plotSegHistogram(segmentsArr, saveSegLoc='', smoothing=False, plot=False, save=False):
    if plot:

        # FILE NAME, the rest is automatic
        testGroup = '2018ConcertBandFlute'

        if smoothing:
            smoothStr = ' with smoothing'
            smoothSave = 'WS'
        else:
            smoothStr = ''
            smoothSave = ''

        fig1 = plt.figure(figsize=[12, 6])
        segmentsArr = segmentsArr.astype(int)
        countsArr = np.zeros(int(np.max(segmentsArr)) + 1)
        for ind in segmentsArr:
            countsArr[ind] = countsArr[ind] + 1
        x = np.arange(np.max(segmentsArr) + 1)
        plt.bar(x, countsArr)
        plt.yticks(np.arange(np.max(countsArr) + 2))
        fig1.autofmt_xdate()
        plt.xlabel('Number of Segments')
        plt.ylabel('Number of files')
        plt.suptitle(testGroup + ' Segments' + smoothStr)
        if save:
            plt.savefig(saveSegLoc + testGroup + smoothSave + '.png')

def histogramsPredCalc(fP, fN, threshArr, pCount, nCount, samples):
    if (fP/samples > np.max(threshArr/100) or fN/samples > np.max(threshArr/100)):
        newPercent = max([np.ceil((fP/samples) * 100), np.ceil((fN/samples) * 100)])
        threshArr = np.arange(0, (newPercent*2 + 1)) * 0.5
        newIndices = len(threshArr)-len(pCount)
        pCount = np.append(pCount, np.zeros(newIndices))
        nCount = np.append(nCount, np.zeros(newIndices))
    pPlace = np.where((fP/samples) < threshArr/100)[0][0]
    pCount[pPlace] = pCount[pPlace] + 1
    nPlace = np.where((fN/samples) < threshArr/100)[0][0]
    nCount[nPlace] = nCount[nPlace] + 1
    return pCount, nCount, threshArr

def plotPredHistogram(pCount, nCount, threshArr, savePredLoc, smoothing=False, plot=False, save=False):
    if plot:
        # FILE NAME, the rest is automatic
        testGroup = '2018ConcertBandClar'

        if smoothing:
            smoothStr = ' with smoothing'
            smoothSave = 'WS'
        else:
            smoothStr = ''
            smoothSave = ''

        fig1 = plt.figure(figsize=[12, 4.8])
        x = np.arange(len(pCount))
        plt.bar(x, pCount)
        plt.xticks(x, threshArr)
        fig1.autofmt_xdate()
        plt.xlabel('Percent of fP in samples')
        plt.ylabel('Number of files')
        plt.suptitle(testGroup + ' - false positives' + smoothStr)
        if save:
            plt.savefig(savePredLoc + testGroup + 'Fp' + smoothSave + '.png')

        fig2 = plt.figure(figsize=[12, 4.8])
        plt.bar(x, nCount)
        plt.xticks(x, threshArr)
        fig2.autofmt_xdate()
        plt.xlabel('Percent of fN in samples')
        plt.ylabel('Number of files')
        plt.suptitle(testGroup + ' - false negatives' + smoothStr)
        if save:
            plt.savefig(savePredLoc + testGroup + 'Fn' + smoothSave + '.png')

def plotStampHistogram(absMeanStamps, saveLoc='', smoothing=False, plot=False, save=False):
    if plot:

        # FILE NAME, the rest is automatic
        testGroup = '2018ConcertBandAltoSax'

        if smoothing:
            smoothStr = ' with smoothing'
            smoothSave = 'WS'
        else:
            smoothStr = ''
            smoothSave = ''

        absMeanStamps = absMeanStamps.astype(int)
        fig1 = plt.figure(figsize=[12, 6])
        absMeanStamps[absMeanStamps < 0] = 0
        countsArr = np.zeros(np.max(absMeanStamps) + 1)
        for ind in absMeanStamps:
            countsArr[ind] = countsArr[ind] + 1
        x = np.arange(np.max(absMeanStamps) + 1)
        plt.bar(x, countsArr)
        plt.yticks(np.arange((np.max(countsArr) + 5), step=5))
        fig1.autofmt_xdate()
        plt.xlabel('Abs Mean of Segment Timestamp Differences (s)')
        plt.ylabel('Number of files')
        plt.suptitle(testGroup + ' Stamps' + smoothStr)
        if save:
            plt.savefig(saveLoc + testGroup + smoothSave + '.png')

def plotF1Histogram(f1Scores, plot=False):
    if plot:
        threshArr = np.arange(0.5, 1.1, 0.05)
        count = np.zeros(len(threshArr))
        for i in f1Scores:
            mask = i < threshArr
            firstTrue = np.where(mask)[0][0]
            count[firstTrue] += 1
        count = count[:-1]

        fig1 = plt.figure(figsize=[12, 4.8])
        x = np.arange(len(count))
        plt.bar(x, count)
        plt.xticks(x+0.5, np.round(threshArr[:-1], 2))
        fig1.autofmt_xdate()
        plt.xlabel('F1 Score of File')
        plt.ylabel('Number of files')

def plotGaussianOverDis(segmentPerc, mean, std, plotGaussian):
    if plotGaussian:

        threshArr = np.arange(0.0, 0.4, 0.015)
        count = np.zeros(len(threshArr))
        for i in segmentPerc:
            mask = i < threshArr
            firstTrue = np.where(mask)[0][0]
            count[firstTrue] += 1
        count = count[:-1]

        fig1 = plt.figure(figsize=[12, 4.8])
        x = np.arange(len(count))
        plt.bar(x, count)
        plt.xticks(x + 0.5, np.round(threshArr[:-1], 2))
        fig1.autofmt_xdate()
        plt.xlabel('Segment Percent Length of File')
        plt.ylabel('Number of files')
        gaussian = np.zeros(len(threshArr))
        # for x in np.arange(len(threshArr)):
        #     gaussian[x] = (1/(std * math.sqrt(2*math.pi))) * math.exp(-0.5 * ((threshArr[x] - mean) / std)**2)
        # plt.plot()

def plotPred(pred):
    x = np.arange(0, len(pred)) / 60
    fig = plt.figure(0, figsize=[12, 7])
    plt.ylim(0,1)
    plt.plot(x, pred)