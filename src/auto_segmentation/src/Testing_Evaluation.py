import numpy as np
from sklearn import svm
from ProcessInput import*
from Visuals import*
from sklearn.metrics import precision_score
from sklearn.metrics import recall_score
from sklearn.metrics import f1_score
from sklearn.metrics import plot_confusion_matrix
import matplotlib.pyplot as plt
import math
import time
import os
import pickle

def testing(testingDirectory, model, smoothing=True):

    # Plotting and boolean instantiations
    num = 1
    totBinResults = np.empty([7])
    totConfResults = np.array([0, 0, 0, 0])
    totStamps = np.empty([10])
    threshArr = np.arange(0, 20) * 0.5
    pCount = np.zeros(len(threshArr))
    nCount = np.zeros(len(threshArr))
    segmentsArr = np.array([])
    absMeanStamps = np.array([])
    musLengths = np.empty([5])
    nonMusTLengths = np.empty([5])
    fileLength = np.empty([1])
    badList = np.array([])
    badDict = np.array([])
    flagList = np.array([])
    goodCounter = 0
    badCounter = 0
    goodBool = False
    ts = time

    # Printing Booleans
    # Print Results
    resultsPrint = True

    # Print segments
    segmentsPrint = False

    # Plot/Save Histograms
    plotPredHist = False
    savePredHist = False
    savePredLoc = '/Users/matthewarnold/Desktop/AutoSeg Local/Plots/Histograms/Predictions/'

    plotSegHist = False
    saveSegHist = False
    saveSegLoc = '/Users/matthewarnold/Desktop/AutoSeg Local/Plots/Histograms/Segments/'

    plotStampHist = False
    saveStampHist = False
    saveStampLoc = '/Users/matthewarnold/Desktop/AutoSeg Local/Plots/Histograms/Stamps/'

    # Print Confusion matrix values
    printConf = False

    # Visualize predictions on gTruth
    viz = False
    saveViz = False
    savePlots = '/Users/matthewarnold/Desktop/AutoSeg Local/Plots/VisualizePreds/RemoveSeg/'

    # Plot f1 histogram
    f1Plot = False

    # Plot Gaussian over good files length distribution
    plotGaussian = False

    # Ignore Boundaries
    ignoreBoundaries = False

    # Remove extra segments
    remNonMus = False
    remMus = False

    # Print Stamp Measure
    stampPrint = True

    # Print music segment length info
    lengthPrint = False

    # Writes text files
    outputTextFiles = True
    txtAddress = "/Users/matthewarnold/Desktop/AutoSeg Local/TextOutput/2018_CB_BbClar"


    # File iteration process
    for entry in os.listdir(testingDirectory):
        if os.path.isfile(os.path.join(testingDirectory, entry)) and entry[-4:] == '.npz':

            featOrder, featArr, gTruth, truthWindow, blockTimes = fileOpen(testingDirectory + '/' + entry)
            preds = model.predict(featArr)

            preds -= 1
            gTruth -= 1

            procPred, goodBool = postProc(preds, smoothing, False, False)

            if outputTextFiles and goodBool:
                writeText(procPred, blockTimes, entry[:-4], txtAddress)

            if ~goodBool and countSegments(procPred) >= 10:
                badList = np.append(badList, entry)
                badDict = np.append(badDict, {"entry": entry, "procPred": procPred, "gTruth": gTruth,
                                              "truthWindow": truthWindow, "blockTimes": blockTimes})
                badCounter += 1
            elif countSegments(procPred) < 10 or countSegments(procPred) > 25:
                flagList = np.append(flagList, entry)

            try:
                binResults, confResults, pred, diffMat = evalAcc(procPred, gTruth, truthWindow, blockTimes, ignoreBoundaries)

                # if countSegments(pred, segmentsArr, False) >= 10:
                if goodBool:
                    goodCounter += 1
                    totConfResults += confResults
                    totStamps = np.vstack((totStamps, diffMat))
                    # absMeanStamps = np.append(absMeanStamps, np.mean(np.abs(diffMat)))
                    nonMusTimeLengths, musTimeLengths, _, _, _, length, _, _, _ = segmentLengths(pred, blockTimes)
                    fileLength = np.append(fileLength, length)
                    musLengths = np.vstack((musLengths, musTimeLengths))
                    nonMusTLengths = np.vstack((nonMusTLengths, nonMusTimeLengths))
                    totBinResults = np.vstack((totBinResults, binResults))
                    goodBool = False

            except:
                print("Check txt file for: " + entry[:-4])

            # Visualize Predictions on gTruth
            overlayPred(pred, gTruth, entry, num, viz, saveViz, savePlots)
            num += 1

            samples = len(gTruth)
            pCount, nCount, threshArr = histogramsPredCalc(confResults[1], confResults[2], threshArr, pCount, nCount, samples)

            if (segmentsPrint or plotSegHist):
                segmentsArr, numSeg = countSegments(pred, segmentsArr, True)

    # Second pass
    segCount = 12

    firstSetSegLengths = musLengths[1:, :]
    firstSetNonMusTLengths = nonMusTLengths[1:, :]
    firstSetfileLengths = fileLength[1:]
    firstSetSegPerc = firstSetSegLengths / firstSetfileLengths.T[:, None]
    goodNonMusTLengths = firstSetNonMusTLengths.mean(0)
    goodNonMusTStd = firstSetNonMusTLengths.std(0)
    segmentPercMean = firstSetSegPerc.mean(0)
    segmentPercStd = firstSetSegPerc.std(0)

    totalFileCount = goodCounter + badCounter
    finalStamps = np.zeros([totalFileCount, 10])
    finalFileLengths = np.zeros([totalFileCount])
    finalMusSegLengths = np.zeros([totalFileCount, 5])
    finalBinResults = np.zeros([totalFileCount, 7])

    finalStamps[0:goodCounter, :] = totStamps[1:, :]
    finalFileLengths[0:goodCounter] = fileLength[1:]
    finalMusSegLengths[0:goodCounter, :] = musLengths[1:, :]
    finalBinResults[0:goodCounter, :] = totBinResults[1:, :]

    segmentDist = 4
    plotGaussianOverDis(firstSetSegPerc[:, segmentDist], segmentPercMean[segmentDist], segmentPercStd[segmentDist],
                        plotGaussian)

    if goodCounter < 25:
        print("Not enough good files, shortest segment process implemented.")

        segCount = 10

        for i in np.arange(len(badDict)):
            finalIndex = goodCounter + i

            entry = badDict[i]["entry"]
            procPred = badDict[i]["procPred"]
            gTruth = badDict[i]["gTruth"]
            truthWindow = badDict[i]["truthWindow"]
            blockTimes = badDict[i]["blockTimes"]

            pred = processFlipSeg(procPred, segCount, segmentPercMean, segmentPercStd, goodNonMusTLengths,
                                  goodNonMusTStd, blockTimes)
            if outputTextFiles:
                writeText(pred, blockTimes, entry[:-4], txtAddress)

            binResults, confResults, pred, diffMat = evalAcc(pred, gTruth, truthWindow, blockTimes)

            totConfResults += confResults
            finalStamps[finalIndex] = diffMat
            # absMeanStamps = np.append(absMeanStamps, np.mean(np.abs(diffMat)))
            _, musTimeLengths, _, _, _, fileLength, _, _, _ = segmentLengths(pred, blockTimes)
            finalFileLengths[finalIndex] = fileLength
            finalMusSegLengths[finalIndex] = musTimeLengths
            finalBinResults[finalIndex] = binResults
    else:
        for i in np.arange(len(badDict)):
            finalIndex = goodCounter + i

            entry = badDict[i]["entry"]
            procPred = badDict[i]["procPred"]
            gTruth = badDict[i]["gTruth"]
            truthWindow = badDict[i]["truthWindow"]
            blockTimes = badDict[i]["blockTimes"]

            pred = processFlipSeg(procPred, segCount, segmentPercMean, segmentPercStd, goodNonMusTLengths,
                                  goodNonMusTStd, blockTimes)

            if outputTextFiles:
                writeText(pred, blockTimes, entry[:-4], txtAddress)
            try:
                binResults, confResults, pred, diffMat = evalAcc(pred, gTruth, truthWindow, blockTimes)
            except:
                print("Check txt file for: " + entry[:-4])

            totConfResults += confResults
            finalStamps[finalIndex] = diffMat
            # absMeanStamps = np.append(absMeanStamps, np.mean(np.abs(diffMat)))
            _, musTimeLengths, _, _, _, fileLength, _, _, _ = segmentLengths(pred, blockTimes)
            finalFileLengths[finalIndex] = fileLength
            finalMusSegLengths[finalIndex] = musTimeLengths
            finalBinResults[finalIndex] = binResults


    # Final calculations for metrics
    finalMetrics = finalBinResults.mean(0)

    stampMeanSeg = finalStamps.mean(0)
    stampAbsMeanSeg = np.abs(finalStamps).mean(0)
    stampStdevSeg = finalStamps.std(0)
    stampMean = np.mean(stampMeanSeg)
    stampAbsMean = np.mean(stampAbsMeanSeg)
    stampStdev = np.mean(stampStdevSeg)

    segmentLenMean = finalMusSegLengths.mean(0)
    segmentLenStd = finalMusSegLengths.std(0)
    segmentPercetages = finalMusSegLengths / finalFileLengths.T[:, None]
    segmentPercMean = segmentPercetages.mean(0)
    segmentPercStd = segmentPercetages.std(0)

    # Visuals and Metrics for full file set, rather than individual
    plotPredHistogram(pCount, nCount, threshArr, savePredLoc, smoothing, plotPredHist, savePredHist)
    plotSegHistogram(segmentsArr, saveSegLoc, smoothing, plotSegHist, saveSegHist)
    plotStampHistogram(absMeanStamps, saveStampLoc, smoothing, plotStampHist, saveStampHist)
    confusionMat(totConfResults, printConf)
    plotF1Histogram(finalBinResults[:, 4], f1Plot)

    # Print outputs
    with np.printoptions(precision=2, suppress=True):
        print(goodCounter)
        print(totalFileCount)
        if segmentsPrint:
            print(np.mean(segmentsArr))
        if resultsPrint:
            print(finalMetrics)
        if stampPrint:
            print("Mean distance:")
            print(stampMeanSeg)
            print(stampMean)
            print("Abs Mean:")
            print(stampAbsMeanSeg)
            print(stampAbsMean)
            print("Deviation:")
            print(stampStdevSeg)
            print(stampStdev)
        if lengthPrint:
            print("Percentages")
            print(segmentPercMean)
            print(segmentPercStd)
            print("Length(s)")
            print(segmentLenMean)
            print(segmentLenStd)
    return totBinResults

