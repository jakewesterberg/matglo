function plot_gloexp_p4(i, glo_info, glo_spks, varargin); hold on;

be = 0.05;
ss = 5;

varStrInd = find(cellfun(@ischar,varargin));
for iv = 1:length(varStrInd)
    switch varargin{varStrInd(iv)}
        case {'-be','bl_epoch'}
            be = varargin{varStrInd(iv)+1};
        case {'-ss', 'smoothing_span'}
            ss = varargin{varStrInd(iv)+1};
        case {'-a', 'axis'}
            ax = varargin{varStrInd(iv)+1};
    end
end

p_vec = (glo_spks.pre_dur*-1000)-(1000/glo_spks.fs):(1000/glo_spks.fs):((glo_spks.on_dur+glo_spks.off_dur)*1000);

bl_epoch = (glo_spks.pre_dur*glo_spks.fs-be*glo_spks.fs):(glo_spks.pre_dur*glo_spks.fs);
pres_epoch = (-1* glo_spks.pre_dur*glo_spks.fs) + 1000/glo_spks.fs : ...
    1000/glo_spks.fs : ...
    (glo_spks.on_dur*glo_spks.fs + glo_spks.off_dur*glo_spks.fs);

p3 = baseline_correct(squeeze(glo_spks.conv(i,:,find(glo_info.pres3 & glo_info.gloexp))), bl_epoch);

[m,l,u] = confidence_interval(double(p3));
plot_ci(smooth(l,ss),smooth(u,ss), p_vec,[.1 .1 .1],.25)
P3 = plot(p_vec, smooth(m,ss),'linewidth',2,'color',[.1 .1 .1]);


lo = baseline_correct(squeeze(glo_spks.conv(i,:,find(glo_info.lo_gloexp))), bl_epoch);

[m,l,u] = confidence_interval(double(lo));
plot_ci(smooth(l,ss),smooth(u,ss),p_vec,[0 .5 0],.25)
Local = plot(p_vec,smooth(m,ss),'linewidth',2,'color',[0 .5 0]);


go = baseline_correct(squeeze(glo_spks.conv(i,:,find(glo_info.go_gloexp))), bl_epoch);

[m,l,u] = confidence_interval(double(go));
plot_ci(smooth(l,ss),smooth(u,ss),p_vec,[.9 0 0],.25)
Global = plot(p_vec,smooth(m,ss),'linewidth',2,'color',[.9 0 0]);

set(gca,'XLim',[glo_spks.pre_dur*-1000 (glo_spks.on_dur+glo_spks.off_dur)*1000], 'box', 'on')
title('GLO P4')
legend([P3,Local,Global],{'P3','Local','Global'},'location','northwest')

end