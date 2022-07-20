function cnv = spks_conv( cnv, k )
cnv_len = length(cnv);
cnv_pre = mean(cnv(:,1:floor(length(k)/2)),2)*ones(1,floor(length(k)/2));
cnv_post = mean(cnv(:,cnv_len-floor(length(k)/2):cnv_len),2)*ones(1,floor(length(k)/2));
parfor i = 1 : height(cnv)
    cnv(i,:) = paren(conv([ cnv_pre(i,:) cnv(i,:) cnv_post(i,:) ], k), round(length(k)-1):round(length(k)-1)+cnv_len-1);
end
end
