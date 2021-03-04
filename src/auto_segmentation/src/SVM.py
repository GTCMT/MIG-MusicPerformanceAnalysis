import numpy as np
from sklearn import svm
from DataParsing import*
from PostProcessingVisuals import*
from sklearn.metrics import precision_score
from sklearn.metrics import recall_score
from sklearn.metrics import f1_score
from sklearn.metrics import plot_confusion_matrix
import matplotlib.pyplot as plt
import math
import time
import os
import pickle

def newDataClassificationWrite(directory, writeAddress, modelPath, generateDataReport=False, keepNPZFiles=True,
                               numberOfMusicalExercises=5):

    # Loads the SVM model
    model = pickle.load(open(modelPath, 'rb'))

    # Initializations
    flaggedFileList = np.array([])
    firstPassFilesList = np.array([])
    secondPassFilesList = np.array([])
    secondPassDataDict = np.array([])
    musLengths = np.empty([numberOfMusicalExercises])
    nonMusTLengths = np.empty([numberOfMusicalExercises])
    fileLength = np.empty([1])
    correctSegFileCount = 0
    shortestSegOnlyBool = False

    for entry in os.listdir(directory):
        if os.path.isfile(os.path.join(directory, entry)) and entry[-4:] == '.npz':

            try:
                featOrder, featArr, _, _, blockTimes = fileOpen(directory + '/' + entry)
                rawClassification = model.predict(featArr)
                rawClassification -= 1
                segmentsCount = numberOfMusicalExercises * 2
                postProcessedPreds, correctSegBool = postProc(rawClassification, True, False, False, segmentsCount)

                postProcessSegmentCount = countSegments(postProcessedPreds)

                if correctSegBool:
                    writeText(postProcessedPreds, blockTimes, entry[:-4], writeAddress)
                    firstPassFilesList = np.append(firstPassFilesList, entry)
                    correctSegFileCount += 1

                    nonMusTimeLengths, musTimeLengths, _, _, _, length, _, _, _ = segmentLengths(postProcessedPreds,
                                                                                                 blockTimes)
                    fileLength = np.append(fileLength, length)
                    musLengths = np.vstack((musLengths, musTimeLengths))
                    nonMusTLengths = np.vstack((nonMusTLengths, nonMusTimeLengths))

                    correctSegBool = False

                elif postProcessSegmentCount < 10 or postProcessSegmentCount > 25:
                    flaggedFileList = np.append(flaggedFileList, entry)

                else:
                    secondPassFilesList = np.append(secondPassFilesList, entry)
                    secondPassDataDict = np.append(secondPassDataDict, {"entry": entry, "procPred": postProcessedPreds,
                                                                        "blockTimes": blockTimes})
            except:
                print("Error with " + entry[:-4])
                flaggedFileList = np.append(flaggedFileList, entry)

    # Second pass data calculations
    firstPassSegLengthTimes = musLengths[1:, :]
    firstPassNonMusLengthTimes = nonMusTLengths[1:, :]
    firstPassFullFileLengths = fileLength[1:]
    firstPassSegmentPercents = firstPassSegLengthTimes / firstPassFullFileLengths.T[:, None]
    firstpassNonMusTLengths = firstPassNonMusLengthTimes.mean(0)
    firstPassNonMusTStd = firstPassNonMusLengthTimes.std(0)
    segmentPercMean = firstPassSegmentPercents.mean(0)
    segmentPercStd = firstPassSegmentPercents.std(0)

    ################ Second pass begins ###################

    # If this is true, the shortest segment removal process alone is implemented for the remaining files
    if correctSegFileCount < 25 or (correctSegFileCount/(correctSegFileCount + flaggedFileList.size +
                                                        secondPassFilesList.size)) < 0.25:
        shortestSegOnlyBool = True

        flipShortestUntilSegmentCount = numberOfMusicalExercises * 2

        for i in np.arange(len(secondPassDataDict)):
            try:
                entry = secondPassDataDict[i]["entry"]
                procPred = secondPassDataDict[i]["procPred"]
                blockTimes = secondPassDataDict[i]["blockTimes"]

                pred = processFlipSeg(procPred, flipShortestUntilSegmentCount, segmentPercMean, segmentPercStd,
                                      firstpassNonMusTLengths, firstPassNonMusTStd, blockTimes)

                writeText(pred, blockTimes, entry[:-4], writeAddress)
            except:
                print("Error with " + entry)

    # This includes the informative process
    else:
        flipShortestUntilSegmentCount = (numberOfMusicalExercises * 2) + 2

        for i in np.arange(len(secondPassDataDict)):
            try:
                entry = secondPassDataDict[i]["entry"]
                procPred = secondPassDataDict[i]["procPred"]
                blockTimes = secondPassDataDict[i]["blockTimes"]

                pred = processFlipSeg(procPred, flipShortestUntilSegmentCount, segmentPercMean, segmentPercStd,
                                      firstpassNonMusTLengths, firstPassNonMusTStd, blockTimes)

                writeText(pred, blockTimes, entry[:-4], writeAddress)

            except:
                print("Error with " + entry)
                flaggedFileList = np.append(flaggedFileList, entry)

    # Generate report txt file
    if generateDataReport:
        newDataReport(flaggedFileList, writeAddress, correctSegFileCount, firstPassFilesList, secondPassFilesList,
                      shortestSegOnlyBool)

    if keepNPZFiles != True:
        for entry in os.listdir(directory):
            if os.path.isfile(os.path.join(directory, entry)) and entry[-4:] == '.npz':
                os.remove(directory + "/" + entry)

