function extractPyinPitchContour(path_to_file, output_dir, path_to_sonic_annotator, path_to_pyin_n3)

% AP@GTCMT, 2017
% objective: Compute the pYin pitch contour of an audio file and store the
% results
%
% INPUTS
% path_to_file: path to the audio file
% path_to_sonic_annotator: path to the sonic annotator executable
% path_to_pyin_n3: path to pyin .n3 file which specifies the parameters for
% extracting the pitch contour (window size and hop size)
%
% OUTPUTS
% computes the pitch contour and saves the output in the output_dir

%% Run Sonic Annotator to get pitch contours for voiced blocks
% move to foler with sonic-annotator executable
cd(path_to_sonic_annotator);
% run sonic annotator and save file in output_dir
s = ' ';
command =  ['./sonic-annotator -t', s, path_to_pyin_n3, s, path_to_file, s, '-w csv --csv-force --csv-basedir', s, output_dir];
system(command);

%% Generate timestamps and readjust pitch contour to include unvoiced blocks also
% read audio from path
[x, fs] = audioread(path_to_file);
% specify blocking parameters, must be the same as the paramters in the pYin .n3 file 
wSize = 1024;
hop = 256;
% compute number of blocks
x = x(:,1);
N = length([zeros(wSize/2,1);x;zeros(wSize/2,1)]);
num_blocks = ceil((N-wSize)/hop);
% compute time_stamps
time_stamps = (0:1:num_blocks-1) * hop / fs;
time_stamps = round(time_stamps, 3);
time_stamps = time_stamps';

% determine pYin output file name
[~, name, ~] = fileparts(path_to_file);
pyin_output_filename = [name, '_vamp_pyin_pyin_smoothedpitchtrack.csv'];

% read pYin output file
cd(output_dir);
pyin_output = dlmread(pyin_output_filename);
pyin_f0 = pyin_output(:,2);
pyin_time = round(pyin_output(:,1), 3);

% compare time stamps and insert zeros where appropriate
if length(pyin_time) > length(time_stamps)
       error('Error in pYin pitch estimate: Check if the parameters in .n3 file are the same as this function');
end
[~, common_time_idx] = ismember(pyin_time, time_stamps, 'R2012a');
pyin_f0_rev = zeros(size(time_stamps));
pyin_f0_rev(common_time_idx) = pyin_f0;

%% Write output to .txt file
% save as .txt file with timestamps
output_filename = [name, '_pyin_pitchtrack.txt'];
output_data = [time_stamps, pyin_f0_rev];
dlmwrite(output_filename, output_data)

% delete pYin .csv file (optional)
command = ['rm -rf', s, pyin_output_filename]; 
system(command);

end
