function plot_glo_p4(i, glo_info, glo_spks, varargin); hold on;

bl_epoch = (glo_spks.pre_dur*glo_spks.fs-.05*glo_spks.fs):(glo_spks.pre_dur*glo_spks.fs);


tspk = baseline_correct(squeeze(glo_spks.conv(i,:,find(glo_info.p3 & glo_info.gloexp))), bl_epoch);

[m,l,u] = confidence_interval(double(p3));
ciplot(smooth(l),smooth(u),-495:5:1000,[.1 .1 .1],.25)
P3 = plot(-495:5:1000,smooth(m),'linewidth',2,'color',[.1 .1 .1]);


lo = [squeeze(glo_spks.pre_spks_conv(i,:,find(glo_spks.local_trial_pres))); ...
    squeeze(glo_spks.on_spks_conv(i,:,find(glo_spks.local_trial_pres))); ...
    squeeze(glo_spks.off_spks_conv(i,:,find(glo_spks.local_trial_pres)))];

[m,l,u] = confidence_interval(double(lo));
ciplot(smooth(l),smooth(u),-495:5:1000,[0 .5 0],.25)
Local = plot(-495:5:1000,smooth(m),'linewidth',2,'color',[0 .5 0]);


go = [squeeze(glo_spks.pre_spks_conv(i,:,find(glo_spks.global_trial_pres))); ...
    squeeze(glo_spks.on_spks_conv(i,:,find(glo_spks.global_trial_pres))); ...
    squeeze(glo_spks.off_spks_conv(i,:,find(glo_spks.global_trial_pres)))];

[m,l,u] = confidence_interval(double(go));
ciplot(smooth(l),smooth(u),-495:5:1000,[.9 0 0],.25)
Global = plot(-495:5:1000,smooth(m),'linewidth',2,'color',[.9 0 0]);

set(gca,'XLim',[-500 1000], 'box', 'on')
title('GLO P4')
legend([P3,Local,Global],{'P3','Local','Global'},'location','northwest')

end