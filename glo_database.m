function [glodb, params] = glo_database(unit_info, glo_spks, varargin)

varStrInd = find(cellfun(@ischar,varargin));
for iv = 1:length(varStrInd)
    switch varargin{varStrInd(iv)}
        case {'-d','glodb'}
            glodb = varargin{varStrInd(iv)+1};
    end
end

CONDITIONS = {...
    {'GLO_gloexp_pres1', glo_info.pres1 & glo_info.gloexp, [-50 40 100 40 540 600 540], [0 90 500 500 590 1000 1000]}, ...
    {'GLO_gloexp_pres2', glo_info.pres2 & glo_info.gloexp, [-50 40 100 40 540 600 540], [0 90 500 500 590 1000 1000]}, ...
    {'GLO_gloexp_pres3', glo_info.pres3 & glo_info.gloexp, [-50 40 100 40 540 600 540], [0 90 500 500 590 1000 1000]}, ...
    ...
    {'GLO_rndctl_pres1', glo_info.pres1 & glo_info.rndctl, [-50 40 100 40 540 600 540], [0 90 500 500 590 1000 1000]}, ...
    {'GLO_rndctl_pres2', glo_info.pres2 & glo_info.rndctl, [-50 40 100 40 540 600 540], [0 90 500 500 590 1000 1000]}, ...
    {'GLO_rndctl_pres3', glo_info.pres3 & glo_info.rndctl, [-50 40 100 40 540 600 540], [0 90 500 500 590 1000 1000]}, ...
    {'GLO_rndctl_pres4', glo_info.pres4 & glo_info.rndctl, [-50 40 100 40 540 600 540], [0 90 500 500 590 1000 1000]}, ...
    ...
    {'GLO_seqctl_pres1', glo_info.pres1 & glo_info.seqctl, [-50 40 100 40 540 600 540], [0 90 500 500 590 1000 1000]}, ...
    {'GLO_seqctl_pres2', glo_info.pres2 & glo_info.seqctl, [-50 40 100 40 540 600 540], [0 90 500 500 590 1000 1000]}, ...
    {'GLO_seqctl_pres3', glo_info.pres3 & glo_info.seqctl, [-50 40 100 40 540 600 540], [0 90 500 500 590 1000 1000]}, ...
    {'GLO_seqctl_pres4', glo_info.pres4 & glo_info.seqctl, [-50 40 100 40 540 600 540], [0 90 500 500 590 1000 1000]}, ...
    ...
    {'GLO_gloexp_global_oddball', glo_info.go_gloexp, [-50 40 100 40 540 600 540], [0 90 500 500 590 1000 1000]}, ...
    {'GLO_gloexp_local_oddball', glo_info.lo_gloexp, [-50 40 100 40 540 600 540], [0 90 500 500 590 1000 1000]}, ...
    ...
    {'GLO_rndctl_global_stimulus', logical(glo_info.go==glo_info.ori) & glo_info.rndctl, [-50 40 100 40 540 600 540], [0 90 500 500 590 1000 1000]}, ...
    {'GLO_rndctl_local_stimulus', logical(glo_info.lo==glo_info.ori) & glo_info.rndctl, [-50 40 100 40 540 600 540], [0 90 500 500 590 1000 1000]}, ...
    {'GLO_rndctl_matched_global_stimulus', glo_info.go_seq & glo_info.rndctl & glo_info.pres4, [-50 40 100 40 540 600 540], [0 90 500 500 590 1000 1000]}, ...
    {'GLO_rndctl_matched_local_stimulus', glo_info.lo_seq & glo_info.rndctl & glo_info.pres4, [-50 40 100 40 540 600 540], [0 90 500 500 590 1000 1000]}, ...
    {'GLO_rndctl_inverse_global_stimulus', glo_info.igo_seq & glo_info.rndctl & glo_info.pres4, [-50 40 100 40 540 600 540], [0 90 500 500 590 1000 1000]}, ...
    {'GLO_rndctl_inverse_local_stimulus', glo_info.ilo_seq & glo_info.rndctl & glo_info.pres4, [-50 40 100 40 540 600 540], [0 90 500 500 590 1000 1000]}, ...
    ...
    {'GLO_seqctl_matched_global_stimulus', glo_info.go_seqctl, [-50 40 100 40 540 600 540], [0 90 500 500 590 1000 1000]}, ...
    {'GLO_seqctl_inverse_global_stimulus', glo_info.igo_seqctl, [-50 40 100 40 540 600 540], [0 90 500 500 590 1000 1000]}, ...
    };

