function [labels, student_ids] = ...
    createTrainingLabels(BAND_OPTION, INSTRUMENT_OPTION, SEGMENT_OPTION, ...
    YEAR_OPTION, QUICK)
%% AP@GTCMT 2018
% objective: creates the training data based on the given arguments
% :param BAND_OPTION: string, band name, 'middle', 'concert' or 'symphonic'
% :param INSTRUMENT_OPTION: string, instrument name, 
%                           e.g. 'Alto Saxophone', 'Bb Clarinet', 'Flute'
% :param SEGMENT_OPTION: int, 1-5
% :param YEAR_OPTION: string, year, e.g. '2013', '2014', '2015'
% :param quick: 1 for prototyping, 0 to consider all students
% :return labels: NxL matrix, N - number of students, L - number of labels

% Read data from the database.
disp('Scanning database for metadata...');
student_ids = scanStudentIds(BAND_OPTION, INSTRUMENT_OPTION, YEAR_OPTION);
assessments = scanAssessments(SEGMENT_OPTION, student_ids, YEAR_OPTION);
disp('Done scanning database.');

%% TODO: Complete this for other segments
if SEGMENT_OPTION == 2 
    num_labels = 4;
else
    num_labels = sum(assessments{1} ~= -1);
end
num_students = length(student_ids);
% Reduce number of students for prototyping
if QUICK
    num_students = 10;
end

% Preallocate memory.
labels = zeros(num_students, num_labels);

% One student at a time.
for student_idx = 1:num_students
    disp(['Processing student: ' num2str(student_idx), ...
        ', student_id: ' num2str(student_ids(student_idx))]);
    
    % Store all assessments.
    %% TODO: complete this for other segments
    if SEGMENT_OPTION == 2
        segment_assessments = assessments{student_idx}(3:6);
        assert(~isempty(segment_assessments== -1));
    else
        segment_assessments = assessments{student_idx}(assessments{student_idx} ~= -1);
    end
    labels(student_idx, :) = segment_assessments;
end

end