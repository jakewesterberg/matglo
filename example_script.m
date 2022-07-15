% Have matnwb and matglo on the pathciplot
FILE = 'S:\Dropbox\_DATA\GLO_pilot_data\raw_nwb\sub-1179909741_ses-1179909741.nwb';

nwb = load_nwb(FILE);

rf_info = pull_rf_info(nwb);
glo_info = pull_glo_info(nwb);
opto_info = pull_opto_info(nwb);

unit_info = pull_unit_info(nwb);

rf_spks = pull_spks(unit_info, rf_info, 'fs', 1000, 'pre_dur', .25, 'on_dur', .25, 'off_dur', .25);
glo_spks = pull_spks(unit_info, glo_info, 'fs', 1000, 'pre_dur', .5, 'on_dur', .5, 'off_dur', .5);
opto_spks = pull_spks(unit_info, opto_info, 'fs', 1000, 'pre_dur', 1, 'on_dur', 1, 'off_dur', 1);

save([FILE(1:end-4) '.mat'], 'rf_info', 'glo_info', 'opto_info', 'unit_info', 'rf_spks', 'glo_spks', 'opto_spks', '-v7.3')

clear


FILE = 'S:\Dropbox\_DATA\GLO_pilot_data\raw_nwb\sub-0000000000_ses-1180116198.nwb';

nwb = load_nwb(FILE);

rf_info = pull_rf_info(nwb);
glo_info = pull_glo_info(nwb);
opto_info = pull_opto_info(nwb);

unit_info = pull_unit_info(nwb);

rf_spks = pull_spks(unit_info, rf_info, 'fs', 1000, 'pre_dur', .25, 'on_dur', .25, 'off_dur', .25);
glo_spks = pull_spks(unit_info, glo_info, 'fs', 1000, 'pre_dur', .5, 'on_dur', .5, 'off_dur', .5);
opto_spks = pull_spks(unit_info, opto_info, 'fs', 1000, 'pre_dur', 1, 'on_dur', 1, 'off_dur', 1);

save([FILE(1:end-4) '.mat'], 'rf_info', 'glo_info', 'opto_info', 'unit_info', 'rf_spks', 'glo_spks', 'opto_spks', '-v7.3')

clear



FILE = 'S:\Dropbox\_DATA\GLO_pilot_data\raw_nwb\sub-1186358749_ses-1186358749.nwb';

nwb = load_nwb(FILE);

rf_info = pull_rf_info(nwb);
glo_info = pull_glo_info(nwb);
opto_info = pull_opto_info(nwb);

unit_info = pull_unit_info(nwb);

rf_spks = pull_spks(unit_info, rf_info, 'fs', 1000, 'pre_dur', .25, 'on_dur', .25, 'off_dur', .25);
glo_spks = pull_spks(unit_info, glo_info, 'fs', 1000, 'pre_dur', .5, 'on_dur', .5, 'off_dur', .5);
opto_spks = pull_spks(unit_info, opto_info, 'fs', 1000, 'pre_dur', 1, 'on_dur', 1, 'off_dur', 1);

save([FILE(1:end-4) '.mat'], 'rf_info', 'glo_info', 'opto_info', 'unit_info', 'rf_spks', 'glo_spks', 'opto_spks', '-v7.3')