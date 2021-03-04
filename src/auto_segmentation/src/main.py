import os
from librosa.core import load
import numpy as np
import scipy as sc
from DataParsing import*
from SVM import*
import pickle


def newData(audioDirectory, writeAddress, modelPath, generateDataReport=True, keepNPZFiles=True,
            numberOfMusicalExercises=5):
    _ = fileWrite(audioDirectory, '', writeAddress)

    newDataClassificationWrite(writeAddress, writeAddress, modelPath, generateDataReport, keepNPZFiles,
                               numberOfMusicalExercises)

# FULL NEW DATA PROCESS ***************************************

audioDirectory = "/Users/matthewarnold/Desktop/AutoSeg Local/AudioRepo/2014_CB_BariSax"
npzDirectory = "/Users/matthewarnold/Desktop/AutoSeg Local/NPZ Repo/NewDataNPZ/2018/test"
writeDirectory = "/Users/matthewarnold/Desktop/AutoSeg Local/TextOutput/2014_CB_BariSax"
modelPath = '../Models/2017ABAI.sav'
generateDataReport = True
keepNPZFiles = False
numberOfMusicalExercises = 5

newData(audioDirectory, writeDirectory, modelPath, generateDataReport, keepNPZFiles, numberOfMusicalExercises)
# newDataClassificationWrite(writeDirectory, writeDirectory, modelPath, generateDataReport, keepNPZFiles,
#                                numberOfMusicalExercises)