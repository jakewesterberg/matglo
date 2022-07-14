function plot_context(i, glo_info, glo_spks, varargin); hold on;

be = 0.05;
ss = 5;

varStrInd = find(cellfun(@ischar,varargin));
for iv = 1:length(varStrInd)
    switch varargin{varStrInd(iv)}
        case {'-be','bl_epoch'}
            be = varargin{varStrInd(iv)+1};
        case {'-ss', 'smoothing_span'}
            ss = varargin{varStrInd(iv)+1};
    end
end

bl_epoch = (glo_spks.pre_dur*glo_spks.fs-be*glo_spks.fs):(glo_spks.pre_dur*glo_spks.fs);
onoff_epoch = (glo_spks.pre_dur*glo_spks.fs+1):(glo_spks.pre_dur+glo_spks.on_dur+glo_spks.off_dur)*glo_spks.fs;
pres_epoch = (-1* glo_spks.pre_dur*1000) + 1000/glo_spks.fs : ...
    1000/glo_spks.fs : ...
    (((glo_spks.on_dur + glo_spks.off_dur)*1000)*4);

glo = baseline_correct([ squeeze(glo_spks.conv(i,:,find(glo_info.go_gloexp)-3)); ...
                        squeeze(glo_spks.conv(i,onoff_epoch,find(glo_info.go_gloexp)-2)); ...
                        squeeze(glo_spks.conv(i,onoff_epoch,find(glo_info.go_gloexp)-1)); ...
                        squeeze(glo_spks.conv(i,onoff_epoch,find(glo_info.go_gloexp)))], ...
                        bl_epoch);

[m,l,u] = confidence_interval(double(glo));
plot_ci(smooth(l,ss),smooth(u,ss),pres_epoch,[.9 0 0],.25)
GLO = plot(pres_epoch,smooth(m,ss),'linewidth',2,'color',[.9 0 0]);

rnd = baseline_correct([ squeeze(glo_spks.conv(i,:,find(iglo_info.go_rndctl)-3)); ...
                        squeeze(glo_spks.conv(i,onoff_epoch,find(glo_info.go_rndctl)-2)); ...
                        squeeze(glo_spks.conv(i,onoff_epoch,find(glo_info.go_rndctl)-1)); ...
                        squeeze(glo_spks.conv(i,onoff_epoch,find(glo_info.go_rndctl)))], ...
                        bl_epoch);

[m,l,u] = confidence_interval(double(rnd));
plot_ci(smooth(l,ss),smooth(u,ss),pres_epoch,[.9 .66 0],.25)
RND = plot(pres_epoch,smooth(m,ss),'linewidth',2,'color',[.9 .66 0]);

seq = baseline_correct([ squeeze(glo_spks.conv(i,:,find(iglo_info.go_seqctl)-3)); ...
                        squeeze(glo_spks.conv(i,onoff_epoch,find(glo_info.go_seqctl)-2)); ...
                        squeeze(glo_spks.conv(i,onoff_epoch,find(glo_info.go_seqctl)-1)); ...
                        squeeze(glo_spks.conv(i,onoff_epoch,find(glo_info.go_seqctl)))], ...
                        bl_epoch);

[m,l,u] = confidence_interval(double(seq));
plot_ci(smooth(l,ss),smooth(u,ss),pres_epoch, [.9 .9 0],.25)
SEQ = plot(pres_epoch,smooth(m,ss),'linewidth',2,'color',[.9 .9 0]);


legend([GLO, RND, SEQ],{'GLO','Random','Seqd'},'location','northwest', 'box', 'on')
set(gca,'XLim',[(-1* glo_spks.pre_dur*1000) (glo_spks.on_dur*1000 + glo_spks.off_dur*1000)*4])
title('GLO in Random Control')

end