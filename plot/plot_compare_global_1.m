function plot_compare_global_1(i, glo_info, glo_spks, varargin); hold on;

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

go1 = baseline_correct(squeeze(glo_spks.conv(i,:,find(glo_info.go_gloexp))), bl_epoch);

[m,l,u] = confidence_interval(double(go1));
plot_ci(smooth(l,ss),smooth(u,ss),p_vec,[.5 0 0],.25)
Global = plot(p_vec,smooth(m,ss),'linewidth',2,'color',[.5 0 0]);


go2 = baseline_correct(squeeze(glo_spks.conv(i,:,find(glo_info.go_seqctl))), bl_epoch);

[m,l,u] = confidence_interval(double(go2));
plot_ci(smooth(l,ss),smooth(u,ss),p_vec,[.9 0 0],.25)
Ident = plot(p_vec,smooth(m,ss),'linewidth',2,'color',[.9 0 0]);

set(gca,'XLim',[glo_spks.pre_dur*-1000 (glo_spks.on_dur+glo_spks.off_dur)*1000], 'box', 'on')
title('Global Oddball Response')
legend([Global, Ident],{'Global','Ctl Ident'},'location','northwest')

end