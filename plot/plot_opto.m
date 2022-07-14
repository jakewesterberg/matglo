function plot_opto(i, opto_info, opto_spks, varargin); hold on;

varStrInd = find(cellfun(@ischar,varargin));
for iv = 1:length(varStrInd)
    switch varargin{varStrInd(iv)}
        case {'-be','bl_epoch'}
            be = varargin{varStrInd(iv)+1};
        case {'-ss', 'smoothing_span'}
            ss = varargin{varStrInd(iv)+1};
        case {'-c', 'conditions'}
            optos = varargin{varStrInd(iv)+1};
    end
end


uniq_opto = unique(optos);
for j =  1 : numel(uniq_opto)
    tspk = [squeeze(opto.pre_spks_conv(i,:,strcmp(opto.type, uniq_opto{j}))); ...
        squeeze(opto.on_spks_conv(i,:,strcmp(optos, uniq_opto{j}))); ...
        squeeze(opto.off_spks_conv(i,:,strcmp(optos, uniq_opto{j})))];

    tspk = tspk - repmat(mean(squeeze(opto.pre_spks_conv(i,end-19:end,strcmp(opto.type, uniq_opto{j})))), 600, 1);

    [m,l,u] = H_CI(double(tspk));
    ciplot(smooth(l),smooth(u),-995:5:2000, [1-(.2*j) 0 1-(.2*j)],.25)
    lines{j}=plot(-995:5:2000,smooth(m),'linewidth',2,'color', [1-(.2*j) 0 1-(.2*j)]);
end
legend([lines{1} lines{2} lines{3}], uniq_opto,'location','northwest')
set(gca,'XLim',[-1000 2000])
title('Condition-wise Opto')
box on

end