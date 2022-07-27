function plot_unit_info_hist(i, unit_info, f1)

hold on;
histogram(unit_info.(f1), 'facecolor', [.5 .5 .5])
v1 = vline(unit_info.(f1)(i));
set(v1, 'color', 'r', 'linewidth', 2)
title(strrep(f1, '_', ' '))

end