function year_folder = getYearFolderString(year)
%% AP@GTCMT 2018
% objective: returns the folder name to scan for audio
% :param year: string, '2013', '2014', '2015'
% :return string,

if strcmp(year, '2013')
    year_folder = '2013-2014';
elseif strcmp(year, '2014')
    year_folder = '2014-2015';
elseif strcmp(year, '2015')
    year_folder = '2015-2016';
else
    disp('Error in year option');
end

end