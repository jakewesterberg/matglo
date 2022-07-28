function gdb = glo_database(unit_info, glo_spks, opto_spks, varargin)

varStrInd = find(cellfun(@ischar,varargin));
for iv = 1:length(varStrInd)
    switch varargin{varStrInd(iv)}
        case {'-d','db',}
            gdb = varargin{varStrInd(iv)+1};
end

if exist('gdb', 'var'); gdb = table2struct(gdb); else; gdb = struct(); end

if ~isfield(gdb, 'subject');                    gdb.subject = {};                       end
if ~isfield(gdb, 'session');                    gdb.session = [];                       end
if ~isfield(gdb, 'probe');                      gdb.probe = [];                         end
%if ~isfield(gdb, 'brain_area');                 gdb.peak_to_trough_ratio = [];          end
%if ~isfield(gdb, 'cortical_layer');             gdb.peak_to_trough_ratio = [];          end
if ~isfield(gdb, 'AP_peak_to_trough_ratio');    gdb.AP_peak_to_trough_ratio = [];       end
if ~isfield(gdb, 'AP_amplitude');               gdb.AP_amplitude = [];                  end
if ~isfield(gdb, 'AP_amplitude_cutoff');        gdb.AP_amplitude_cutoff = [];           end
if ~isfield(gdb, 'AP_cumulative_drift');        gdb.AP_cumulative_drift = [];           end
if ~isfield(gdb, 'AP_d_prime');                 gdb.AP_d_prime = [];                    end
if ~isfield(gdb, 'AP_firing_rate');             gdb.AP_firing_rate = [];                end
if ~isfield(gdb, 'AP_isi_violations');          gdb.AP_isi_violations = [];             end
if ~isfield(gdb, 'AP_l_ratio');                 gdb.AP_l_ratio = [];                    end
if ~isfield(gdb, 'AP_isolation_distance');      gdb.AP_isolation_distance = [];         end
if ~isfield(gdb, 'AP_local_index');             gdb.AP_local_index = [];                end
if ~isfield(gdb, 'AP_max_drift');               gdb.AP_max_drift = [];                  end
if ~isfield(gdb, 'AP_nn_hit_rate');             gdb.AP_nn_hit_rate = [];                end
if ~isfield(gdb, 'AP_nn_miss_rate');            gdb.AP_nn_miss_rate = [];               end
if ~isfield(gdb, 'AP_presence_ratio');          gdb.AP_presence_ratio = [];             end
if ~isfield(gdb, 'AP_quality');                 gdb.AP_quality = [];                    end
if ~isfield(gdb, 'AP_recovery_slope');          gdb.AP_recovery_slope = [];             end
if ~isfield(gdb, 'AP_repolarization_slope');    gdb.AP_repolarization_slope = [];       end
if ~isfield(gdb, 'AP_silhouette_score');        gdb.AP_silhouette_score = [];           end
if ~isfield(gdb, 'AP_signal_to_noise');         gdb.AP_signal_to_noise = [];            end
if ~isfield(gdb, 'AP_spread');                  gdb.AP_spread = [];                     end
if ~isfield(gdb, 'AP_velocity_above');          gdb.AP_velocity_above = [];             end
if ~isfield(gdb, 'AP_velocity_below');          gdb.AP_velocity_below = [];             end
if ~isfield(gdb, 'AP_waveform_duration');       gdb.AP_waveform_duration = [];          end
if ~isfield(gdb, 'AP_waveform_halfwidth');      gdb.AP_waveform_halfwidth = [];         end



end