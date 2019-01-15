%% SCANSTUDENTIDS Return student Ids for given band and instrument
%
% input:
%   band_option (string): 'middle', 'concert' or 'symphonic'
%   instrument_option (string): instrument
%   rooth_path (string): path to /prediction_models.
%
%   Instruments (incomplete list?):
%     Alto Saxophone
%     Bari Saxophone
%     Bass Clarinet
%     Bass Trombone
%     Bassoon
%     Bb Clarinet
%     Bb Contrabass Clarinet
%     EbClarinet
%     English Horn
%     Euphonium
%     Flute
%     French Horn
%     Oboe
%     Percussion
%     Piccolo
%     Tenor Saxophone
%     Trombone
%     Trumpet
%     Tuba
%
% output:
%   N-by-1 vector of student ids
function [student_ids] = scanStudentIds(band_option, instrument_option, year_option)
root_path = deriveRootPath();

if ismac
    % Code to run on Mac plaform
    slashtype='/';
elseif ispc
    % Code to run on Windows platform
    slashtype='\';
end

% path to excel file:
xls_path = ['..' slashtype '..' slashtype '..' slashtype 'MIG-FbaData' slashtype 'FBA' year_option];

switch band_option
    case 'middle'
        file_name = 'middleschool/excelmiddleschool';
    case 'concert'
        file_name = 'concertband/excelconcertband';
    case 'symphonic'
        file_name = 'symphonicband/excelsymphonicband';
    otherwise
        disp(['Invalid band option. Options: ' char(39) 'middle' char(39) ', ' char(39) 'concert' char(39) ' or ' char(39) 'symphonic' char(39) '.']);
        return;
end

%these lines not working for virtual lab / Windows environment somehow
% file_path = [root_path xls_path slashtype file_name];
% [num,text] = xlsread(file_path, 1);

% therefore this hack
old_path=pwd;
file_path = [root_path xls_path];
cd(file_path);
[num,text] = xlsread(file_name, 1);
cd(old_path);

% find index of first id for this instrument:
index = 1;
while strcmp(text(index,1), instrument_option) == 0
    index = index+1;
end

index       = index-2;
student_ids = [];

while isnan(num(index)) == 0 
    student_ids = [student_ids ; num(index)];
    index       = index+1;  
end

%% TODO: move this to a .txt file in the MIG-FbaData repo
% list which studen-ids are to be skipped
if strcmp(band_option, 'middle')
    ids2skip = [29429, 32951, 42996, 43261, 44627, 56948, 39299, 39421, 41333, 42462, 43811, 44319, 61218, 29266, 33163, 34430, 53333, 53677]';
elseif strcmp(band_option, 'symphonic')
    ids2skip = [33026, 33476, 35301, 41602, 52950, 53083, 46038, 33368, 42341, 51598, 56778, 56925, 30430, 55642, 60935, 45801]';
end
student_ids = setdiff(student_ids, ids2skip);

end