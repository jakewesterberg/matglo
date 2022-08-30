function [glodb, params] = glo_database(unit_info, glo_info, glo_spks, varargin)

varStrInd = find(cellfun(@ischar,varargin));
for iv = 1:length(varStrInd)
    switch varargin{varStrInd(iv)}
        case {'-d','glodb'}
            glodb = varargin{varStrInd(iv)+1};
        case {'-o','opto'}
            opto_info = varargin{varStrInd(iv)+1};
            opto_spks = varargin{varStrInd(iv)+2};
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

DIFFERENCE_FUNCTIONS = {...
    {'GLO_gloexp_global_oddball_diff_pres3', glo_info.go_gloexp, logical([glo_info.go_gloexp(2:end); 0]), [-50 40 100 40 540 600 540], [0 90 500 500 590 1000 1000]}, ...
    {'GLO_seqctl_global_stimulus_diff_pres3', glo_info.go_seqctl, logical([glo_info.go_seqctl(2:end); 0]), [-50 40 100 40 540 600 540], [0 90 500 500 590 1000 1000]}, ...
    };

COMPARISONS_2_SAMPLE = {...
    {'GLO_global_oddball_response_type_1', [40 100 40 540 600 540], [90 500 500 590 1000 1000], 'GLO_gloexp_global_oddball', 'GLO_gloexp_pres3'}, ...
    {'GLO_global_oddball_response_type_2', [40 100 40 540 600 540], [90 500 500 590 1000 1000], 'GLO_gloexp_global_oddball', 'GLO_seqctl_matched_global_stimulus'}, ...
    {'GLO_global_oddball_response_type_3', [40 100 40 540 600 540], [90 500 500 590 1000 1000], 'GLO_gloexp_global_oddball_diff_pres3', 'GLO_seqctl_matched_global_stimulus_diff_pres3'}, ...
    ...
    {'GLO_local_oddball_response_type_1', [40 100 40 540 600 540], [90 500 500 590 1000 1000], 'GLO_gloexp_local_oddball', 'GLO_rndctl_local_stimulus'}, ...
    {'GLO_local_oddball_response_type_2', [40 100 40 540 600 540], [90 500 500 590 1000 1000], 'GLO_gloexp_local_oddball', 'GLO_rndctl_matched_local_stimulus'}, ...
    ...
    {'GLO_stimulus_selectivity', [40 100 40 540 600 540], [90 500 500 590 1000 1000], 'GLO_rndctl_global_stimulus', 'GLO_rndctl_local_stimulus'}, ...
    };

COMPARISONS_GROUPWISE = {...
    {'GLO_gloexp_adaptation', [40 100 40 540 600 540], [90 500 500 590 1000 1000], 'GLO_gloexp_pres1', 'GLO_gloexp_pres2', 'GLO_gloexp_pres3'}, ...
    {'GLO_rndctl_adaptation', [40 100 40 540 600 540], [90 500 500 590 1000 1000], 'GLO_rndctl_pres1', 'GLO_rndctl_pres2', 'GLO_rndctl_pres3', 'GLO_rndctl_pres4'}, ...
    {'GLO_seqctl_adaptation', [40 100 40 540 600 540], [90 500 500 590 1000 1000], 'GLO_seqctl_pres1', 'GLO_seqctl_pres2', 'GLO_seqctl_pres3', 'GLO_seqctl_pres4'}, ...
    ...
    {'GLO_context', [40 100 40 540 600 540], [90 500 500 590 1000 1000], 'GLO_gloexp_global_oddball', 'GLO_rndctl_matched_global_stimulus', 'GLO_seqctl_matched_global_stimulus'}
    ...
    };

if ~exist('glodb', 'var'); glodb = struct(); end

