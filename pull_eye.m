function bhv = pull_eye(ss, varargin)

% Jake Westerberg
% Vanderbilt University
% jakewesterberg@gmail.com

% defaults
eye.pre_dur = 1;
eye.on_dur = 1;
eye.off_dur = 1;

file_path = [pwd filesep];
eye.file_name = 'default_file_name.mat';

varStrInd = find(cellfun(@ischar,varargin));
for iv = 1:length(varStrInd)
    switch varargin{varStrInd(iv)}
        case {'-pred', 'pre_dur'}
            eye.pre_dur = varargin{varStrInd(iv)+1};
        case {'-ond', 'on_dur'}
            eye.on_dur = varargin{varStrInd(iv)+1};
        case {'-offd', 'off_dur'}
            eye.off_dur = varargin{varStrInd(iv)+1};
        case {'-p', 'file_path'}
            file_path = varargin{varStrInd(iv)+1};
        case {'-n', 'file_name'}
            eye.file_name = varargin{varStrInd(iv)+1};
        case {'-f', 'nwb'}
            nwb = varargin{varStrInd(iv)+1};
    end
end

%% Create GLO trial data

if ~exist('nwb', 'var')
    probe_files = find_in_dir(file_path, 'sub');
    nwb = nwbRead(probe_files{1});
end

eye.fs = 60; % Hard coded as this is not included in the nwb file as of yet. Can (was) be determined from the timestamps.
pre_val = ceil(eye.pre_dur*eye.fs);
on_val = ceil(eye.on_dur*eye.fs);
off_val = ceil(eye.off_dur*eye.fs);

eye_pupil_area = nwb.acquisition.get('EyeTracking').pupil_tracking.area(:);
eye_blink = nwb.acquisition.get('EyeTracking').likely_blink.data(:);
eye_position = nwb.acquisition.get('EyeTracking').eye_tracking.data(:,:);
eye_timestamps = nwb.acquisition.get('EyeTracking').eye_tracking.timestamps(:);

eye.pupil_area = [];
eye.blink = [];
eye.position = [];
eye.timestamps = [];
for i = 1 : ss.total_trials

    [~, on_ind] = min(abs(ss.on(i) - eye_timestamps));
    [~, off_ind] = min(abs(ss.off(i) - eye_timestamps));

    eye.pupil_area = cat(3, eye.pupil_area, ...
        [eye_pupil_area(on_ind-pre_val : on_ind+on_val); ...
        eye_pupil_area(off_ind : off_ind+off_val)]);

    eye.blink = cat(3, eye.blink, ...
        [eye_blink(on_ind-pre_val : on_ind+on_val); ...
        eye_blink(off_ind : off_ind+off_val)]);

    eye.position = cat(3, eye.position, ...
        ([eye_position(:, on_ind-pre_val : on_ind+on_val), ...
        eye_position(:, off_ind : off_ind+off_val)])');

    eye.timestamps = cat(3, eye.timestamps, ...
        [eye_timestamps(on_ind-pre_val : on_ind+on_val); ...
        eye_timestamps(off_ind : off_ind+off_val)] - ss.on(i));

end

save([file_path eye.file_name], 'eye', '-v7.3', '-nocompression')

end