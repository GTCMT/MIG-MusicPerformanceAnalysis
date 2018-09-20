%% get the distribution information of judges' grading
% CW @ GTCMT 2016
% Input:
%   band_option = string: 'middle', 'concert', or 'symphonic' 
%   instrument_option = string: full name of the instrument (ex. 'Flute') 
%   segment_option = string to specify the segment (10 in total)
%   year_option = which year do you want to plot for (2013, 2014, 2015)
% Output:
%   assessments = float matrix, numStudents by numCategories
%   categoryName = string cell vector, numCategories by 1
%   idx = int vector, corresponding category index

function [assessments, categoryName, idx] = getDistributionInfo(band_option, instrument_option, segment_option, year_option)

if ismac
    % Code to run on Mac plaform
    slashtype='/';
elseif ispc
    % Code to run on Windows platform
    slashtype='\';
end

% set parameter 
addpath(['..' slashtype '..' slashtype 'scanning' slashtype]);
fba_relative_path = ['..' slashtype '..' slashtype '..' slashtype 'FBA' year_option slashtype];
score_option = [];

% get assessments 
audition_metadata = scanFBA(fba_relative_path, band_option, ...
                                     instrument_option, segment_option, ...
                                     score_option, year_option);
                                 
% organize information 
numStudents = length(audition_metadata.assessments);                                 
idx = find(audition_metadata.assessments{1} ~= -1);
assessments = zeros(numStudents, length(idx));
categoryName = cell(length(idx), 1);

for i = 1:length(idx)
    currentCategory = idx(i);
    for j = 1:numStudents
        assessments(j, i) = audition_metadata.assessments{j}(currentCategory);
    end
    
    categoryName{i} = getCategoryName(currentCategory);
    segmentName = getSegmentName(segment_option);
end
clc;
fprintf('=== quick summary: === \n');
fprintf('number of students = %g\n', numStudents);
fprintf('number of categories = %g\n', length(idx));
rmpath('../../scanning/');