if ~isfield(glodb, 'INFO_identifier');            glodb.INFO_identifier = {};               end
if ~isfield(glodb, 'INFO_age');                   glodb.INFO_age = [];                      end
if ~isfield(glodb, 'INFO_genotype');              glodb.INFO_genotype = {};                 end
if ~isfield(glodb, 'INFO_sex');                   glodb.INFO_sex = {};                      end
if ~isfield(glodb, 'INFO_species');               glodb.INFO_species = {};                  end
if ~isfield(glodb, 'INFO_strain');                glodb.INFO_strain = {};                   end
if ~isfield(glodb, 'INFO_area');                  glodb.INFO_area = {};                     end
if ~isfield(glodb, 'INFO_area_minmax');           glodb.INFO_area_minmax = {};              end
if ~isfield(glodb, 'INFO_probe');                 glodb.INFO_probe = {};                    end
if ~isfield(glodb, 'INFO_channel');               glodb.INFO_channel = {};                  end
if ~isfield(glodb, 'INFO_channel_minmax');        glodb.INFO_channel_minmax = {};           end

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
if ~isfield(glodb, 'AP_waveform');                glodb.AP_waveform = {};                   end
if ~isfield(glodb, 'AP_waveprint');               glodb.AP_waveprint = {};                  end

for i = 1 : unit_info.total

    if mod(i, 100) == 1
        disp(['PROCESSING UNIT ' num2str(i) ' OF ' num2str(unit_info.total)])
    end

    glodb.INFO_identifier = [glodb.INFO_identifier, unit_info.subject_identifier(i)];
    glodb.INFO_age = [glodb.INFO_age, unit_info.subject_age(i)];
    glodb.INFO_genotype = [glodb.INFO_genotype, unit_info.subject_genotype(i)];
    glodb.INFO_sex = [glodb.INFO_sex, unit_info.subject_sex(i) ];
    glodb.INFO_species = [glodb.INFO_species, unit_info.subject_species(i)];
    glodb.INFO_strain = [glodb.INFO_strain, unit_info.subject_strain(i)];
    glodb.INFO_area = [glodb.INFO_area, unit_info.area(i)];
    glodb.INFO_area_minmax = [glodb.INFO_area_minmax, unit_info.minmax_area(i)];
    glodb.INFO_probe = [glodb.INFO_probe, unit_info.probe(i)];
    glodb.INFO_channel = [glodb.INFO_channel, unit_info.channel(i)];
    glodb.INFO_channel_minmax = [glodb.INFO_channel_minmax, unit_info.minmax_channel(i)];

    glodb.AP_amplitude = [glodb.AP_amplitude, unit_info.amplitude(i)];
    glodb.AP_amplitude_cutoff = [glodb.AP_amplitude_cutoff,unit_info.amplitude_cutoff(i)];
    glodb.AP_peak_to_trough_ratio = [glodb.AP_peak_to_trough_ratio,unit_info.PT_ratio(i)];
    glodb.AP_cumulative_drift = [glodb.AP_cumulative_drift,unit_info.cumulative_drift(i)];
    glodb.AP_d_prime = [glodb.AP_d_prime,unit_info.d_prime(i)];
    glodb.AP_firing_rate = [glodb.AP_firing_rate,unit_info.firing_rate(i)];
    glodb.AP_isi_violations = [glodb.AP_isi_violations,unit_info.isi_violations(i)];
    glodb.AP_l_ratio = [glodb.AP_l_ratio,unit_info.l_ratio(i)];
    glodb.AP_isolation_distance = [glodb.AP_isolation_distance,unit_info.isolation_distance(i)];
    glodb.AP_local_index = [glodb.AP_local_index,unit_info.local_index(i)];
    glodb.AP_max_drift = [glodb.AP_max_drift,unit_info.max_drift(i)];
    glodb.AP_nn_hit_rate = [glodb.AP_nn_hit_rate,unit_info.nn_hit_rate(i)];
    glodb.AP_nn_miss_rate = [glodb.AP_nn_miss_rate,unit_info.nn_miss_rate(i)];
    glodb.AP_presence_ratio = [glodb.AP_presence_ratio,unit_info.presence_ration(i)];
    glodb.AP_quality = [glodb.AP_quality,unit_info.quality(i)];
    glodb.AP_recovery_slope = [glodb.AP_recovery_slope,unit_info.recovery_slope(i)];
    glodb.AP_repolarization_slope = [glodb.AP_repolarization_slope,unit_info.repolarization_slope(i)];
    glodb.AP_silhouette_score = [glodb.AP_silhouette_score,unit_info.silhouette_score(i)];
    glodb.AP_signal_to_noise = [glodb.AP_signal_to_noise,unit_info.snr(i)];
    glodb.AP_spread = [glodb.AP_spread,unit_info.spread(i)];
    glodb.AP_velocity_above = [glodb.AP_velocity_above,unit_info.velocity_above(i)];
    glodb.AP_velocity_below = [glodb.AP_velocity_below,unit_info.velocity_below(i)];
    glodb.AP_waveform_duration = [glodb.AP_waveform_duration,unit_info.waveform_duration(i)];
    glodb.AP_waveform_halfwidth = [glodb.AP_waveform_halfwidth,unit_info.waveform_halfwidth(i)];
    glodb.AP_waveform = [glodb.AP_waveform,unit_info.minmax_waveform(:,i)];
    glodb.AP_waveprint = [glodb.AP_waveprint,unit_info.waveprint(:,:,i)];

    unit_data = baseline_correct(squeeze(glo_spks.conv(i,:,:)), glo_spks.pre_dur*glo_spks.fs-50:glo_spks.pre_dur*glo_spks.fs);
    unit_data_nobc = squeeze(glo_spks.conv(i,:,:));

    for j = 1 : numel(CONDITIONS)

        temp_condition_inds = CONDITIONS{j}{2};

        if ~isfield(glodb, [CONDITIONS{j}{1} '_mean'])
            glodb.([CONDITIONS{j}{1} '_mean']) = {};
            glodb.([CONDITIONS{j}{1} '_sd']) = {};
            glodb.([CONDITIONS{j}{1} '_n']) = [];
            glodb.([CONDITIONS{j}{1} '_baseline_mean']) = [];
            glodb.([CONDITIONS{j}{1} '_baseline_sd']) = [];
        end

        glodb.([CONDITIONS{j}{1} '_mean']) = [glodb.([CONDITIONS{j}{1} '_mean']),mean(unit_data(:,temp_condition_inds),2)];
        glodb.([CONDITIONS{j}{1} '_sd']) = [glodb.([CONDITIONS{j}{1} '_sd']),std(unit_data(:,temp_condition_inds),[],2)];
        glodb.([CONDITIONS{j}{1} '_n']) = [glodb.([CONDITIONS{j}{1} '_n']),sum(temp_condition_inds)];

        glodb.([CONDITIONS{j}{1} '_baseline_mean']) = [glodb.([CONDITIONS{j}{1} '_baseline_mean']),...
            mean(mean(unit_data_nobc(glo_spks.pre_dur*glo_spks.fs-50:glo_spks.pre_dur*glo_spks.fs,temp_condition_inds)))];

        glodb.([CONDITIONS{j}{1} '_baseline_sd']) = [glodb.([CONDITIONS{j}{1} '_baseline_sd']),...
            std(mean(unit_data_nobc(glo_spks.pre_dur*glo_spks.fs-50:glo_spks.pre_dur*glo_spks.fs,temp_condition_inds)))];

        for k = 1 : numel(CONDITIONS{j}{3})

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

            glodb.([temp_str '_mean']) = [glodb.([temp_str '_mean']),...
                mean(mean(unit_data(temp_ind_1:temp_ind_2,temp_condition_inds)))];

            glodb.([temp_str '_median']) = [glodb.([temp_str '_median']),...
                median(mean(unit_data(temp_ind_1:temp_ind_2,temp_condition_inds)))];

            glodb.([temp_str '_sd']) = [glodb.([temp_str '_sd']),...
                std(mean(unit_data(temp_ind_1:temp_ind_2,temp_condition_inds)))];

            glodb.([temp_str '_n']) = [glodb.([temp_str '_n']),...
                sum(temp_condition_inds)];

            glodb.([temp_str '_wsr']) = [glodb.([temp_str '_wsr']),...
                signrank(mean(unit_data(temp_ind_1:temp_ind_2,temp_condition_inds)))];

            [~, t_val] = ttest(mean(unit_data(temp_ind_1:temp_ind_2,temp_condition_inds)));
            glodb.([temp_str '_ttest']) = [glodb.([temp_str '_ttest']),t_val];

            if ~isnan(t_val) && t_val~=1
                glodb.([temp_str '_power']) = [ glodb.([temp_str '_power']) ,...
                    sampsizepwr('t',[glodb.([temp_str '_mean'])(end) glodb.([temp_str '_sd'])(end)], 0, [], glodb.([temp_str '_n'])(end))];

                glodb.([temp_str '_nout_point8']) = [ glodb.([temp_str '_nout_point8']) ,...
                    sampsizepwr('t',[glodb.([temp_str '_mean'])(end) glodb.([temp_str '_sd'])(end)], 0, .8, [])];
            else
                glodb.([temp_str '_power']) = [ glodb.([temp_str '_power']) ,NaN];
                glodb.([temp_str '_nout_point8']) = [ glodb.([temp_str '_nout_point8']) ,NaN];
            end

            clear temp_time_1 temp_time_2 temp_ind_1 temp_ind_2 temp_str t_val

        end

        clear temp_condition_inds

    end

    for j = 1 : numel(DIFFERENCE_FUNCTIONS)

        temp_condition_inds_1 = DIFFERENCE_FUNCTIONS{j}{2};
        temp_condition_inds_2 = DIFFERENCE_FUNCTIONS{j}{3};

        if ~isfield(glodb, [DIFFERENCE_FUNCTIONS{j}{1} '_mean'])
            glodb.([DIFFERENCE_FUNCTIONS{j}{1} '_mean']) = {};
            glodb.([DIFFERENCE_FUNCTIONS{j}{1} '_sd']) = {};
            glodb.([DIFFERENCE_FUNCTIONS{j}{1} '_n']) = [];
            glodb.([DIFFERENCE_FUNCTIONS{j}{1} '_baseline_mean']) = [];
            glodb.([DIFFERENCE_FUNCTIONS{j}{1} '_baseline_sd']) = [];
        end

        glodb.([DIFFERENCE_FUNCTIONS{j}{1} '_mean']) = [glodb.([DIFFERENCE_FUNCTIONS{j}{1} '_mean']), ...
            mean(unit_data(:,temp_condition_inds_1) - unit_data(:,temp_condition_inds_2), 2)];
        glodb.([DIFFERENCE_FUNCTIONS{j}{1} '_sd']) = [glodb.([DIFFERENCE_FUNCTIONS{j}{1} '_sd']), ...
            std(unit_data(:,temp_condition_inds_1) - unit_data(:,temp_condition_inds_2), [], 2)];
        glodb.([DIFFERENCE_FUNCTIONS{j}{1} '_n']) = [glodb.([DIFFERENCE_FUNCTIONS{j}{1} '_n']), sum(temp_condition_inds_1)];

        glodb.([DIFFERENCE_FUNCTIONS{j}{1} '_baseline_mean']) = [glodb.([DIFFERENCE_FUNCTIONS{j}{1} '_baseline_mean']),...
            mean(mean(unit_data_nobc(glo_spks.pre_dur*glo_spks.fs-50:glo_spks.pre_dur*glo_spks.fs,temp_condition_inds_1)) - ...
            mean(unit_data_nobc(glo_spks.pre_dur*glo_spks.fs-50:glo_spks.pre_dur*glo_spks.fs,temp_condition_inds_2)))];

        glodb.([DIFFERENCE_FUNCTIONS{j}{1} '_baseline_sd']) = [glodb.([DIFFERENCE_FUNCTIONS{j}{1} '_baseline_sd']),...
            std(mean(unit_data_nobc(glo_spks.pre_dur*glo_spks.fs-50:glo_spks.pre_dur*glo_spks.fs,temp_condition_inds_1)) - ...
            mean(unit_data_nobc(glo_spks.pre_dur*glo_spks.fs-50:glo_spks.pre_dur*glo_spks.fs,temp_condition_inds_2)))];

        for k = 1 : numel(DIFFERENCE_FUNCTIONS{j}{4})

            temp_time_1 = DIFFERENCE_FUNCTIONS{j}{4}(k);
            temp_time_2 = DIFFERENCE_FUNCTIONS{j}{5}(k);

            temp_ind_1 = (glo_spks.pre_dur*glo_spks.fs)+(temp_time_1*glo_spks.fs/1000);
            temp_ind_2 = (glo_spks.pre_dur*glo_spks.fs)+(temp_time_2*glo_spks.fs/1000);

            temp_str = strrep([DIFFERENCE_FUNCTIONS{j}{1} '_' num2str(temp_time_1) '_' num2str(temp_time_2) 'ms'], '-', 'n');

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

            glodb.([temp_str '_mean']) = [glodb.([temp_str '_mean']),...
                mean(mean(unit_data(temp_ind_1:temp_ind_2,temp_condition_inds_1)) - ...
                mean(unit_data(temp_ind_1:temp_ind_2,temp_condition_inds_2)))];

            glodb.([temp_str '_median']) = [glodb.([temp_str '_median']),...
                median(mean(unit_data(temp_ind_1:temp_ind_2,temp_condition_inds_1)) - ...
                mean(unit_data(temp_ind_1:temp_ind_2,temp_condition_inds_2)))];

            glodb.([temp_str '_sd']) = [glodb.([temp_str '_sd']),...
                std(mean(unit_data(temp_ind_1:temp_ind_2,temp_condition_inds_1)) - ...
                mean(unit_data(temp_ind_1:temp_ind_2,temp_condition_inds_2)))];

            glodb.([temp_str '_n']) = [glodb.([temp_str '_n']),...
                sum(temp_condition_inds_1)];

            glodb.([temp_str '_wsr']) = [glodb.([temp_str '_wsr']),...
                signrank(mean(unit_data(temp_ind_1:temp_ind_2,temp_condition_inds_1))- ...
                mean(unit_data(temp_ind_1:temp_ind_2,temp_condition_inds_2)))];

            [~, t_val] = ttest(mean(unit_data(temp_ind_1:temp_ind_2,temp_condition_inds_1)) - ...
                mean(unit_data(temp_ind_1:temp_ind_2,temp_condition_inds_2)));
            glodb.([temp_str '_ttest']) = [glodb.([temp_str '_ttest']),t_val];

            if ~isnan(t_val) && t_val~=1
                glodb.([temp_str '_power']) = [ glodb.([temp_str '_power']) ,...
                    sampsizepwr('t',[glodb.([temp_str '_mean'])(end) glodb.([temp_str '_sd'])(end)], 0, [], glodb.([temp_str '_n'])(end))];

                glodb.([temp_str '_nout_point8']) = [ glodb.([temp_str '_nout_point8']) ,...
                    sampsizepwr('t',[glodb.([temp_str '_mean'])(end) glodb.([temp_str '_sd'])(end)], 0, .8, [])];
            else
                glodb.([temp_str '_power']) = [ glodb.([temp_str '_power']) ,NaN];
                glodb.([temp_str '_nout_point8']) = [ glodb.([temp_str '_nout_point8']) ,NaN];
            end

            clear temp_time_1 temp_time_2 temp_ind_1 temp_ind_2 temp_str t_val

        end

        clear temp_condition_inds_1 temp_condition_inds_2

    end


    for j = 1 : numel(COMPARISONS_2_SAMPLE)
        for k = 1 : numel(COMPARISONS_2_SAMPLE{j}{2})

            for m = 1 : numel(CONDITIONS)
                if strcmp(CONDITIONS{m}{1}, COMPARISONS_2_SAMPLE{j}{4})
                    temp_condition_inds_1 = CONDITIONS{m}{2};
                    temp_condition_1 = m;
                    is_df_1 = false;
                end
                if strcmp(CONDITIONS{m}{1}, COMPARISONS_2_SAMPLE{j}{5})
                    temp_condition_inds_2 = CONDITIONS{m}{2};
                    temp_condition_2 = m;
                    is_df_2 = false;
                end
            end
            for m = 1 : numel(DIFFERENCE_FUNCTIONS)
                if strcmp(DIFFERENCE_FUNCTIONS{m}{1}, COMPARISONS_2_SAMPLE{j}{4})
                    temp_condition_inds_1_1 = DIFFERENCE_FUNCTIONS{m}{2};
                    temp_condition_inds_1_2 = DIFFERENCE_FUNCTIONS{m}{3};
                    temp_condition_1 = m;
                    is_df_1 = true;
                end
                if strcmp(DIFFERENCE_FUNCTIONS{m}{1}, COMPARISONS_2_SAMPLE{j}{5})
                    temp_condition_inds_2_1 = DIFFERENCE_FUNCTIONS{m}{2};
                    temp_condition_inds_2_2 = DIFFERENCE_FUNCTIONS{m}{3};
                    temp_condition_2 = m;
                    is_df_2 = true;
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

            switch is_df_1
                case true
                    temp_dat_1 = unit_data(temp_ind_1:temp_ind_2,temp_condition_inds_1_1) - unit_data(temp_ind_1:temp_ind_2,temp_condition_inds_1_2);
                case false
                    temp_dat_1 = unit_data(temp_ind_1:temp_ind_2,temp_condition_inds_1);
            end

            switch is_df_2
                case true
                    temp_dat_2 = unit_data(temp_ind_1:temp_ind_2,temp_condition_inds_2_1) - unit_data(temp_ind_1:temp_ind_2,temp_condition_inds_2_2);
                case false
                    temp_dat_2 = unit_data(temp_ind_1:temp_ind_2,temp_condition_inds_2);
            end

            glodb.([temp_str '_mean_diff']) = [glodb.([temp_str '_mean_diff']),...
                mean(mean(temp_dat_1)) - mean(mean(temp_dat_2))];

            glodb.([temp_str '_median_diff']) = [glodb.([temp_str '_median_diff']),...
                median(mean(temp_dat_1)) - median(mean(temp_dat_2))];

            glodb.([temp_str '_mwu']) = [glodb.([temp_str '_mwu']),...
                ranksum(mean(temp_dat_1), mean(temp_dat_2))];

            if glodb.([temp_str_1 '_sd'])(end) ~= 0
                glodb.([temp_str '_power']) = [ glodb.([temp_str '_power']) ,...
                    sampsizepwr('t2',[glodb.([temp_str_1 '_mean'])(end) glodb.([temp_str_1 '_sd'])(end)], ...
                    glodb.([temp_str_2 '_mean'])(end), [], glodb.([temp_str_1 '_n'])(end))];

                glodb.([temp_str '_nout_point8']) = [ glodb.([temp_str '_nout_point8']) ,...
                    sampsizepwr('t2',[double(glodb.([temp_str_1 '_mean'])(end)) double(glodb.([temp_str_1 '_sd'])(end))], ...
                    double(glodb.([temp_str_2 '_mean'])(end)), .8, [])];
            else
                glodb.([temp_str '_power']) = [ glodb.([temp_str '_power']) ,NaN];
                glodb.([temp_str '_nout_point8']) = [ glodb.([temp_str '_nout_point8']) ,NaN];
            end

            clear temp_time_1 temp_time_2 temp_ind_1 temp_ind_2 temp_str temp_str_1 temp_str_2 temp_condition_1 temp_condition_2 temp_condition_inds_1 temp_condition_inds_2 temp_dat_1 temp_dat_2

        end
    end

    for j = 1 : numel(COMPARISONS_GROUPWISE)
        for k = 1 : numel(COMPARISONS_GROUPWISE{j}{2})

            temp_time_1 = COMPARISONS_GROUPWISE{j}{2}(k);
            temp_time_2 = COMPARISONS_GROUPWISE{j}{3}(k);

            temp_ind_1 = (glo_spks.pre_dur*glo_spks.fs)+(temp_time_1*glo_spks.fs/1000);
            temp_ind_2 = (glo_spks.pre_dur*glo_spks.fs)+(temp_time_2*glo_spks.fs/1000);

            temp_str = strrep([COMPARISONS_GROUPWISE{j}{1} '_' num2str(temp_time_1) '_' num2str(temp_time_2) 'ms'], '-', 'n');

            for m = 4 : numel(COMPARISONS_GROUPWISE{j})
                for n = 1 : numel(CONDITIONS)
                    if strcmp(CONDITIONS{n}{1}, COMPARISONS_GROUPWISE{j}{m})
                        temp_dat{m-3} = unit_data(temp_ind_1:temp_ind_2,CONDITIONS{n}{2});
                    end

                end
                for n = 1 : numel(DIFFERENCE_FUNCTIONS)
                    if strcmp(DIFFERENCE_FUNCTIONS{n}{1}, COMPARISONS_GROUPWISE{j}{m})
                        temp_dat{m-3} = unit_data(temp_ind_1:temp_ind_2,DIFFERENCE_FUNCTIONS{n}{2}) ...
                            - unit_data(temp_ind_1:temp_ind_2,DIFFERENCE_FUNCTIONS{n}{3});
                    end
                end
            end

            if ~isfield(glodb, [temp_str '_kwt'])
                glodb.([temp_str '_kwt']) = [];
            end

            temp_data = [];
            temp_group = [];
            for m = 1 : numel(COMPARISONS_GROUPWISE{j})-3
                temp_data = [temp_data; squeeze(mean(temp_dat{m}))'];
                temp_group = [temp_group;ones(size(temp_dat{m}, 2), 1).*m];
            end

            glodb.([temp_str '_kwt']) = [glodb.([temp_str '_kwt']),kruskalwallis(double(temp_data.'), double(temp_group.'), 'off')];

            clear temp_time_1 temp_time_2 temp_ind_1 temp_ind_2 temp_data temp_group temp_condition_inds temp_str

        end
    end

    if exist('opto_info', 'var')

        opto_data = squeeze(opto_spks.conv(i,:,:));

        bl_epoch = opto_spks.pre_dur*opto_spks.fs - (opto_spks.fs/1000*50) : opto_spks.pre_dur*opto_spks.fs;
        stim_epoch = opto_spks.pre_dur*opto_spks.fs : opto_spks.pre_dur*opto_spks.fs + opto_spks.fs*opto_spks.on_dur;

        types = unique(opto_info.type);
        levels = unique(opto_info.level);
        for j = 1 : numel(levels)
            for k = 1 : numel(types)

                if strcmp(types(k), '5 hz pulse train')
                    inds = find(strcmp(opto_info.type, '5 hz pulse train') & opto_info.level==levels(j));
                    str = ['OPTO_5hz_' strrep(num2str(levels(j)), '.', 'point')];
                elseif strcmp(types(k), '40 hz pulse train')
                    inds = find(strcmp(opto_info.type, '40 hz pulse train') & opto_info.level==levels(j));
                    str = ['OPTO_40hz_' strrep(num2str(levels(j)), '.', 'point')];
                elseif strcmp(types(k), 'raised_cosine')
                    inds = find(strcmp(opto_info.type, 'raised_cosine') & opto_info.level==levels(j));
                    str = ['OPTO_cos_' strrep(num2str(levels(j)), '.', 'point')];
                end

                if ~isfield(glodb, [str '_mean'])
                    glodb.([str '_mean']) = {};
                    glodb.([str '_sd']) = {};
                    glodb.([str '_n']) = [];
                    glodb.([str '_wsr']) = [];
                    glodb.([str '_baseline_mean']) = [];
                    glodb.([str '_stim_mean']) = [];
                    glodb.([str '_baseline_sd']) = [];
                    glodb.([str '_stim_sd']) = [];
                end

                glodb.([str '_mean']) = [ glodb.([str '_mean']), mean(baseline_correct(opto_data(:,inds),bl_epoch),2) ];
                glodb.([str '_sd']) = [ glodb.([str '_sd']), std(baseline_correct(opto_data(:,inds),bl_epoch), [], 2) ];
                glodb.([str '_n']) = [ glodb.([str '_n']), numel(inds) ];

                glodb.([str '_wsr']) = [glodb.([str '_wsr']),...
                    signrank(mean(baseline_correct(opto_data(stim_epoch,inds), bl_epoch)))];

                glodb.([str '_baseline_mean']) = [ glodb.([str '_baseline_mean']), mean(mean(opto_data(bl_epoch,inds))) ];
                glodb.([str '_stim_mean']) = [ glodb.([str '_stim_mean']), mean(mean(opto_data(stim_epoch,inds))) ];
                glodb.([str '_baseline_sd']) = [ glodb.([str '_baseline_sd']), std(mean(opto_data(bl_epoch,inds))) ];
                glodb.([str '_stim_sd']) = [ glodb.([str '_stim_sd']), std(mean(opto_data(stim_epoch,inds))) ];

            end
        end
    end

end

params.CONDITIONS = CONDITIONS;
params.COMPARISONS_2_SAMPLE = COMPARISONS_2_SAMPLE;
params.COMPARISONS_GROUPWISE = COMPARISONS_GROUPWISE;

end