function glo_info = pull_glo_info(nwb, file_path)

% Jake Westerberg
% Vanderbilt University
% jakewesterberg@gmail.com

% GLO presentation times
glo_info.on                                 = nwb.intervals.get('init_grating_presentations').start_time.data(:);
glo_info.off                                = nwb.intervals.get('init_grating_presentations').stop_time.data(:);

% GLO stimulus information
glo_info.ori                                = nwb.intervals.get('init_grating_presentations').vectordata.get('orientation').data(:); % orientation
glo_info.tf                                 = nwb.intervals.get('init_grating_presentations').vectordata.get('temporal_frequency').data(1); % temporal frequency (drift rate)  
glo_info.sf                                 = nwb.intervals.get('init_grating_presentations').vectordata.get('spatial_frequency').data(1); % spatial frequency
glo_info.contrast                           = nwb.intervals.get('init_grating_presentations').vectordata.get('contrast').data(1); % stimulus contrast

% first presentation is always a local oddball trial
glo_info.go              = glo_info.ori(1);
glo_info.lo              = glo_info.ori(4);

% all possible sequence combinations
glo_info.seq_combos                         = [ glo_info.go, glo_info.go, glo_info.go, glo_info.go; glo_info.go, glo_info.go, glo_info.go, glo_info.lo; ...
                                                glo_info.go, glo_info.go, glo_info.lo, glo_info.go; glo_info.go, glo_info.lo, glo_info.go, glo_info.go; ...
                                                glo_info.lo, glo_info.go, glo_info.go, glo_info.go; glo_info.go, glo_info.go, glo_info.lo, glo_info.lo; ...
                                                glo_info.go, glo_info.lo, glo_info.go, glo_info.lo; glo_info.lo, glo_info.go, glo_info.go, glo_info.lo; ...
                                                glo_info.go, glo_info.lo, glo_info.lo, glo_info.go; glo_info.lo, glo_info.go, glo_info.lo, glo_info.go; ...
                                                glo_info.lo, glo_info.lo, glo_info.go, glo_info.go; glo_info.go, glo_info.lo, glo_info.lo, glo_info.lo; ...
                                                glo_info.lo, glo_info.go, glo_info.lo, glo_info.lo; glo_info.lo, glo_info.lo, glo_info.go, glo_info.lo; ...
                                                glo_info.lo, glo_info.lo, glo_info.lo, glo_info.go; glo_info.lo, glo_info.lo, glo_info.lo, glo_info.lo ];

% count total trials in glo
glo_info.total_trials                       = numel(glo_info.on);

% identify important sequence types
glo_info.seq_go                             = [glo_info.go, glo_info.go, glo_info.go, glo_info.go];
glo_info.seq_lo                             = [glo_info.go, glo_info.go, glo_info.go, glo_info.lo];
glo_info.seq_ilo                            = [glo_info.lo, glo_info.lo, glo_info.lo, glo_info.go];
glo_info.seq_igo                            = [glo_info.lo, glo_info.lo, glo_info.lo, glo_info.lo];

% and code them relative to the combo matrix above
glo_info.seq_go_type                        = 1;
glo_info.seq_lo_type                        = 2;
glo_info.seq_ilo_type                       = 15;
glo_info.seq_igo_type                       = 16;

