function f0 = getPyinPitchForSegment(path_to_pyin_output, segment_info)

% AP@GTCMT, 2017
% objective: return the f0 for a particular student performance and segment
%
% INPUTS
% path_to_pyin_output: path to the folder containing the pyin outpur .txt file 
% segment_info: tuple containing start time and duration of the segment
%
% OUTPUTS
% f0: pyin estimated pitch for the segment in Hz

%% Read the pyin output file 
curr_folder = pwd;
cd (path_to_pyin_output);
filename = dir('*.txt');
if isempty(filename)
    % TODO: convert this to a warning and compute pYin if needed
    error('pYin output has not been computed yet')
end 
pyin_output = dlmread(filename(1).name);
cd(curr_folder);

%% Obtain f0 and timestamps
f0 = pyin_output(:,2);
time_stamps = pyin_output(:,1);

%% Compute start time & stop time of segment
start_time = segment_info(1);
stop_time = segment_info(1) + segment_info(2);

%% extract relevant f0
f0(time_stamps < start_time) = -10; 
f0(time_stamps >= stop_time) = -10;
f0(f0 == -10) = [];
f0 = f0';

end