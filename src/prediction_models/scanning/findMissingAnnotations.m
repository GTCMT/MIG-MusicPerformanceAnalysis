function student_ids = findMissingAnnotations(BAND_OPTION, INSTRUMENT_OPTION, YEAR_OPTION)

% AP@GTCMT, 2017
% objective: find the student-ids for which annotations are not available
%
% INPUTS
% BAND_OPTION: string for one of the three band options we have
% INSTRUMENT_OPTIONS: string for one of the instrument options we have
% YEAR_OPTION: string for one of the year options we have
%
% OUTPUTS
% student_ids: 1xnum_students int, containing student ids

student_ids = scanStudentIds(BAND_OPTION, INSTRUMENT_OPTION, YEAR_OPTION);
seg = scanSegments(2, student_ids, YEAR_OPTION);
a = cellfun(@isempty, seg);
student_ids = student_ids(a);

end


