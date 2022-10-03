function cnx = estimate_connectivity(unit_info, varargin)

% Jake Westerberg
% Vanderbilt University
% jakewesterberg@gmail.com

% defaults
file_path = [pwd filesep];
file_name = 'default_file_name.mat';
hyperparamter.fs = 30; % sampling rate per ms

varStrInd = find(cellfun(@ischar,varargin));
for iv = 1:length(varStrInd)
    switch varargin{varStrInd(iv)}
        case {'-p', 'file_path'}
            file_path = varargin{varStrInd(iv)+1};
        case {'-n', 'file_name'}
            file_name = varargin{varStrInd(iv)+1};
        case {'-c', 'ccg_dir'}
            ccg_dir = varargin{varStrInd(iv)+1};
        case {'-f', 'fs'}
            hyperparamter.fs = varargin{varStrInd(iv)+1};
    end
end

%% Estimate connectivity
hyperparameter.binsize = .5; % binsize of the CCG (ms)
hyperparameter.interval = 50; % interval of the CCG (ms)
hyperparameter.tau0 = 0.8; %ms
hyperparameter.eta_w = 5;
hyperparameter.eta_tau = 20;
hyperparameter.eta_dt_coeff = 2;

cnx.location = nan(unit_info.total,3);

% Gen spike time cell array and locations
for ii = 1 : unit_info.total

    spikes{ii} = unit_info.spk_times(unit_info.spk_unit==ii);

    cnx.location(ii,3) = unit_info.channel(ii) * 10;
    switch unit_info.probe(ii)
        case 0
            cnx.location(ii,1:2) = [88000, 72000];
        case 1
            cnx.location(ii,1:2) = [10000, 68000];
        case 2
            cnx.location(ii,1:2) = [18000, 98000];
        case 3
            cnx.location(ii,1:2) = [50000, 128000];
        case 4
            cnx.location(ii,1:2) = [112000, 136000];
        case 5
            cnx.location(ii,1:2) = [120000, 114000];
    end
end

%% compute correlograms
% Want to outsource to supercomputer for this calculation
if exist('ccg_dir', 'var')
else
    [cnx.CCG, ~, cnx.distance, cnx.ignore] = generate_correlogram(spikes, hyperparameter.fs, cnx.location, hyperparameter, true);
end

%% learning phase
cnx.X = learning_basis(cnx.CCG,cnx.ignore);

%% model fitting and results
NN = size(cnx.CCG,1);
for pre = 1:NN % use parfor for parallel computing
    fprintf('neuron %i ',pre)
    cnx.model_fits(pre) = extendedGLM(cnx.CCG(pre,:), cnx.X, cnx.distance(pre,:), cnx.hyperparameter, cnx.ignore(pre,:));  
end

% apply tentative threshold
cnx.threshold = 5.09 * 2; % Multiplied by 2, seemed too accomodating
cnx.results = detect_cnx(cnx.model_fits,cnx.ignore,cnx.threshold);

%% save outputs
save([file_path file_name], 'cnx', 'hyperparameter', 'file_name', '-v7.3', '-nocompression')

end