%% scriptSaveTrainingData
% script to computeand save training data in different configurations

% specify configuration
segment_option = 2;
band_options = {'middle'};
instrument_options = {'Alto Saxophone','Bb Clarinet', 'Flute'};
year_options = {'2013', '2014', '2015'};
feature_options = {'std', 'nonscore', 'score'};
pitch_option = 'pyin'; % options are 'pyin' and 'acf'
quick = 1;
if strcmp(pitch_option, 'pyin') == 1
    data_folder = 'dataPyin/';
else
    data_folder = 'data/';
end

%% Compute and Save Features
for b = 1:length(band_options)
    band = band_options{b};
    disp(band);
    for i = 1:length(instrument_options)
        instrument = instrument_options{i};
        disp(instrument);
        for y = 1:length(year_options)
           year = year_options{y};
           disp(year);
           for f = 1:length(feature_options)
                feature = feature_options{f};
                disp(feature);
                % check if file exists
                if quick == 1
                    quick_string = 'quick';
                else    
                    quick_string = '';
                end
                feature_filestring = [data_folder, band, instrument, ...
                    num2str(segment_option), '_', feature, '_', year, ...
                    quick_string, '.mat'];
                if exist(feature_filestring, 'file') ~= 2
                    [features, labels, student_ids] = createTrainingData(...
                        band, instrument, segment_option, year,...
                        pitch_option, feature, quick);
                    save(feature_filestring, 'features', 'labels', 'student_ids');
                end
           end
        end
    end
end

