function rf = pull_rf_info(nwb)

% Jake Westerberg
% Vanderbilt University
% jakewesterberg@gmail.com

% grab rf trial times
rf.on               = nwb.intervals.get('create_receptive_field_mapping_presentations').start_time.data(:);
rf.off              = nwb.intervals.get('create_receptive_field_mapping_presentations').stop_time.data(:);

% grab rf trial stim info
rf.x                = nwb.intervals.get('create_receptive_field_mapping_presentations').vectordata.get('x_position').data(:);
rf.y                = nwb.intervals.get('create_receptive_field_mapping_presentations').vectordata.get('y_position').data(:);
rf.size             = nwb.intervals.get('create_receptive_field_mapping_presentations').vectordata.get('size').data(:);
rf.phase            = nwb.intervals.get('create_receptive_field_mapping_presentations').vectordata.get('phase').data(:);
rf.ori              = nwb.intervals.get('create_receptive_field_mapping_presentations').vectordata.get('orientation').data(:);
rf.tf               = nwb.intervals.get('create_receptive_field_mapping_presentations').vectordata.get('temporal_frequency').data(:);
rf.sf               = nwb.intervals.get('create_receptive_field_mapping_presentations').vectordata.get('spatial_frequency').data(:);
rf.contrast         = nwb.intervals.get('create_receptive_field_mapping_presentations').vectordata.get('contrast').data(:);

% count total rf trials
rf.total_trials     = numel(rf.on);

end