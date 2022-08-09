for i =  1:3
    if i == 1;      FILE = 'C:\Users\westerja\Dropbox\_DATA\000253\sub-1169714184\sub-1169714184_ses-1180116198.nwb';
    elseif i == 2;  FILE = 'C:\Users\westerja\Dropbox\_DATA\000253\sub-1170220944\sub-1170220944_ses-1186358749.nwb';
    elseif i == 3;  FILE = 'C:\Users\westerja\Dropbox\_DATA\000253\sub-1170425945\sub-1170425945_ses-1179909741.nwb';
    end

nwb = load_nwb(FILE);

[file_path, file_name] = fileparts(FILE);
file_path = [file_path filesep];

tic
rf_info = pull_rf_info(nwb);
save([file_path 'rf_info' '.mat'], 'rf_info', '-v7.3')
toc

tic
glo_info = pull_glo_info(nwb);
save([file_path 'glo_info' '.mat'], 'glo_info', '-v7.3')
toc

tic
opto_info = pull_opto_info(nwb);
save([file_path 'opto_info' '.mat'], 'opto_info', '-v7.3')
toc

tic
unit_info = pull_unit_info(nwb);
save([file_path 'unit_info' '.mat'], 'unit_info', '-v7.3')
toc

tic
pull_spks(unit_info, rf_info, 'fs', 1000, 'pre_dur', .05, 'on_dur', .25, 'off_dur', .05, 'file_path', file_path, 'file_name', 'rf_spks.mat');
toc

tic
pull_spks(unit_info, glo_info, 'fs', 1000, 'pre_dur', .5, 'on_dur', .5, 'off_dur', .5, 'file_path', file_path, 'file_name', 'glo_spks.mat');
toc

tic
pull_spks(unit_info, opto_info, 'fs', 1000, 'pre_dur', 1, 'on_dur', 1, 'off_dur', 1, 'file_path', file_path, 'file_name', 'opto_spks.mat');
toc

clear nwb

end

% 
% FILE = 'S:\Dropbox\_DATA\GLO_pilot_data\raw_nwb\sub-0000000000_ses-1180116198.nwb';
% 
% nwb = load_nwb(FILE);
% 
% rf_info = pull_rf_info(nwb);
% glo_info = pull_glo_info(nwb);
% opto_info = pull_opto_info(nwb);
% 
% unit_info = pull_unit_info(nwb);
% 
% rf_spks = pull_spks(unit_info, rf_info, 'fs', 1000, 'pre_dur', .25, 'on_dur', .25, 'off_dur', .25);
% glo_spks = pull_spks(unit_info, glo_info, 'fs', 1000, 'pre_dur', .5, 'on_dur', .5, 'off_dur', .5);
% opto_spks = pull_spks(unit_info, opto_info, 'fs', 1000, 'pre_dur', 1, 'on_dur', 1, 'off_dur', 1);
% 
% save([FILE(1:end-4) '.mat'], 'rf_info', 'glo_info', 'opto_info', 'unit_info', 'rf_spks', 'glo_spks', 'opto_spks', '-v7.3')
% 
% clear
% 
% 
% 
% FILE = 'S:\Dropbox\_DATA\GLO_pilot_data\raw_nwb\sub-1186358749_ses-1186358749.nwb';
% 
% nwb = load_nwb(FILE);
% 
% rf_info = pull_rf_info(nwb);
% glo_info = pull_glo_info(nwb);
% opto_info = pull_opto_info(nwb);
% 
% unit_info = pull_unit_info(nwb);
% 
% rf_spks = pull_spks(unit_info, rf_info, 'fs', 1000, 'pre_dur', .25, 'on_dur', .25, 'off_dur', .25);
% glo_spks = pull_spks(unit_info, glo_info, 'fs', 1000, 'pre_dur', .5, 'on_dur', .5, 'off_dur', .5);
% opto_spks = pull_spks(unit_info, opto_info, 'fs', 1000, 'pre_dur', 1, 'on_dur', 1, 'off_dur', 1);
% 
% save([FILE(1:end-4) '.mat'], 'rf_info', 'glo_info', 'opto_info', 'unit_info', 'rf_spks', 'glo_spks', 'opto_spks', '-v7.3')