def evalAcc(predictions, truth, stampWindows, blockTimes, ignoreBoundaries=False):

    truth = np.array(truth.reshape((len(truth), )), dtype=bool)
    predictions = np.array(predictions.reshape((len(predictions), )), dtype=bool)

    if ignoreBoundaries:
        tDiff = np.diff(truth)
        switches = np.where(np.abs(tDiff) == 1)[0]
        predictions[switches + 1] = truth[switches + 1]
        predictions[switches] = truth[switches]

    pT = precision_score(truth, predictions)
    pF = precision_score(~truth, ~predictions)
    rT = recall_score(truth, predictions)
    rF = recall_score(~truth, ~predictions)
    fT = f1_score(truth, predictions)
    fF = f1_score(~truth, ~predictions)

    mask = (predictions == truth)
    accuracyT = np.sum(mask == truth)/np.sum(truth)
    accuracyF = np.sum(np.logical_and(mask, ~truth))/np.sum(~truth)
    accuracy = (accuracyT+accuracyF)/2
    binResults = np.array([pT, pF, rT, rF, fT, fF, accuracy])

    # false positives and negatives for histograms
    fP = np.sum(np.logical_and(~mask, predictions))
    fN = np.sum(np.logical_and(~mask, ~predictions))
    tP = np.sum(np.logical_and(mask, predictions))
    tN = np.sum(np.logical_and(mask, ~predictions))

    confResults = np.array([tN, fP, fN, tP])

    # deviation of time stamps
    predDiff = np.diff(predictions)
    predChange = np.where(abs(predDiff) == 1)[0]
    predStamps = np.empty((5, 2))
    if len(predChange) < 10:
        predStamps[4, 1] = blockTimes[-1]
    for x in np.arange(0, len(predChange)):
        if x >= 10:
            break
        if x % 2 == 0:
            predStamps[int(x/2), 0] = blockTimes[predChange[x] + 1]
        else:
            predStamps[int(x/2), 1] = blockTimes[predChange[x] + 1]
    # if negative, the prediction was early, if positive pred too late
    diffMat = np.array(predStamps - stampWindows)
    diffMat = np.reshape(diffMat, (1, 10))
    diffMat = np.squeeze(diffMat, axis=0)

    return binResults, confResults, predictions, diffMat