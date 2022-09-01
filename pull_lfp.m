function lfp = pull_lfp(lfp_dir, ss, varargin)

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

        probe_files = find_in_dir(lfp_dir, 'probe');
        n_probes = numel(probe_files);

        nwb = nwbRead(probe_files{i});

        lfp_data_length =  numel([ceil((ss.on(1)-pre_dur)*fs) : ceil((ss.on(1)+on_dur)*fs), ...
            ceil(ss.off(1)*fs) : ceil((ss.off(1)+off_dur)*fs)]);

        save([file_path file_name], 'fs', 'pre_dur', 'on_dur', 'off_dur', 'file_name', '-v7.3', '-nocompression')
        lfp = matfile([file_path file_name], 'Writable', true);
        lfp.cont = zeros(n_probes*384, lfp_data_length, ss.total_trials, 'single');

        for j = 1 : n_probes

            if j ~= 1; nwb = nwbRead(probe_files{i}); end

            cont_data = nwb.acquisition.get(['probe_' num2str(j-1) '_lfp']).electricalseries.get(['probe_' num2str(j-1) '_lfp_data']).data;

            for i = 1 : ss.total_trials
                lfp.conv((j*384)-383:j*384,1:lfp_data_length,i)   = ...
                    [cont_data(:, ceil((ss.on(i)-lfp.pre_dur)*1000) : ceil((ss.on(i)+lfp.on_dur)*1000)), ...
                    cont_data(:, ceil(ss.off(i)*1000) : ceil((ss.off(i)+lfp.off_dur)*1000))];
            end

        end
        clear cont_data

end
end