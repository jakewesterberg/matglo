function unit_evaluation(ident, unit_info, rf_info, rf_spks, opto_info, opto_spks, glo_info, glo_spks, varargin)

varStrInd = find(cellfun(@ischar,varargin));
for iv = 1:length(varStrInd)
    switch varargin{varStrInd(iv)}
        case {'units'}
            units = varargin{varStrInd(iv)+1};
        case {'do_save'}
            do_save = varargin{varStrInd(iv)+1};
    end
end

if ~exist('units'); units = 1:unit_info.total; end

for i = units

    figure('Units', 'normalized','Position',[0 0 1 1]); tiledlayout(6, 7, 'TileSpacing', 'tight');

    nexttile([4 2]);
    imagesc(unit_info.waveprint(:,:,i)');
    [~,ind1] = max(abs(max(unit_info.waveprint(:,:,i))-min(unit_info.waveprint(:,:,i))));
    h1 = hline(ind1);
    set(h1, 'color', 'k', 'linewidth', 2, 'linestyle', ':')
    set(gca, 'linewidth', 1, 'Color', 'k', 'xtick', [])
    title(unit_info.quality(i))

    nexttile([1 2]);
    p1 = plot(unit_info.waveprint(:,ind1,i), 'color', 'k', 'linewidth', 2);
    h2 = hline(0);
    set(h2, 'color', 'r', 'linestyle', ':', 'linewidth', 1)
    set(gca, 'xlim', [1 82], 'xtick', [])
    title('Waveform')

    nexttile();
    plot_unit_info_hist(i, unit_info, 'waveform_halfwidth')

    nexttile();
    plot_unit_info_hist(i, unit_info, 'waveform_duration')

    nexttile();
    plot_unit_info_hist(i, unit_info, 'amplitude')

    nexttile([1 2]);
    plot_opto(i, opto_info, opto_spks, '5 hz pulse train')

    nexttile();
    plot_unit_info_hist(i, unit_info, 'PT_ratio')

    nexttile();
    plot_unit_info_hist(i, unit_info, 'recovery_slope')

    nexttile();
    plot_unit_info_hist(i, unit_info, 'repolarization_slope')

    nexttile([1 2]);
    plot_opto(i, opto_info, opto_spks, '40 hz pulse train')

    nexttile();
    plot_unit_info_hist(i, unit_info, 'velocity_above')

    nexttile();
    plot_unit_info_hist(i, unit_info, 'velocity_below')

    nexttile();
    plot_unit_info_hist(i, unit_info, 'l_ratio')

    nexttile([1 2]);
    plot_opto(i, opto_info, opto_spks, 'raised_cosine')

    nexttile();
    plot_unit_info_hist(i, unit_info, 'd_prime')

    nexttile();
    plot_unit_info_hist(i, unit_info, 'snr')

    nexttile();
    plot_unit_info_hist(i, unit_info, 'isi_violations')

    nexttile([2 2]);
    plot_rf(i, rf_info, rf_spks);

    nexttile([2 2]);
    plot_unit_stamina(i,glo_spks,rf_spks,opto_spks);

    nexttile();
    plot_unit_info_hist(i, unit_info, 'firing_rate')

    nexttile();
    plot_unit_info_hist(i, unit_info, 'isolation_distance')

    nexttile();
    plot_unit_info_hist(i, unit_info, 'silhouette_score')

    nexttile();
    plot_unit_info_hist(i, unit_info, 'spread')

    nexttile();
    plot_unit_info_hist(i, unit_info, 'nn_hit_rate')

    nexttile();
    plot_unit_info_hist(i, unit_info, 'nn_miss_rate')

    if exist('do_save', 'var')
        pause(0.01); fname = [do_save filesep ident '-unit-' num2str(i) '-uniteval.png'];
        saveas(gcf,fname)
    end


    figure('Units', 'normalized', 'Position',[0 0 1 1]); tiledlayout(8, 12);
    % Main comparison
    nexttile([4 4])
    plot_gloexp_p4(i, glo_info, glo_spks, '-ss', 25); hold on;

    % Full GLO sequences
    nexttile([2 8])
    plot_gloexp(i, glo_info, glo_spks, '-ss', 25)

    % GLO in control
    nexttile([2 8])
    plot_rndctl_glo(i, glo_info, glo_spks, '-ss', 25)

    % Local comp 1
    nexttile([2 2])
    plot_compare_local_1(i, glo_info, glo_spks, '-ss', 25)

    % Local comp 2
    nexttile([2 2])
    plot_compare_local_2(i, glo_info, glo_spks, '-ss', 25)

    % iGLO sequences in random control
    nexttile([2 8])
    plot_rndctl_iglo(i, glo_info, glo_spks, '-ss', 25)

    % Global comp
    nexttile([2 2])
    plot_compare_global_1(i, glo_info, glo_spks, '-ss', 25)

    % Selectivity control all
    nexttile([2 2])
    plot_selectivity(i, glo_info, glo_spks, '-ss', 25)

    % GO in context
    nexttile([2 8])
    plot_context(i, glo_info, glo_spks, '-ss', 25)

    if exist('do_save', 'var')
        pause(0.01); fname = [do_save filesep ident '-unit-' num2str(i) '-gloeval.png'];
        saveas(gcf,fname)
    end
    
    close all

end
end