def training(trainingDirectory):
    counter = 0
    gData = np.array([])
    for entry in os.listdir(trainingDirectory):
        if os.path.isfile(os.path.join(trainingDirectory, entry)) and entry[-4:] == '.npz':

            featOrder, featArr, gTruth, truthWindow = fileOpen(trainingDirectory + '/' + entry)
            if counter == 0:
                featureData = featArr
            else:
                featureData = np.append(featureData, featArr, axis=0)
            gData = np.append(gData, gTruth)
            counter += 1
    clf = svm.SVC(kernel='linear')
    clf.fit(featureData, gData)

    return clf


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

def postProc(predictions, smoothing=False, remNonMus=False, remMus=False, segCount=10):

    predictions[0] = 0

    if smoothing:
        predDiff = np.diff(predictions)
        predFixed = np.copy(predictions)

        # Fixes 0 1 0
        m3 = np.where(predDiff == 1)[0]
        if np.sum(m3 >= len(predDiff) - 2) > 0:
            m3 = m3[:-np.sum(m3 >= len(predDiff) - 1)]
        m4 = m3[np.where(predDiff[m3 + 1] == -1)[0]] + 1
        predFixed[m4] = 0.0

        # Recalculates diff
        predDiff = np.diff(predFixed)

        # Fixes 1 0 1
        m1 = np.where(predDiff == -1)[0]
        if np.sum(m1 >= len(predDiff) - 2) > 0:
            m1 = m1[:-np.sum(m1 >= len(predDiff) - 1)]
        m2 = m1[np.where(predDiff[m1 + 1] == 1)[0]] + 1
        predFixed[m2] = 1.0

        predictions = predFixed
        correctSegBool = segCount <= countSegments(predictions, [], False) <= (segCount + 1)

    return predictions, correctSegBool

