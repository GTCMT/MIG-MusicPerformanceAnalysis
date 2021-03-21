import numpy as np
from sklearn import svm
from ProcessInput import*
from Visuals import*
import os
import pickle

#This function is used for creating new models from the files in the training directory

def training(trainingDirectory, writeDirectory, modelFileName, isAudio=False, textAddress=""):

    if isAudio:
        writeFeatureData(trainingDirectory, textAddress, trainingDirectory, None, True, False)

        counter = 0
        gData = np.array([])
        for entry in os.listdir(trainingDirectory):
            if os.path.isfile(os.path.join(trainingDirectory, entry)) and entry[-4:] == '.npz':

                featOrder, featArr, gTruth, truthWindows, blockTimes = fileOpen(trainingDirectory + '/' + entry)
                # featOrder, featArr, gTruth, truthWindow = fileOpen(trainingDirectory + '/' + entry)
                if counter == 0:
                    featureData = featArr
                else:
                    featureData = np.append(featureData, featArr, axis=0)
                gData = np.append(gData, gTruth)
                counter += 1
        clf = svm.SVC(kernel='linear')
        clf.fit(featureData, gData)

        pickle.dump(clf, open(writeDirectory + "/" + modelFileName + ".sav", 'wb'))

        for entry in os.listdir(trainingDirectory):
            if os.path.isfile(os.path.join(trainingDirectory, entry)) and entry[-4:] == '.npz':
                os.remove(trainingDirectory + "/" + entry)

    else:
        counter = 0
        gData = np.array([])
        for entry in os.listdir(trainingDirectory):
            if os.path.isfile(os.path.join(trainingDirectory, entry)) and entry[-4:] == '.npz':

                featOrder, featArr, gTruth, truthWindows, blockTimes = fileOpen(trainingDirectory + '/' + entry)
                if counter == 0:
                    featureData = featArr
                else:
                    featureData = np.append(featureData, featArr, axis=0)
                gData = np.append(gData, gTruth)
                counter += 1
        clf = svm.SVC(kernel='linear')
        clf.fit(featureData, gData)

        pickle.dump(clf, open(writeDirectory + "/" + modelFileName + ".sav", 'wb'))