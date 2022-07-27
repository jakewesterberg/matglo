function plot_opto(i, opto_info, opto_spks, cond, varargin); hold on;

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

bl_epoch = (opto_spks.pre_dur*opto_spks.fs-be*opto_spks.fs):(opto_spks.pre_dur*opto_spks.fs);
p_vec = (opto_spks.pre_dur*-1000)-(1000/opto_spks.fs):(1000/opto_spks.fs):((opto_spks.on_dur+opto_spks.off_dur)*1000);

tspk = baseline_correct(opto_spks.conv(i,:,find(strcmp(opto_info.type, cond))),bl_epoch);

[m,l,u] = confidence_interval(double(tspk));
plot_ci(smooth(l,ss),smooth(u,ss),p_vec, [.9 0 .9],.25)
plot(p_vec,smooth(m,ss),'linewidth',2,'color', [.9 0 .9]);

set(gca,'XLim',[-1000*opto_spks.pre_dur 1000*(opto_spks.on_dur + opto_spks.off_dur)])
title(['Optotag: ' strrep(cond, '_', ' ')])
box on

end