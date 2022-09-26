function dat = baseline_correct(dat, bl_epoch)

if ndims(dat) == 2
    dat = dat - repmat(nanmean(dat(bl_epoch,:)), size(dat,1), 1);
elseif ndims(dat) == 3
    dat = dat - repmat(nanmean(dat(bl_epoch,:,:)), size(dat,1), 1);
end

end