COMPARISONS_2_SAMPLE = {...
    {'GLO_global_oddball_response_type_1', [40 100 40 540 600 540], [90 500 500 590 1000 1000], 'glo_gloexp_global_oddball', 'glo_gloexp_pres3'}, ...
    {'GLO_global_oddball_response_type_2', [40 100 40 540 600 540], [90 500 500 590 1000 1000], 'glo_gloexp_global_oddball', 'glo_seqctl_matched_global_stimulus'}, ...
    ...
    {'GLO_local_oddball_response_type_1', [40 100 40 540 600 540], [90 500 500 590 1000 1000], 'glo_gloexp_local_oddball', 'glo_rndctl_local_stimulus'}, ...
    {'GLO_local_oddball_response_type_2', [40 100 40 540 600 540], [90 500 500 590 1000 1000], 'glo_gloexp_local_oddball', 'glo_rndctl_matched_local_stimulus'}, ...
    ...
    {'GLO_stimulus_selectivity', [40 100 40 540 600 540], [90 500 500 590 1000 1000], 'glo_rndctl_global_stimulus', 'glo_rndctl_local_stimulus'}, ...
    };

COMPARISONS_GROUPWISE = {...
    {'GLO_gloexp_adaptation', [40 100 40 540 600 540], [90 500 500 590 1000 1000], 'glo_gloexp_pres1', 'glo_gloexp_pres2', 'glo_gloexp_pres3'}, ...
    {'GLO_rndctl_adaptation', [40 100 40 540 600 540], [90 500 500 590 1000 1000], 'glo_rndctl_pres1', 'glo_rndctl_pres2', 'glo_rndctl_pres3', 'glo_rndctl_pres4'}, ...
    {'GLO_seqctl_adaptation', [40 100 40 540 600 540], [90 500 500 590 1000 1000], 'glo_seqctl_pres1', 'glo_seqctl_pres2', 'glo_seqctl_pres3', 'glo_seqctl_pres4'}, ...
    ...
    {'GLO_context', [40 100 40 540 600 540], [90 500 500 590 1000 1000], 'glo_gloexp_global_oddball', 'glo_rndctl_matched_global_stimulus', 'glo_seqctl_matched_global_stimulus'}
    ...
    };

if exist('glodb', 'var'); glodb = table2struct(glodb); else; glodb = struct(); end

if ~isfield(glodb, 'INFO_subject');                    glodb.INFO_subject = {};                       end
if ~isfield(glodb, 'INFO_session');                    glodb.INFO_session = [];                       end
if ~isfield(glodb, 'INFO_probe');                      glodb.INFO_probe = [];                         end
%if ~isfield(glodb, 'INFO_brain_area');                 glodb.INFO_brain_area = [];          end
%if ~isfield(glodb, 'INFO_cortical_layer');             glodb.INFO_cortical_layer = [];          end

if ~isfield(glodb, 'AP_peak_to_trough_ratio');    glodb.AP_peak_to_trough_ratio = [];       end
if ~isfield(glodb, 'AP_amplitude');               glodb.AP_amplitude = [];                  end
if ~isfield(glodb, 'AP_amplitude_cutoff');        glodb.AP_amplitude_cutoff = [];           end
if ~isfield(glodb, 'AP_cumulative_drift');        glodb.AP_cumulative_drift = [];           end
if ~isfield(glodb, 'AP_d_prime');                 glodb.AP_d_prime = [];                    end
if ~isfield(glodb, 'AP_firing_rate');             glodb.AP_firing_rate = [];                end
if ~isfield(glodb, 'AP_isi_violations');          glodb.AP_isi_violations = [];             end
if ~isfield(glodb, 'AP_l_ratio');                 glodb.AP_l_ratio = [];                    end
if ~isfield(glodb, 'AP_isolation_distance');      glodb.AP_isolation_distance = [];         end
if ~isfield(glodb, 'AP_local_index');             glodb.AP_local_index = [];                end
if ~isfield(glodb, 'AP_max_drift');               glodb.AP_max_drift = [];                  end
if ~isfield(glodb, 'AP_nn_hit_rate');             glodb.AP_nn_hit_rate = [];                end
if ~isfield(glodb, 'AP_nn_miss_rate');            glodb.AP_nn_miss_rate = [];               end
if ~isfield(glodb, 'AP_presence_ratio');          glodb.AP_presence_ratio = [];             end
if ~isfield(glodb, 'AP_quality');                 glodb.AP_quality = [];                    end
if ~isfield(glodb, 'AP_recovery_slope');          glodb.AP_recovery_slope = [];             end
if ~isfield(glodb, 'AP_repolarization_slope');    glodb.AP_repolarization_slope = [];       end
if ~isfield(glodb, 'AP_silhouette_score');        glodb.AP_silhouette_score = [];           end
if ~isfield(glodb, 'AP_signal_to_noise');         glodb.AP_signal_to_noise = [];            end
if ~isfield(glodb, 'AP_spread');                  glodb.AP_spread = [];                     end
if ~isfield(glodb, 'AP_velocity_above');          glodb.AP_velocity_above = [];             end
if ~isfield(glodb, 'AP_velocity_below');          glodb.AP_velocity_below = [];             end
if ~isfield(glodb, 'AP_waveform_duration');       glodb.AP_waveform_duration = [];          end
if ~isfield(glodb, 'AP_waveform_halfwidth');      glodb.AP_waveform_halfwidth = [];         end

