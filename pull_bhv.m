function bhv = pull_bhv(bhv_dir, ss, varargin)

% Jake Westerberg
% Vanderbilt University
% jakewesterberg@gmail.com

% defaults
pre_dur = 1;
on_dur = 1;
off_dur = 1;

storage_type = 'matfile';
file_path = [pwd filesep];
file_name = 'default_file_name.mat';

varStrInd = find(cellfun(@ischar,varargin));
for iv = 1:length(varStrInd)
    switch varargin{varStrInd(iv)}
        case {'-pred', 'pre_dur'}
            pre_dur = varargin{varStrInd(iv)+1};
        case {'-ond', 'on_dur'}
            on_dur = varargin{varStrInd(iv)+1};
        case {'-offd', 'off_dur'}
            off_dur = varargin{varStrInd(iv)+1};
        case {'-s', 'storage_type'}
            storage_type = varargin{varStrInd(iv)+1};
        case {'-p', 'file_path'}
            file_path = varargin{varStrInd(iv)+1};
        case {'-n', 'file_name'}
            file_name = varargin{varStrInd(iv)+1};
    end
end

%% Create GLO trial data
switch storage_type
    case 'matfile'

        probe_files = find_in_dir(bhv_dir, 'sub');
        nwb = nwbRead(probe_files{1});

        eye_fs = 60; % Hard coded as this is not included in the nwb file as of yet. Can be determined from the timestamps.
        wheel_fs = 60; % Hard coded as this is not included in the nwb file as of yet. Can be determined from the timestamps.

        eye_pupil_area = 0;
        eye_blink = 0;

        wheel_running_speed = 0;
        wheel_position_angle = 0;
        
        lfp_stream_length = nwb.acquisition.get('probe_0_lfp').electricalseries.get('probe_0_lfp_data').timestamps.offset;
        lfp_data_length =  numel([ceil((ss.on(1)-pre_dur)*fs) : ceil((ss.on(1)+on_dur)*fs), ...
            ceil(ss.off(1)*fs) : ceil((ss.off(1)+off_dur)*fs)]);

        save([file_path file_name], 'fs', 'pre_dur', 'on_dur', 'off_dur', 'file_name', '-v7.3', '-nocompression')
        bhv = matfile([file_path file_name], 'Writable', true);
        bhv.cont = [];

        lfp_channels = nwb.general_extracellular_ephys_electrodes.vectordata.get('local_index').data(:);
        nchan = numel(lfp_channels);

        bhv.cont = cat(1, bhv.cont, zeros(nchan, lfp_data_length, ss.total_trials, 'single'));

        cont_data = nwb.acquisition.get(['probe_' num2str(j-1) '_lfp']).electricalseries.get(['probe_' num2str(j-1) '_lfp_data']).data(1:nchan, 1:lfp_stream_length);

        for i = 1 : ss.total_trials
            try
                bhv.cont(end-nchan+1:end,1:lfp_data_length,i)   = ...
                    [cont_data(:, ceil((ss.on(i)-bhv.pre_dur)*fs) : ceil((ss.on(i)+bhv.on_dur)*fs)), ...
                    cont_data(:, ceil(ss.off(i)*fs) : ceil((ss.off(i)+bhv.off_dur)*fs))];
            catch
                bhv.cont(end-nchan+1:end,1:lfp_data_length,i)   = ...
                    [cont_data(:, ceil((ss.on(i)-bhv.pre_dur)*fs)-1 : ceil((ss.on(i)+bhv.on_dur)*fs)), ...
                    cont_data(:, ceil(ss.off(i)*fs) : ceil((ss.off(i)+bhv.off_dur)*fs))];
            end
        end
end
end