function copySongsToFolder(BAND_OPTION, INSTRUMENT_OPTION, YEAR_OPTION, output_dir)

% AP@GTCMT, 2017
% objective: copy the songs for which annotations are not available
%
% INPUTS
% BAND_OPTION: string for one of the three band options we have
% INSTRUMENT_OPTIONS: string for one of the instrument options we have
% YEAR_OPTION: string for one of the year options we have
% output_dir: full path to the output directory for copying files to  

% get student-ids for missing annotations
student_ids = findMissingAnnotations(BAND_OPTION, INSTRUMENT_OPTION, YEAR_OPTION);

% get path to the audio files
if YEAR_OPTION == '2013'
    year_folder = '2013-2014';
elseif YEAR_OPTION == '2014'
    year_folder = '2014-2015';
elseif YEAR_OPTION == '2015'
    year_folder = '2015-2016';
else
    disp('Error in year option');
end
FBA_RELATIVE_PATH = ['../../../../FBA2013data/', year_folder];
audio_filepaths = scanFilePaths(FBA_RELATIVE_PATH, student_ids, YEAR_OPTION);

% copy files to output directory
for i = 1:length(audio_filepaths)
   full_path = fullfile(pwd, audio_filepaths{i}); 
   command = ['cp ', full_path, ' ', output_dir]; 
   system(command); 
end


end