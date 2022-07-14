function dat = baseline_correct(dat, bl_epoch)

if ndims(in) == 2
    dat = dat - repmat(mean(dat(bl_epoch,:)), size(dat,1), 1);
end

end