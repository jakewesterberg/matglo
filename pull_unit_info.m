function unit_info = pull_unit_info(nwb)

% Jake Westerberg
% Vanderbilt University
% jakewesterberg@gmail.com

%% Pull out spikes
unit_info.spk_times           = nwb.units.spike_times.data(:);
unit_info.spk_assign          = nwb.units.spike_times_index.data(:);

% Give spikes a neuron id
for i = 1:numel(unit_info.spk_assign)
    if i == 1;              unit_info.spk_unit = repmat(i,unit_info.spk_assign(i),1);
    else;                   unit_info.spk_unit = cat(1, unit_info.spk_unit, ...
                                                        repmat(i, unit_info.spk_assign(i)-unit_info.spk_assign(i-1), 1));
    end
end

unit_info.total                     = numel(unit_info.spk_assign);

unit_info.subject_identifier        = repmat({nwb.general_subject.subject_id}, unit_info.total, 1);
unit_info.subject_age               = repmat({nwb.general_subject.age}, unit_info.total, 1);
unit_info.subject_genotype          = repmat({nwb.general_subject.genotype}, unit_info.total, 1);
unit_info.subject_sex               = repmat({nwb.general_subject.sex}, unit_info.total, 1);
unit_info.subject_species           = repmat({nwb.general_subject.species}, unit_info.total, 1);
unit_info.subject_strain            = repmat({nwb.general_subject.strain}, unit_info.total, 1);

unit_info.probe                     = floor(nwb.units.vectordata.get('peak_channel_id').data(:) / 1000);
unit_info.channel                   = mod(nwb.units.vectordata.get('peak_channel_id').data(:), 1000)+1;

for i = 1 : unit_info.total
    unit_info.waveprint(:,:,i)      = nwb.units.waveform_mean.data(:,i*384-383:i*384);

    try unit_info.waveform(:,i)     = unit_info.waveprint(:,mod(nwb.units.vectordata.get('peak_channel_id').data(i), 1000)+1,i);
    catch; unit_info.waveform(:,i)  = zeros(82,1); end

    [~,ind1]                        = max(abs(max(unit_info.waveprint(:,:,i))-min(unit_info.waveprint(:,:,i))));
    unit_info.minmax_channel(:,i)   = ind1;
    unit_info.minmax_waveform(:,i)  = unit_info.waveprint(:,ind1,i);

    unit_info.area{i}               = nwb.general_extracellular_ephys_electrodes.vectordata.get('location').data{unit_info.channel(i)+unit_info.probe(i)*384};
    unit_info.minmax_area{i}        = nwb.general_extracellular_ephys_electrodes.vectordata.get('location').data{unit_info.minmax_channel(i)+unit_info.probe(i)*384};

end

% misc. kilosort output
unit_info.PT_ratio                  = nwb.units.vectordata.get('PT_ratio').data(:); 
unit_info.amplitude                 = nwb.units.vectordata.get('amplitude').data(:);
unit_info.amplitude_cutoff          = nwb.units.vectordata.get('amplitude_cutoff').data(:);
unit_info.cluster_id                = nwb.units.vectordata.get('cluster_id').data(:);
unit_info.cumulative_drift          = nwb.units.vectordata.get('cumulative_drift').data(:);
unit_info.d_prime                   = nwb.units.vectordata.get('d_prime').data(:);
unit_info.firing_rate               = nwb.units.vectordata.get('firing_rate').data(:);
unit_info.isi_violations            = nwb.units.vectordata.get('isi_violations').data(:);
unit_info.isolation_distance        = nwb.units.vectordata.get('isolation_distance').data(:);
unit_info.l_ratio                   = nwb.units.vectordata.get('l_ratio').data(:);
unit_info.local_index               = nwb.units.vectordata.get('local_index').data(:);
unit_info.max_drift                 = nwb.units.vectordata.get('max_drift').data(:);
unit_info.nn_hit_rate               = nwb.units.vectordata.get('nn_hit_rate').data(:);
unit_info.nn_miss_rate              = nwb.units.vectordata.get('nn_miss_rate').data(:);
unit_info.peak_channel_id           = nwb.units.vectordata.get('peak_channel_id').data(:);
unit_info.presence_ration           = nwb.units.vectordata.get('presence_ratio').data(:);
unit_info.quality                   = nwb.units.vectordata.get('quality').data(:);
unit_info.recovery_slope            = nwb.units.vectordata.get('recovery_slope').data(:);
unit_info.repolarization_slope      = nwb.units.vectordata.get('repolarization_slope').data(:);
unit_info.silhouette_score          = nwb.units.vectordata.get('silhouette_score').data(:);
unit_info.snr                       = nwb.units.vectordata.get('snr').data(:);
unit_info.spike_amplitudes          = nwb.units.vectordata.get('spike_amplitudes').data(:);
unit_info.spike_amplitudes_index    = nwb.units.vectordata.get('spike_amplitudes_index').data(:);
unit_info.spread                    = nwb.units.vectordata.get('spread').data(:);
unit_info.velocity_above            = nwb.units.vectordata.get('velocity_above').data(:);
unit_info.velocity_below            = nwb.units.vectordata.get('velocity_below').data(:);
unit_info.waveform_duration         = nwb.units.vectordata.get('waveform_duration').data(:);
unit_info.waveform_halfwidth        = nwb.units.vectordata.get('waveform_halfwidth').data(:);
unit_info.waveform_mean_index       = nwb.units.vectordata.get('waveform_mean_index').data(:);

end