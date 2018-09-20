'''
This script is created to fix the broken tracks in FBA dataset by converting the audio
into m4a format first and convert it back to mp3
before applying this fix, please make sure the following packages have been installed on your computer
1. homebrew
2. ffmpeg (can be easily installed using>> brew install ffmpeg)
'''

import os

#=== set the folder to your directory================
inputFolder = '/Users/cw/Downloads/'
outputFolder = '/Users/cw/Downloads/fixed/'
#====================================================

def fixBrokenFiles(inputFilePath, outputFilePath):
    command_broken2m4a = 'ffmpeg -i ' + inputFilePath + ' -c copy ' + 'temp.m4a'
    command_m4a2mp3 = 'ffmpeg -i temp.m4a -acodec libmp3lame -ab 128k -ar 44100 ' + outputFilePath
    os.system(command_broken2m4a)
    os.system(command_m4a2mp3)
    os.system('rm temp.m4a')
    print 'Filename = ' + inputFilePath + ' is fixed'

#==== main script to fix the tracks ====
fileList = os.listdir(inputFolder)
for file in fileList:
    if file[-3:] == 'mp3':
        inputFilePath = inputFolder + file
        outputFilePath = outputFolder + file
        fixBrokenFiles(inputFilePath, outputFilePath)
print 'CONGRATS!!!!'
print 'ALL FIXED!!'