def processFlipSeg(predictions, segCount, dataMean, dataStd, nonMusMean, nonMusStd, blockTimes):

    numSeg = countSegments(predictions)

    nonMusTimeLengths, musTimeLengths, nonMusSectionLengths, musSectionLengths, \
    segPerc, fileLength, musToNonMus, nonMus, nonMusToMus = segmentLengths(predictions, blockTimes)

    if numSeg > (segCount + 1):

        # while(numSeg > 11 or np.min(nonMusSectionLengths[nonMusSectionLengths > 0]) < 2):
        while (numSeg > (segCount + 1)):

            nonMusTimeLengths, musTimeLengths, nonMusSectionLengths, musSectionLengths, \
            segPerc, fileLength, musToNonMus, nonMus, nonMusToMus = segmentLengths(predictions, blockTimes)

            # plotPred(predictions)

            shortMus = np.argmin(musSectionLengths[musSectionLengths > 0])

            musLenLimit = 3
            windowCheckSize = 6


            if musSectionLengths[shortMus] <= musLenLimit:
                startInd = nonMus[shortMus] + 1
                endInd = musToNonMus[shortMus+1] + 1

                if startInd < windowCheckSize + 1:
                    checkLeft = predictions[1:startInd]
                else:
                    checkLeft = predictions[startInd-windowCheckSize:startInd-1]

                if len(predictions) - endInd < windowCheckSize + 1:
                    checkRight = predictions[endInd:-1]
                else:
                    checkRight = predictions[endInd+1:endInd+windowCheckSize]

                if (np.sum(checkLeft) + np.sum(checkRight)) < windowCheckSize:
                    predictions[startInd:endInd] = 0
                    musSectionLengths[shortMus] = np.max(musSectionLengths)
                    numSeg = countSegments(predictions)
                    # plt.clf()
                    continue

            shortNonMus = np.argmin(nonMusSectionLengths[1:]) + 1
            startInd = musToNonMus[shortNonMus] + 1
            endInd = nonMusToMus[shortNonMus] + 1
            predictions[startInd:endInd] = 1
            nonMusSectionLengths[shortNonMus] = np.max(nonMusSectionLengths)
            numSeg = countSegments(predictions)


        #     plt.clf()
        # plotPred(predictions)
        # plt.clf()

        nonMusTimeLengths, musTimeLengths, nonMusSectionLengths, musSectionLengths, \
        segPerc, fileLength, musToNonMus, nonMus, nonMusToMus = segmentLengths(predictions, blockTimes)

    if 12 <= numSeg <= 13:
        segFlip, startInd, endInd, flipTo = calcProbability(predictions, nonMusSectionLengths,
                                                    musSectionLengths, dataMean, dataStd, nonMusMean, nonMusStd,
                                                            blockTimes)

        # plotPred(predictions)
        predictions[startInd:endInd] = flipTo
        # plt.clf()
        # plotPred(predictions)
        # plt.clf()

    return predictions

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

def countSegments(procPred, segmentsArr=[], use=False):

    diffArr = np.diff(procPred)
    numSeg = (np.sum(np.abs(diffArr))+1)
    if use:
        segmentsArr = np.append(segmentsArr, numSeg)
        return segmentsArr, numSeg
    return numSeg

def segmentLengths(predictions, blockTimes=[]):

    predDiff = np.diff(predictions * 1)
    musToNonMus = np.where(predDiff == -1)[0]
    nonMusToMus = np.where(predDiff == 1)[0]
    nonMus = np.copy(nonMusToMus)
    musToNonMus = np.insert(musToNonMus, 0, 0)
    nonMus = np.append(nonMus, len(predictions) - 1)
    if len(musToNonMus) > len(nonMusToMus):
        nonMusToMus = np.append(nonMusToMus, len(predictions) - 1)
    elif len(nonMusToMus) > len(musToNonMus):
        musToNonMus = np.append(musToNonMus, len(predictions))
        nonMusToMus = nonMusToMus[1:]
        nonMusToMus = np.append(nonMusToMus, musToNonMus[-1])
    else:
        nonMus = nonMus[:-1]

    nonMusSectionLengths = nonMusToMus - musToNonMus
    mus = np.copy(musToNonMus)

    if len(nonMus) > len(musToNonMus)-1 and len(nonMus) > 5:
        nonMus = nonMus[:-1]
    elif len(nonMus) > len(musToNonMus)-1:
        mus = np.append(mus, len(predictions) - 1)

    musSectionLengths = mus[1:] - nonMus

    fileLength = 0
    segPerc = 0
    nonMusTimeLengths = 0
    musTimeLengths = 0


    if blockTimes != []:
        nonMusTimeLengths = blockTimes[nonMusToMus] - blockTimes[musToNonMus]
        musTimeLengths = blockTimes[mus[1:] - 1] - blockTimes[nonMus - 1]
        fileLength = blockTimes[-1]
        segPerc = musSectionLengths / fileLength

    if len(nonMusTimeLengths[1:]) < 5:
        nonMusTimeLengths = np.append(nonMusSectionLengths, 0)

    nonMusTimeLengths = nonMusTimeLengths[1:]


    return nonMusTimeLengths, musTimeLengths, nonMusSectionLengths, musSectionLengths, segPerc, fileLength, musToNonMus, nonMus, nonMusToMus

