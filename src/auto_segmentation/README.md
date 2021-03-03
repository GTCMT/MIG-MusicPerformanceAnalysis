# AutoSegmentation
Creating a music/nonmusic classifier for auto-segmentation of All-State Band audition recordings.

The goal is to automatically locate the timestamps for the beginning and ending of each of the 5 all state audition exercises.

Use overview:

As a user you will use the main.py script. There is a wrapper function written in main.py that encapsulates two primary functions for one continuous process. This is the easiest way to process new data as the scripts are intended to be primarily used for. This function is called newData() and has the following parameters:

    - audioDirectory: the directory of the raw mp3 files

    - writeAddress: the location where the text files should be written to

    - modelPath: the path to the model that will be used for the classification SVM

    - generateDataReport: a boolean that allows user to specify if they would like a dataReport text file to be automatically generated detailing information about the classification process

    - keepNPZFiles: a boolean that allows user to specify if they would like to keep the npz files in the directory, or automatically delete them upon completion of the classification process.

    - numberOfMusicalExercises: the number of musical exercises, defaults to 5 which is the historical number of exercises but if it changes in the future this will need to be changed for successful classifications.
    
    
If you would like to use these steps individually for any particular reason they are broken up as follows:

1. The writing of numpy feature matrices for each audition file to be written to individual NPZ files

    This is done by calling fileWrite() and the input parameters are as follows:
    
        - audioDirectory: the directory path in which the audio files are located. The standard organization is that each mp3 file will be enclosed in a folder with that audition number. 
          
          ex. a directory with 3 auditions would have 3 folders named 83123, 84562, and 87654. Each of these folders would contain the respective
          mp3 files 83123.mp3, 84562.mp3, and 87654.mp3.
          
        - textDirectory: this is the directory of pregenerated text files for annotated data. If this function is processing new data, this parameter should be left blank to default to an empty string.
     
        - writeDirectory: this is the directory to which the npz files will be written to
     
        - writeFiles: gives the option to not write the npz files if the function is only being used to learn something about the data set but not continue with the standard process.
     
        - newData: this parameter defaults to true, but if this function is being used with annotated data, then set this to False to indicate that the groundTruth annotation data should be processed and included in the npz file.

  2. The classification of these npz files generated in step one using newDataClassificationWrite() with these input parameters:
  
         - directory: the path to the directory of npz files for classification
         
         - writeAddress: the location to write the output annotation text files to
         
         - modelPath: the path to the model that will be used for the classification SVM
         
         - generateDataReport: a boolean that allows user to specify if they would like a dataReport text file to be automatically generated detailing information about the classification process
         
         - keepNPZFiles: a boolean that allows user to specify if they would like to keep the npz files in the directory, or automatically delete them upon completion of the classification process.
         
         - numberOfMusicalExercises: the number of musical exercises, defaults to 5 which is the historical number of exercises but if it changes in the future this will need to be changed for successful classifications.
         
 
