%% Scan assessments
% CL@GTCMT 2015
% assessments = scanAssessments(assessment_option, student_ids)
% Return the assessments for each student, read from the *_assessments.txt
% file.
% segment_option = m*1 int vector, specify your target segments, ex: [3; 5]
% student_ids = N*1 int vector of student ids.
% root_path = relative path to the /prediction_models directory.
% assessments = N*1 cell vector, each cell is a F*G vector
%               N -> student_id's, F -> segment, G -> category (all 26).
%               For segment and category indices, see /FBA/README.txt.
%               Segments returned in order specified by segment_option.
function assessments = scanAssessments(segment_option, student_ids, year_option)

NUM_SEGMENTS = 10; % Rows.
NUM_CATEGORIES = 26; % Columns.

if ismac
    % Code to run on Mac plaform
    slashtype='/';
elseif ispc
    % Code to run on Windows platform
    slashtype='\';
end

root_path = deriveRootPath();
annotation_path = [root_path '..' slashtype '..' slashtype '..' slashtype 'MIG-FbaData' slashtype 'FBA' year_option];
num_chosen_segments = size(segment_option, 1);
num_students = length(student_ids);
assessments = cell(num_students,1);

for student_idx = 1:num_students
    % Create file path.
    current_id = num2str(student_ids(student_idx));
    
    % Search all bands for student.
    found_student = false;
    for band_idx = 1:3
        switch band_idx
            case 1
                band_folder = [slashtype 'concertband/assessments'];
            case 2
                band_folder = [slashtype 'middleschool/assessments'];
            case 3
                band_folder = [slashtype 'symphonicband/assessments'];
        end
        
        file_name = [slashtype current_id '_' 'assessments.txt'];
        file_path = [annotation_path band_folder slashtype current_id file_name];
        
        % Read assessment file.
        if (exist(file_path, 'file') == 2)
            all_current_assessments = dlmread(file_path, '\t', ...
                [1 0 NUM_SEGMENTS NUM_CATEGORIES-1]);
            current_assessments = zeros(num_chosen_segments, NUM_CATEGORIES);
            for segment_idx = 1:num_chosen_segments
                current_segment = segment_option(segment_idx);
                current_assessments(segment_idx, :) = ...
                    all_current_assessments(current_segment, :);
            end
            
            assessments{student_idx} = current_assessments;
            found_student = true;
            continue;
        end
    end
    
    if (~found_student)
        warning(['Could not find student with id: ' num2str(current_id) '.']);
    end
    
end
end