function dat = common_average_reference(dat)

if ndims(dat) == 2
    dat = dat - repmat(nanmean(dat,2), 1, size(dat,2));
elseif ndims(dat) == 3
    %dat = dat - repmat(nanmean(dat,2), 1, size(dat,2), 1);
    dat = dat - repmat(dat(:,1,:), 1, size(dat,2), 1);
end

end