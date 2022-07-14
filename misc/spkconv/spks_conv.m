function cnv = spks_conv( raw, krnl )
if ndims( raw ) == 2
    tmp = size( raw );
    for i = 1 : tmp( 1 )  
        cnv( i, : ) = spks_convlist( raw( i, : ), krnl );
    end
else
    cnv = spks_convlist(l,k);
end
end