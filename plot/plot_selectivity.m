function plot_selectivity(i,glo_info, glo_spks, varargin); hold on;

be = 0.05;
ss = 5;

s1_vec = find(glo_info.ori == glo_info.go);
s2_vec = find(glo_info.ori == glo_info.lo);

title_ch = 'Selectivity Control';

varStrInd = find(cellfun(@ischar,varargin));
for iv = 1:length(varStrInd)
    switch varargin{varStrInd(iv)}
        case {'-be','bl_epoch'}
            be = varargin{varStrInd(iv)+1};
        case {'-ss', 'smoothing_span'}
            ss = varargin{varStrInd(iv)+1};
        case {'-s1', 'stim1'}
            s1_vec = varargin{varStrInd(iv)+1};
        case {'-s2', 'stim2'}
            s2_vec = varargin{varStrInd(iv)+1};
        case {'-t', 'title'}
            title_ch = varargin{varStrInd(iv)+1};   
    end
end

bl_epoch = (glo_spks.pre_dur*glo_spks.fs-be*glo_spks.fs):(glo_spks.pre_dur*glo_spks.fs);
pres_epoch = (-1* glo_spks.pre_dur*1000) + 1000/glo_spks.fs : ...
    1000/glo_spks.fs : ...
    (((glo_spks.on_dur + glo_spks.off_dur)*1000));
s1 = baseline_correct(squeeze(glo_spks.conv(i,:,s1_vec), bl_epoch);

[m,l,u] = confidence_interval(double(s1));
plot_ci(smooth(l,ss),smooth(u,ss), pres_epoch,[.5 0 0],.25)
S1 = plot(pres_epoch,smooth(m,ss),'linewidth',2,'color',[.5 0 0]);

s2 = baseline_correct(squeeze(glo_spks.conv(i,:,s2_vec)), bl_epoch);

[m,l,u] = confidence_interval(double(s2));
plot_ci(smooth(l,ss),smooth(u,ss), pres_epoch,[0 .5 0],.25)
S2 = plot(pres_epoch,smooth(m,ss),'linewidth',2,'color',[0 .5 0]);


legend([S1,S2],{'S1 (Global)','S2 (Local)'},'location','northwest')
set(gca,'XLim',[(-1* glo_spks.pre_dur*1000) (glo_spks.on_dur*1000 + glo_spks.off_dur*1000)], 'box', 'on')
title(title_ch)
box on
end