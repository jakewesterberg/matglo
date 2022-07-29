function plot_rf(i, rf_info, rf_spks); hold on;

uX = unique(rf_info.x);
uY = unique(rf_info.y);

be = 0.05;
bl_epoch = (rf_spks.pre_dur*rf_spks.fs-be*rf_spks.fs)+1:(rf_spks.pre_dur*rf_spks.fs);

t_rf_map = nan(numel(uX), numel(uY));

for j = 1 : numel(uX)
    for k = 1 : numel(uY)
        t_rf_map(j,k) = mean(mean(baseline_correct(squeeze(rf_spks.conv(i,:,rf_info.x == uX(j) & rf_info.y == uY(k))), bl_epoch)));
    end
end

p_rf = imagesc(uX, uY, imgaussfilt(t_rf_map, 1));
%colormap('jet')
p_rf_cb = colorbar();
axis square
box on
title('RF Map')
end
