import os
from librosa.core import load
import numpy as np
import scipy as sc
from ProcessInput import*
from Classification_Annotation import*
from Training import*
import pickle

def annotateNewData(audioDirectory, writeAddress, modelPath, fileList=None, generateDataReport=True, keepNPZFiles=True,
            numberOfMusicalExercises=5):

    _ = writeFeatureData(audioDirectory, '', writeAddress, fileList)

    classifyFeatureData(writeAddress, writeAddress, modelPath, generateDataReport, keepNPZFiles,
                               numberOfMusicalExercises)

# FULL NEW DATA PROCESS ***************************************

audioDirectory = "/Users/matthewarnold/Desktop/AutoSeg Local/AudioRepo/test"
writeDirectory = "/Users/matthewarnold/Desktop/AutoSeg Local/TextOutput/test"
modelPath = '../Models/2017ABAI.sav' #This is the model with best results from testing
generateDataReport = True
keepNPZFiles = False
numberOfMusicalExercises = 5

fileList = []

annotateNewData(audioDirectory, writeDirectory, modelPath, fileList, generateDataReport, keepNPZFiles,
                numberOfMusicalExercises)



# TO TRAIN NEW MODEL *******************************************

# # Directory for training data
# trainingDirectory = "/Users/matthewarnold/Desktop/AutoSeg Local/AudioRepo/test"
#
# # Where model file should be written to and what filename
# writeAddress = '../Models/'
# modelFileName = "testModel"
#
# # If data is audio, True; if data is feature data npz, False
# isAudio = True
#
# # If isAudio is true, textAddress for annotations of data is needed as well
# textAddress = "/Users/matthewarnold/Desktop/AutoSeg Local/TextRepo/test"
#
# training(trainingDirectory, writeAddress, modelFileName, isAudio, textAddress)