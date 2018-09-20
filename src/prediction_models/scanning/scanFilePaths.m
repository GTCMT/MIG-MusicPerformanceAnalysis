function [file_paths] = scanFilePaths(fba_relative_path, student_ids, year_option)
%SCANFILEPATHS Return the path to the audio file for each student id.
% 
% Input:
%   fba_relative_path (string): path to audio files.
%   student_ids (N-by-1 vector): vector of student Ids.
% 
% Output:
%   file_paths: N-by-1 cell array of strings containing audio file paths.
% 
% Assumes the audio files are contained in 3 folders: 
%   'concertbandscores/student_id/student_id.mp3'
%   'middleschoolscores/student_id/student_id.mp3'
%   'symphonicbandscores/student_id/student_id.mp3'

if ismac
    % Code to run on Mac plaform
    slashtype='/';
elseif ispc
    % Code to run on Windows platform
    slashtype='\';
end

if strcmp(year_option,'2013')
    folder_concert      = [fba_relative_path slashtype 'concertbandscores'];
    folder_middle       = [fba_relative_path slashtype 'middleschoolscores'];
    folder_symphonic    = [fba_relative_path slashtype 'symphonicbandscores'];
else
    folder_concert      = [fba_relative_path slashtype 'concertband'];
    folder_middle       = [fba_relative_path slashtype 'middleschool'];
    folder_symphonic    = [fba_relative_path slashtype 'symphonicband'];
end

N           = size(student_ids,1);
file_paths  = cell(size(student_ids));

for i = 1:N
    
    % see if the folder for this id exists:
    if exist([folder_concert slashtype num2str(student_ids(i))]) == 7
        file_paths{i} = [folder_concert slashtype num2str(student_ids(i)) slashtype num2str(student_ids(i)) '.mp3'];
        
    elseif exist([folder_middle slashtype num2str(student_ids(i))]) == 7
        file_paths{i} = [folder_middle slashtype num2str(student_ids(i)) slashtype num2str(student_ids(i)) '.mp3'];
        
	elseif exist([folder_symphonic slashtype num2str(student_ids(i))]) == 7
        file_paths{i} = [folder_symphonic slashtype num2str(student_ids(i)) slashtype num2str(student_ids(i)) '.mp3'];
        
    else
        disp(['File not found, id: ' num2str(student_ids(i)) '.']);
    end

end