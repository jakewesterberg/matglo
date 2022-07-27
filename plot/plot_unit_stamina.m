function plot_unit_stamina(i,glo,rf,opto); hold on;

tspk = [ squeeze(mean(glo.conv(i, glo.pre_dur*glo.fs:(glo.pre_dur+glo.on_dur)*glo.fs,find(repmat([1 1 1 1 0], 1, size(glo.conv,3)/5))),2)); ...
    squeeze(mean(rf.conv(i, rf.pre_dur*rf.fs:(rf.pre_dur+rf.on_dur)*rf.fs,:),2)); ...
    squeeze(mean(opto.conv(i, opto.pre_dur*opto.fs:(opto.pre_dur+opto.on_dur)*opto.fs,:),2)) ];
plot(smooth(tspk(2:end),100), 'color', 'k', 'linewidth', 2)

v1 = vline([size(glo.conv,3)*.8 size(glo.conv,3)*.8+size(rf.conv,3)]);
set(v1, 'color', 'r', 'linewidth', 1, 'LineStyle',':')

set(gca, 'XLim', [2 size(glo.conv,3)*.8+size(rf.conv,3)+size(opto.conv,3)])
title('Spk Rate Over Session')
box on

end
