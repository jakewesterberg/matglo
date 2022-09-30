function opto_info = pull_opto_info(nwb, file_path)

% Jake Westerberg
% Vanderbilt University
% jakewesterberg@gmail.com

% optotagging events
opto_info.on             = nwb.processing.get('optotagging').dynamictable.get('optogenetic_stimulation').start_time.data(:);
opto_info.off            = nwb.processing.get('optotagging').dynamictable.get('optogenetic_stimulation').stop_time.data(:);

% stimulation info
opto_info.level          = nwb.processing.get('optotagging').dynamictable.get('optogenetic_stimulation').vectordata.get('level').data(:);
opto_info.type           = nwb.processing.get('optotagging').dynamictable.get('optogenetic_stimulation').vectordata.get('stimulus_name').data(:);

% count opto total trials
opto_info.total_trials   = numel(opto_info.on);

if exist('file_path', 'var')
    save([file_path 'opto_info' '.mat'], 'opto_info', '-v7.3', '-nocompression')
end

end