def calcProbability(predictions, nonMusSectionLengths, musSectionLengths, dataMean, dataStd, nonMusMean, nonMusStd,
                    blockTimes):

    i = 0
    mus = True
    probArray = np.array([])
    predCopy = np.copy(predictions)
    startArr = np.array([])
    endArr = np.array([])

    startInd = 0
    endInd = nonMusSectionLengths[0] + 1

    startArr = np.append(startArr, startInd)
    endArr = np.append(endArr, endInd)

    while (i < len(musSectionLengths) or i < len(nonMusSectionLengths)):
        if not mus:
            if (i > len(nonMusSectionLengths)-1):
                break

            startInd = endInd
            endInd += nonMusSectionLengths[i]

            if (endInd >= len(predictions)):
                break

            mus = True

            predCopy[startInd:endInd + 1] = 1

            nonMusTimeLengths, _, _, _, segPerc, _, _, _, _ = segmentLengths(predCopy, blockTimes)
        else:
            if (i > len(musSectionLengths)-1):
                break

            startInd = endInd
            endInd += musSectionLengths[i]

            if (endInd >= len(predictions)):
                break

            mus = False

            predCopy[startInd:endInd] = 0

            nonMusTimeLengths, _, _, _, segPerc, _, _, _, _ = segmentLengths(predCopy, blockTimes)
            i += 1

        startArr = np.append(startArr, startInd)
        endArr = np.append(endArr, endInd)

        segProbabilities = np.array([])
        for y in np.arange(len(segPerc)):
            musProb = (1/(dataStd[y] * math.sqrt(2*math.pi))) * \
                      math.exp(-0.5 * ((segPerc[y] - dataMean[y]) / dataStd[y])**2)
            nonMusProb = (1/(nonMusStd[y] * math.sqrt(2*math.pi))) * \
                         math.exp(-0.5 * ((nonMusTimeLengths[y] - nonMusMean[y]) / nonMusStd[y])**2)
            newProb = musProb * nonMusProb
            segProbabilities = np.append(segProbabilities, newProb)

        prod = 1
        for x in np.arange(len(segProbabilities)):
            prod *= segProbabilities[x]
        probArray = np.append(probArray, prod)
        predCopy = np.copy(predictions)

    # plotPred(predictions)
    segFlip = np.argmax(probArray) + 1
    if segFlip >= len(startArr):
        segFlip = len(startArr) - 1
    startInd = int(startArr[segFlip])
    endInd = int(endArr[segFlip])
    flipTo = 0
    if (segFlip % 2 == 0):
        flipTo = 1


    return segFlip, startInd, endInd, flipTo

def writeText(array, blockTimes, entry, address):
    newFile = open(address + "/" + entry + ".txt", "w")
    stampArr = getStamps(array, blockTimes)
    outputStr = ""
    for i in np.arange(stampArr.size / 2):
        index1 = int(i * 2)
        index2 = int(i * 2 + 1)
        if index2 >= stampArr.size:
            stampArr = np.append(stampArr, blockTimes[-1])
        outputStr = outputStr + str(np.round(stampArr[index1], 9)) + "\t" + "1\t" + \
                    str(np.round(stampArr[index2] - stampArr[index1], 9)) + "\n"
    newFile.write(outputStr[:-1])
    newFile.close()

def getStamps(array, blockTimes):
    diffArr = np.diff(array)
    changePoints = np.where(diffArr != 0)[0] - 1
    return np.array(blockTimes[changePoints])

def newDataReport(flaggedFileList, writeAddress, correctSegFileCount, firstPassFilesList, secondPassFilesList,
                  shortestSegOnlyBool):
    reportFile = open(writeAddress + "/00DataReport.txt", "w")
    writeStr = ""
    if shortestSegOnlyBool:
        writeStr += "There were not enough files with the correct number of segments after smoothing for the " \
                    "informative process to be viable, so the shortest segment removal process was used for all " \
                    "files. This will most likely decrease prediction accuracy.\n\n"
    writeStr += "Total file count: " + str(flaggedFileList.size + correctSegFileCount + secondPassFilesList.size) + "\n"
    writeStr += "Correct initial file count: " + str(correctSegFileCount) + "\n"
    writeStr += "Second pass file count: " + str(secondPassFilesList.size) + "\n"
    writeStr += "Flagged file count: " + str(flaggedFileList.size) + "\n"
    writeStr += "\nFlagged files:\n"

    for i in np.arange(flaggedFileList.size):
        writeStr += str(flaggedFileList[i][:-4]) + "\n"

    writeStr += "\nPrediction confidence:\n"

    for j in np.arange(firstPassFilesList.size):
        writeStr += str(firstPassFilesList[j][:-4]) + " 1.0\n"

    writeStr += "\n"

    for x in np.arange(secondPassFilesList.size):
        writeStr += str(secondPassFilesList[x][:-4]) + " 0.5\n"

    reportFile.write(writeStr[:-1])
    reportFile.close()
