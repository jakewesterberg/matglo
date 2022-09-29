function bhv = pull_wheel(ss, varargin)

% Jake Westerberg
% Vanderbilt University
% jakewesterberg@gmail.com

% defaults
wheel.pre_dur = 1;
wheel.on_dur = 1;
wheel.off_dur = 1;

file_path = [pwd filesep];
wheel.file_name = 'default_file_name.mat';

varStrInd = find(cellfun(@ischar,varargin));
for iv = 1:length(varStrInd)
    switch varargin{varStrInd(iv)}
        case {'-pred', 'pre_dur'}
            wheel.pre_dur = varargin{varStrInd(iv)+1};
        case {'-ond', 'on_dur'}
            wheel.on_dur = varargin{varStrInd(iv)+1};
        case {'-offd', 'off_dur'}
            wheel.off_dur = varargin{varStrInd(iv)+1};
        case {'-p', 'file_path'}
            file_path = varargin{varStrInd(iv)+1};
        case {'-n', 'file_name'}
            wheel.file_name = varargin{varStrInd(iv)+1};
        case {'-f', 'nwb'}
            nwb = varargin{varStrInd(iv)+1};
    end
end

%% Create GLO trial data

if ~exist('nwb', 'var')
    probe_files = find_in_dir(file_path, 'sub');
    nwb = nwbRead(probe_files{1});
end

wheel.fs = 60; % Hard coded as this is not included in the nwb file as of yet. Can (was) be determined from the timestamps.
pre_val = ceil(wheel.pre_dur*wheel.fs);
on_val = ceil(wheel.on_dur*wheel.fs);
off_val = ceil(wheel.off_dur*wheel.fs);

wheel_running_speed = nwb.processing.get('running').nwbdatainterface.get('running_speed').data(:);
wheel_rotation = nwb.processing.get('running').nwbdatainterface.get('running_wheel_rotation').data(:);
wheel_timestamps = nwb.processing.get('running').nwbdatainterface.get('running_speed').timestamps(:);

wheel.running_speed = [];
wheel.rotation = [];
wheel.timestamps = [];
for i = 1 : ss.total_trials

    [~, on_ind] = min(abs(ss.on(i) - wheel_timestamps));
    [~, off_ind] = min(abs(ss.off(i) - wheel_timestamps));

    wheel.running_speed = cat(3, wheel.running_speed, ...
        [wheel_running_speed(:, on_ind-pre_val : on_ind+on_val), ...
        wheel_running_speed(:, off_ind : off_ind+off_val)]);

    wheel.rotation = cat(3, wheel.rotation, ...
        [wheel_rotation(:, on_ind-pre_val : on_ind+on_val), ...
        wheel_rotation(:, off_ind : off_ind+off_val)]);

    wheel.timestamps = cat(3, wheel.timestamps, ...
        [wheel_timestamps(:, on_ind-pre_val : on_ind+on_val), ...
        wheel_timestamps(:, off_ind : off_ind+off_val)] - ss.on(i));

end

save([file_path wheel.file_name], 'wheel', '-v7.3', '-nocompression')

end