for i = 1 : unit_info.total

    if mod(i, 100) == 1
        disp(['PROCESSING UNIT ' num2str(i) ' OF ' num2str(unit_info.total)])
    end

    unit_data = baseline_correct(squeeze(glo_spks.conv(i,:,:)));
    for j = 1 : numel(CONDITIONS)
        for k = 1 : numel(CONDITIONS{j}{3})

            temp_condition_inds = CONDITIONS{j}{2};

            temp_time_1 = CONDITIONS{j}{3}(k);
            temp_time_2 = CONDITIONS{j}{4}(k);

            temp_ind_1 = (glo_spks.pre_dur*glo_spks.fs)+(temp_time_1*glo_spks.fs/1000);
            temp_ind_2 = (glo_spks.pre_dur*glo_spks.fs)+(temp_time_2*glo_spks.fs/1000);

            temp_str = strrep([CONDITIONS{j}{1} '_' num2str(temp_time_1) '_' num2str(temp_time_2) 'ms'], '-', 'n');

            if ~isfield(glodb, [temp_str '_mean'])
                glodb.([temp_str '_mean']) = [];
                glodb.([temp_str '_median']) = [];
                glodb.([temp_str '_sd']) = []; 
                glodb.([temp_str '_n']) = []; 
                glodb.([temp_str '_wsr']) = [];
                glodb.([temp_str '_ttest']) = [];
                glodb.([temp_str '_power']) = [];
                glodb.([temp_str '_nout_point8']) = [];
            end

            glodb.([temp_str '_mean']) = [glodb.([temp_str '_mean']); ...
                mean(mean(unit_data(temp_ind_1:temp_ind_2,temp_condition_inds)))];

            glodb.([temp_str '_median']) = [glodb.([temp_str '_median']); ...
                median(mean(unit_data(temp_ind_1:temp_ind_2,temp_condition_inds)))];

            glodb.([temp_str '_sd']) = [glodb.([temp_str '_sd']); ...
                std(mean(unit_data(temp_ind_1:temp_ind_2,temp_condition_inds)))];

            glodb.([temp_str '_n']) = [glodb.([temp_str '_n']); ...
                sum(temp_condition_inds)];

            glodb.([temp_str '_wsr']) = [glodb.([temp_str '_wsr']); ...
                signrank(mean(unit_data(temp_ind_1:temp_ind_2,temp_condition_inds)))];

            [~, t_val] = ttest(mean(unit_data(temp_ind_1:temp_ind_2,temp_condition_inds)));
            glodb.([temp_str '_ttest']) = [glodb.([temp_str '_ttest']); t_val];

            glodb.([temp_str '_power']) = [ glodb.([temp_str '_power']) ; ...
                sampsizepwr('t',[glodb.([temp_str '_mean'])(end) glodb.([temp_str '_sd'])(end)], 0, [], glodb.([temp_str '_n'])(end))];

            glodb.([temp_str '_nout_point8']) = [ glodb.([temp_str '_nout_point8']) ; ...
                sampsizepwr('t',[glodb.([temp_str '_mean'])(end) glodb.([temp_str '_sd'])(end)], 0, .8, [])];

            clear temp_time_1 temp_time_2 temp_ind_1 temp_ind_2 temp_str t_val

        end
    end

    for j = 1 : numel(COMPARISONS_2_SAMPLE)
        for k = 1 : numel(COMPARISONS_2_SAMPLE{j}{2})

            for m = 1 : numel(CONDITIONS)
                if strcmp(CONDITIONS{m}{1}, COMPARISONS_2_SAMPLE{j}{4})
                    temp_condition_inds_1 = CONDITIONS{m}{2};
                    temp_condition_1 = m;
                end
                if strcmp(CONDITIONS{m}{1}, COMPARISONS_2_SAMPLE{j}{5})
                    temp_condition_inds_2 = CONDITIONS{m}{2};
                    temp_condition_2 = m;
                end
            end

            temp_time_1 = COMPARISONS_2_SAMPLE{j}{2}(k);
            temp_time_2 = COMPARISONS_2_SAMPLE{j}{3}(k);

            temp_ind_1 = (glo_spks.pre_dur*glo_spks.fs)+(temp_time_1*glo_spks.fs/1000);
            temp_ind_2 = (glo_spks.pre_dur*glo_spks.fs)+(temp_time_2*glo_spks.fs/1000);

            temp_str = strrep([COMPARISONS_2_SAMPLE{j}{1} '_' num2str(temp_time_1) '_' num2str(temp_time_2) 'ms'], '-', 'n');

            temp_str_1 = strrep([CONDITIONS{temp_condition_1}{1} '_' num2str(temp_time_1) '_' num2str(temp_time_2) 'ms'], '-', 'n');
            temp_str_2 = strrep([CONDITIONS{temp_condition_2}{1} '_' num2str(temp_time_1) '_' num2str(temp_time_2) 'ms'], '-', 'n');

            if ~isfield(glodb, [temp_str '_mean_diff'])
                glodb.([temp_str '_mean_diff']) = [];
                glodb.([temp_str '_median_diff']) = [];
                glodb.([temp_str '_mwu']) = [];
                glodb.([temp_str '_power']) = [];
                glodb.([temp_str '_nout_point8']) = [];
            end

            glodb.([temp_str '_mean_diff']) = [glodb.([temp_str '_mean_diff']); ...
                mean(mean(unit_data(temp_ind_1:temp_ind_2,temp_condition_inds_1))) - ...
                mean(mean(unit_data(temp_ind_1:temp_ind_2,temp_condition_inds_2)))];

            glodb.([temp_str '_median_diff']) = [glodb.([temp_str '_median_diff']); ...
                median(mean(unit_data(temp_ind_1:temp_ind_2,temp_condition_inds_1))) - ...
                median(mean(unit_data(temp_ind_1:temp_ind_2,temp_condition_inds_2)))];

            glodb.([temp_str '_mwu']) = [glodb.([temp_str '_mwu']); ...
                ranksum(mean(unit_data(temp_ind_1:temp_ind_2,temp_condition_inds_1)), ...
                mean(unit_data(temp_ind_1:temp_ind_2,temp_condition_inds_2)))];

            glodb.([temp_str '_power']) = [ glodb.([temp_str '_power']) ; ...
                sampsizepwr('t2',[glodb.([temp_str_1 '_mean'])(end) glodb.([temp_str_1 '_sd'])(end)], ...
                glodb.([temp_str_2 '_mean'])(end), [], glodb.([temp_str_1 '_n'])(end))];

            glodb.([temp_str '_nout']) = [ glodb.([temp_str '_nout']) ; ...
                sampsizepwr('t2',[glodb.([temp_str_1 '_mean'])(end) glodb.([temp_str_1 '_sd'])(end)], ...
                glodb.([temp_str_2 '_mean'])(end), .8, [])];

        end
    end

    for j = 1 : numel(COMPARISONS_GROUPWISE)
        for k = 1 : numel(COMPARISONS_GROUPWISE{j}{2})

            for m = 4 : numel(COMPARISONS_GROUPWISE{j})
                for n = 1 : numel(CONDITIONS)
                    if strcmp(CONDITIONS{n}{1}, COMPARISONS_GROUPWISE{j}{m})
                        temp_condition_inds{m-3} = CONDITIONS{n}{2};
                    end
                end
            end

            temp_time_1 = COMPARISONS_GROUPWISE{j}{2}(k);
            temp_time_2 = COMPARISONS_GROUPWISE{j}{3}(k);

            temp_ind_1 = (glo_spks.pre_dur*glo_spks.fs)+(temp_time_1*glo_spks.fs/1000);
            temp_ind_2 = (glo_spks.pre_dur*glo_spks.fs)+(temp_time_2*glo_spks.fs/1000);

            temp_str = strrep([COMPARISONS_GROUPWISE{j}{1} '_' num2str(temp_time_1) '_' num2str(temp_time_2) 'ms'], '-', 'n');

            if ~isfield(glodb, [temp_str '_kwt'])
                glodb.([temp_str '_kwt']) = [];
            end

            temp_data = [];
            temp_group = [];
            for m = 1 : numel(COMPARISONS_GROUPWISE{j})-3
                temp_data = [temp_data; squeeze(mean(unit_data(temp_ind_1:temp_ind_2,temp_condition_inds{m})))];
                temp_group = [temp_group; ones(sum(temp_condition_inds{m}), 1).*m];
            end

            glodb.([temp_str '_kwt']) = [glodb.([temp_str '_kwt']); kruskalwallis(temp_data, temp_group)];

            clear temp_time_1 temp_time_2 temp_ind_1 temp_ind_2 temp_data temp_group temp_condition_inds temp_str

        end
    end

end

params.CONDITIONS = CONDITIONS;
params.COMPARISONS_2_SAMPLE = COMPARISONS_2_SAMPLE;
params.COMPARISONS_GROUPWISE = COMPARISONS_GROUPWISE;

glodb = struct2table(glodb);

end