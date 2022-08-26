function lfp = pull_lfp(lfp_dir, ss, varargin)

% Jake Westerberg
% Vanderbilt University
% jakewesterberg@gmail.com

% defaults
fs = 1000; % at or below 1000
pre_dur = 1;
on_dur = 1;
off_dur = 1;

storage_type = 'matfile';
file_path = [pwd filesep];
file_name = 'default_file_name.mat';

varStrInd = find(cellfun(@ischar,varargin));
for iv = 1:length(varStrInd)
    switch varargin{varStrInd(iv)}
        case {'-f','fs','sampling_frequency'}
            fs = varargin{varStrInd(iv)+1};
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

        lfp_data_length =  numel([ceil((ss.on(1)-pre_dur)*1000) : ceil((ss.on(1)+on_dur)*1000), ...
            ceil(ss.off(1)*1000) : ceil((ss.off(1)+off_dur)*1000)]);

        save([file_path file_name], 'fs', 'pre_dur', 'on_dur', 'off_dur', 'file_name', '-v7.3')
        lfp = matfile([file_path file_name], 'Writable', true);
        lfp.cont = zeros(n_probes*384, lfp_data_length, ss.total_trials, 'single');
        
        for j = 1 : n_probes

            nwb = nwbRead(probe_files{i});

            cont_data = zeros(1, ceil(max(unit_info.spk_times(:)) * 1000)+1000, 'single');

            for i = 1 : ss.total_trials
                lfp.conv(j,1:lfp_data_length,i)   = ...
                    [cont_data(:, ceil((ss.on(i)-lfp.pre_dur)*1000) : ceil((ss.on(i)+lfp.on_dur)*1000)), ...
                    cont_data(:, ceil(ss.off(i)*1000) : ceil((ss.off(i)+lfp.off_dur)*1000))];
            end

        end
        clear cont_data



%     case 'structure'
% 
%         lfp.fs = fs; % at or below 1000
%         lfp.pre_dur = pre_dur;
%         lfp.on_dur = on_dur;
%         lfp.off_dur = off_dur;
% 
%         lfp.conv                               = nan(unit_info.total, ...
%             ceil(lfp.fs*(lfp.pre_dur+lfp.on_dur+lfp.off_dur)), ...
%             ss.total_trials);
%         for j = 1 : unit_info.total
%             cont_data                               = zeros(1, ceil(max(unit_info.spk_times(:)) * 1000)+1000);
%             cont_data(1, ceil(unit_info.spk_times(unit_info.spk_unit == j) * 1000))   = 1;
%             cont_data                               = single(cont_data);
%             cont_data                               = spks_conv(cont_data, spks_kernel('psp')) .* 1000;
%             for i = 1 : ss.total_trials
%                 lfp.cnv(j,:,i)                     = [cont_data(:, ceil((ss.on(i)-lfp.pre_dur)*1000) : ceil((ss.on(i)+lfp.on_dur)*1000)), ...
%                     cont_data(:, ceil(ss.off(i)*1000) : ceil((ss.off(i)+lfp.off_dur)*1000))];
%             end
%             clear cont_data
%         end
end
end