function lfp = pull_lfp(lfp_dir, ss, varargin)

% Jake Westerberg
% Vanderbilt University
% jakewesterberg@gmail.com

dbstop if error

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

        probe_files = find_in_dir(lfp_dir, 'probe');
        n_probes = numel(probe_files);

        save([file_path file_name], 'pre_dur', 'on_dur', 'off_dur', 'file_name', '-v7.3', '-nocompression')
        lfp = matfile([file_path file_name], 'Writable', true);
        lfp.cont = [];
        lfp.probe = [];
        lfp.channel = [];

        for j = 1 : n_probes

            nwb = nwbRead(probe_files{j});

            if j == 1
                fs = nwb.general_extracellular_ephys.get('probeA').lfp_sampling_rate;
                lfp.fs = fs;
                lfp_data_length =  numel([ceil((ss.on(1)-pre_dur)*fs) : ceil((ss.on(1)+on_dur)*fs), ...
                    ceil(ss.off(1)*fs) : ceil((ss.off(1)+off_dur)*fs)]);
            end

            lfp_stream_length = nwb.acquisition.get(['probe_' num2str(j-1) '_lfp']).electricalseries.get(['probe_' num2str(j-1) '_lfp']).timestamps.offset;
            lfp_channels = nwb.general_extracellular_ephys_electrodes.vectordata.get('local_index').data(:);
            nchan = numel(lfp_channels);

            lfp_continuous = zeros(nchan, lfp_data_length, ss.total_trials, 'single');
            lfp_stream = nwb.acquisition.get(['probe_' num2str(j-1) '_lfp']).electricalseries.get(['probe_' num2str(j-1) '_lfp_data']).data(1:nchan, 1:lfp_stream_length);
            lfp_timestamps = nwb.acquisition.get(['probe_' num2str(j-1) '_lfp']).electricalseries.get(['probe_' num2str(j-1) '_lfp_data']).timestamps(:);
            
            for i = 1 : ss.total_trials
                try
                    lfp_continuous(:,:,i)   = ...
                        [lfp_stream(:, ceil((ss.on(i)-lfp.pre_dur)*fs) : ceil((ss.on(i)+lfp.on_dur)*fs)), ...
                        lfp_stream(:, ceil(ss.off(i)*fs) : ceil((ss.off(i)+lfp.off_dur)*fs))];
                catch
                    lfp_continuous(:,:,i)   = ...
                        [lfp_stream(:, ceil((ss.on(i)-lfp.pre_dur)*fs)-1 : ceil((ss.on(i)+lfp.on_dur)*fs)), ...
                        lfp_stream(:, ceil(ss.off(i)*fs) : ceil((ss.off(i)+lfp.off_dur)*fs))];
                end
            end

            lfp.cont = [lfp.cont; lfp_continuous];
            lfp.probe = [lfp.probe; zeros( nchan, 1, 'int16')+j-1];
            lfp.channel = [lfp.channel; nwb.general_extracellular_ephys_electrodes.vectordata.get('local_index').data(:)];

            clear lfp_channels lfp_stream_length nchan lfp_continuous
        end
        clear lfp_stream lfp_channels nchan

end
end