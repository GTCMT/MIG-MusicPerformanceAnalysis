%% Scan assessments
% AP@GTCMT 2018
% assessments = scanPyinPaths(student_ids)
% Return the path to the folder containing the Pyin Pitch Contours
% student_ids: N*1 int vector of student ids.
% band_option: band
% year_option: year
function pyin_paths = scanPyinPaths(student_ids, band_option, year_option)

if ismac
    % Code to run on Mac plaform
    slashtype='/';
elseif ispc
    % Code to run on Windows platform
    slashtype='\';
end

root_path = deriveRootPath();
annotation_path = [root_path '..' slashtype '..' slashtype '..' slashtype 'MIG-FbaData' slashtype 'FBA' year_option];
num_students = length(student_ids);
pyin_paths = cell(num_students, 1);

% Search all bands for student.
if strcmp(band_option, 'concert') == 1
    band_folder = [slashtype 'concertband/assessments'];
elseif strcmp(band_option, 'middle') == 1
    band_folder = [slashtype 'middleschool/assessments'];
elseif strcmp(band_option, 'symphonic') == 1
    band_folder = [slashtype 'symphonicband/assessments'];   
end


for student_idx = 1:num_students
    % Create file path.
    current_id = num2str(student_ids(student_idx));
    pyin_paths{student_idx} = [annotation_path band_folder slashtype current_id slashtype];
end