% find glo sequence info
glo_info.seq_type                           = [];
for i = 1 : 5 : glo_info.total_trials
    if (~floor(sum(glo_info.ori(i:i+3)==glo_info.seq_go')/4) & ...
            ~floor(sum(glo_info.ori(i:i+3)==glo_info.seq_lo')/4)) & ...
            ~isfield(glo_info, 'gloexp')

        % index the positions of main experiment vs. control sequence presentations
        glo_info.gloexp                     = zeros(glo_info.total_trials,1); glo_info.gloexp(1:i-1) = 1; % main glo sequences
        glo_info.rndctl                     = zeros(glo_info.total_trials,1); glo_info.rndctl(i:end-500) = 1; % randomized control sequences
        glo_info.seqctl                     = zeros(glo_info.total_trials,1); glo_info.seqctl(end-499:end) = 1; % sequenced control with alternating [g g g g, l l l l, etc.]
    end

    % code the sequence types in case we determine other seq combos are
    % interesting
    glo_info.seq_type                       = [glo_info.seq_type; repmat(find(sum(glo_info.seq_combos == glo_info.ori(i:i+3)',2)==4),5,1)]; % give each sequence a code relative combo matrix
end

% identify useful sequences
glo_info.go_seq                             = glo_info.seq_type == glo_info.seq_go_type;
glo_info.lo_seq                             = glo_info.seq_type == glo_info.seq_lo_type;
glo_info.igo_seq                            = glo_info.seq_type == glo_info.seq_igo_type;
glo_info.ilo_seq                            = glo_info.seq_type == glo_info.seq_ilo_type;

% index presentation numbers within sequence
glo_info.pres1                              = zeros(glo_info.total_trials,1); glo_info.pres1(1:5:end) = 1; % first presentation in a sequence (no adaptation)
glo_info.pres2                              = zeros(glo_info.total_trials,1); glo_info.pres2(2:5:end) = 1;               
glo_info.pres3                              = zeros(glo_info.total_trials,1); glo_info.pres3(3:5:end) = 1; % stimulus prior to the oddball              
glo_info.pres4                              = zeros(glo_info.total_trials,1); glo_info.pres4(4:5:end) = 1; % sequence position we are most interested in (where the oddball occurs)               

% index intertrial(sequence) interval
glo_info.iti                                = zeros(glo_info.total_trials,1); glo_info.iti(5:5:end) = 1; % gray intertrial screens (good baseline epoch) (not the black screen intermission)

% predetermine some useful combinations
glo_info.go_gloexp                          = glo_info.seq_type == glo_info.seq_go_type & glo_info.gloexp & glo_info.pres4; % global oddball presentations
glo_info.lo_gloexp                          = glo_info.seq_type == glo_info.seq_lo_type & glo_info.gloexp & glo_info.pres4; % local oddball presentations

glo_info.go_rndctl                          = glo_info.seq_type == glo_info.seq_go_type & glo_info.rndctl & glo_info.pres4; % 'global oddball' presentation in random control
glo_info.lo_rndctl                          = glo_info.seq_type == glo_info.seq_lo_type & glo_info.rndctl & glo_info.pres4; % 'local oddball' presentation in random control
glo_info.igo_rndctl                         = glo_info.seq_type == glo_info.seq_igo_type & glo_info.rndctl & glo_info.pres4; % inverse 'global oddball' presentation in random control [l l l g] insead of [g g g l]
glo_info.ilo_rndctl                         = glo_info.seq_type == glo_info.seq_ilo_type & glo_info.rndctl & glo_info.pres4; % inverse 'local oddball' presentation in random control [l l l l] insead of [g g g g]

glo_info.go_seqctl                          = glo_info.seq_type == glo_info.seq_go_type & glo_info.seqctl & glo_info.pres4; % 'global oddball' presentation in sequence control
glo_info.igo_seqctl                         = glo_info.seq_type == glo_info.seq_igo_type & glo_info.seqctl & glo_info.pres4; % inverse 'local oddball' presentation in sequence control [l l l l] insead of [g g g g]

% Convert to logicals
glo_info.go_seq                             = logical(glo_info.go_seq);
glo_info.lo_seq                             = logical(glo_info.lo_seq);
glo_info.igo_seq                            = logical(glo_info.igo_seq);
glo_info.ilo_seq                            = logical(glo_info.ilo_seq);
glo_info.pres1                              = logical(glo_info.pres1);
glo_info.pres2                              = logical(glo_info.pres2);
glo_info.pres3                              = logical(glo_info.pres3);
glo_info.pres4                              = logical(glo_info.pres4);
glo_info.iti                                = logical(glo_info.iti);
glo_info.gloexp                             = logical(glo_info.gloexp);
glo_info.rndctl                             = logical(glo_info.rndctl);
glo_info.seqctl                             = logical(glo_info.seqctl);

if exist('file_path', 'var')
    save([file_path 'glo_info' '.mat'], 'glo_info', '-v7.3', '-nocompression')
end

end