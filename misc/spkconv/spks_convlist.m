function cl = spks_convlist(l,k)

hlen    = floor(length(k)/2);
llen    = length(l);
begmean = mean(l(1:hlen))*ones(1,hlen);
endmean = mean(l(llen-hlen:llen))*ones(1,hlen);
ltmp    = [begmean l endmean];
tmp    = conv(ltmp,k);
start  = round(length(k)-1);
finish = start+length(l)-1;
cl     = tmp([start:finish]);

end