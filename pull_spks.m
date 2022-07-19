function spks = pull_spks(unit_info, ss, varargin)

% Jake Westerberg
% Vanderbilt University
% jakewesterberg@gmail.com

% defaults
fs = 1000; % at or below 1000
pre_dur = 1;
on_dur = 1;
off_dur = 1;

pull_method = 'convolve_then_pull';
storage_type = 'matfile';
file_path = [pwd filesep];
file_name = 'default_file_name.mat';
optimize_speed = true;

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
        case {'-m', 'pull_method'}
            pull_method = varargin{varStrInd(iv)+1};
        case {'-s', 'storage_type'}
            storage_type = varargin{varStrInd(iv)+1};
        case {'-p', 'file_path'}
            file_path = varargin{varStrInd(iv)+1};
        case {'-n', 'file_name'}
            file_name = varargin{varStrInd(iv)+1};
        case {'-o', 'optimize_speed'}
            optimize_speed = varargin{varStrInd(iv)+1};    
    end
end

%% Create GLO trial data
switch storage_type
    case 'matfile'

        conv_data_length                        =  numel([ceil((ss.on(1)-pre_dur)*1000) : ceil((ss.on(1)+on_dur)*1000), ...
                                                        ceil(ss.off(1)*1000) : ceil((ss.off(1)+off_dur)*1000)]);

        save([file_path file_name], 'fs', 'pre_dur', 'on_dur', 'off_dur', 'file_name', '-v7.3')
        spks = matfile([file_path file_name], 'Writable', true);
        spks.conv = single(zeros(unit_info.total, conv_data_length, ss.total_trials));

        switch pull_method
            case 'convolve_then_pull'
                for j = 1 : unit_info.total
                    conv_data                               = zeros(1, ceil(max(unit_info.spk_times(:)) * 1000)+1000);
                    conv_data(1, ceil(unit_info.spk_times(unit_info.spk_unit == j) * 1000))   = 1;
                    conv_data                               = single(conv_data);
                    conv_data                               = spks_conv(conv_data, spks_kernel('psp')) .* 1000;
                    
                    switch optimize_speed
                        case false
                            for i = 1 : ss.total_trials
                                spks.conv(j,1:conv_data_length,i)   = ...
                                    [conv_data(:, ceil((ss.on(i)-spks.pre_dur)*1000) : ceil((ss.on(i)+spks.on_dur)*1000)), ...
                                    conv_data(:, ceil(ss.off(i)*1000) : ceil((ss.off(i)+spks.off_dur)*1000))];
                            end
                        case true
                            
                    end
                    clear conv_data
                end
        end


    case 'structure'

        spks.fs = fs; % at or below 1000
        spks.pre_dur = pre_dur;
        spks.on_dur = on_dur;
        spks.off_dur = off_dur;

        switch pull_method
            case 'convolve_then_pull'

                spks.conv                               = nan(unit_info.total, ...
                                                            ceil(spks.fs*(spks.pre_dur+spks.on_dur+spks.off_dur)), ...
                                                            ss.total_trials);
                for j = 1 : unit_info.total
                    conv_data                               = zeros(1, ceil(max(unit_info.spk_times(:)) * 1000)+1000);
                    conv_data(1, ceil(unit_info.spk_times(unit_info.spk_unit == j) * 1000))   = 1;
                    conv_data                               = single(conv_data);
                    conv_data                               = spks_conv(conv_data, spks_kernel('psp')) .* 1000;
                    for i = 1 : ss.total_trials
                        spks.cnv(j,:,i)                     = [conv_data(:, ceil((ss.on(i)-spks.pre_dur)*1000) : ceil((ss.on(i)+spks.on_dur)*1000)), ...
                                                                conv_data(:, ceil(ss.off(i)*1000) : ceil((ss.off(i)+spks.off_dur)*1000))];
                    end
                    clear conv_data
                end

            case 'pull_then_convolve'
                for i = 1 : ss.total_trials
                    pre_spks{i}         = unit_info.spk_times(unit_info.spk_times>ss.on(i)-spks.pre_dur & unit_info.spk_times<=ss.on(i)) - ss.on(i);
                    pre_spkids{i}       = unit_info.spk_unit(unit_info.spk_times>ss.on(i) -spks.pre_dur & unit_info.spk_times<=ss.on(i));
                    on_spks{i}          = unit_info.spk_times(unit_info.spk_times>ss.on(i) & unit_info.spk_times<=ss.on(i)+spks.on_dur) - ss.on(i);
                    on_spkids{i}        = unit_info.spk_unit(unit_info.spk_times>ss.on(i) & unit_info.spk_times<=ss.on(i)+spks.on_dur);

                    % this current version corrects and aligns to off responses. For direct
                    % comparisons, it is important to consider this is 'stiched' rather
                    % than continuous. This should not be a worry for pre to on where they
                    % use the same alignment point, it is only a concern for on to off
                    off_spks{i}         = unit_info.spk_times(unit_info.spk_times>ss.off(i) & unit_info.spk_times<=ss.off(i)+spks.off_dur) - ss.off(i);
                    off_spkids{i}       = unit_info.spk_unit(unit_info.spk_times>ss.off(i) & unit_info.spk_times<=ss.off(i)+spks.off_dur);
                end

                spks.conv = [];

                pre_spks_conv = single(nan(unit_info.total, spks.fs*spks.pre_dur, ss.total_trials));
                on_spks_conv = single(nan(unit_info.total, spks.fs*spks.on_dur, ss.total_trials));
                off_spks_conv = single(nan(unit_info.total, spks.fs*spks.off_dur, ss.total_trials));
                for i = 1:unit_info.total
                    for j = 1:ss.total_trials
                        t_vec_pre = zeros(1,1000*spks.pre_dur);
                        t_vec_on = zeros(1,1000*spks.on_dur);
                        t_vec_off = zeros(1,1000*spks.off_dur);

                        t_vec_pre(ceil(pre_spks{j}(pre_spkids{j}==i)*1000 + spks.pre_dur*1000)) = 1;
                        t_vec_on(ceil(on_spks{j}(on_spkids{j}==i)*1000)) = 1;
                        t_vec_off(ceil(off_spks{j}(off_spkids{j}==i)*1000)) = 1;

                        t_vec_pre = spks_conv(t_vec_pre, spks_kernel('psp'));
                        t_vec_on = spks_conv(t_vec_on, spks_kernel('psp'));
                        t_vec_off = spks_conv(t_vec_off, spks_kernel('psp'));

                        pre_spks_conv(i,:,j) = single(t_vec_pre(1:(1000/spks.fs):end) .* 1000);
                        on_spks_conv(i,:,j) = single(t_vec_on(1:(1000/spks.fs):end) .* 1000);
                        off_spks_conv(i,:,j) = single(t_vec_off(1:(1000/spks.fs):end) .* 1000);
                    end
                end

                spks.conv = cat(2,spks.conv, pre_spks_conv); clear pre_spks_conv;
                spks.conv = cat(2,spks.conv, on_spks_conv); clear on_spks_conv;
                spks.conv = cat(2,spks.conv, off_spks_conv); clear off_spk_conv;
        end
end
end