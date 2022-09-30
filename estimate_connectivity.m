function cnx = estimate_connectivity(unit_info, varargin)

% Jake Westerberg
% Vanderbilt University
% jakewesterberg@gmail.com

% defaults

file_path = [pwd filesep];
file_name = 'default_file_name.mat';
fs = 30; % sampling rate per ms

varStrInd = find(cellfun(@ischar,varargin));
for iv = 1:length(varStrInd)
    switch varargin{varStrInd(iv)}
        case {'-p', 'file_path'}
            file_path = varargin{varStrInd(iv)+1};
        case {'-n', 'file_name'}
            file_name = varargin{varStrInd(iv)+1};
    end
end

%% Estimate connectivity
hyperparameter.binsize = .5; % binsize of the CCG (ms)
hyperparameter.interval = 50; % interval of the CCG (ms)
hyperparameter.tau0 = 0.8; %ms
hyperparameter.eta_w = 5;
hyperparameter.eta_tau = 20;
hyperparameter.eta_dt_coeff = 2;

location = nan(unit_info.total,3);

% Gen spike time cell array and locations
for ii = 1 : unit_info.total

    spikes{ii} = unit_info.spk_times(unit_info.spk_unit==ii);

    location(ii,3) = unit_info.channel(ii) * 10;
    switch unit_info.probe(ii)
        case 0
            location(ii,1:2) = [88000, 72000];
        case 1
            location(ii,1:2) = [10000, 68000];
        case 2
            location(ii,1:2) = [18000, 98000];
        case 3
            location(ii,1:2) = [50000, 128000];
        case 4
            location(ii,1:2) = [112000, 136000];
        case 5
            location(ii,1:2) = [120000, 114000];
    end
end

[CCG, t, distance, ignore] = generate_correlogram(spikes, fs, location, hyperparameter, true);
X = learning_basis(CCG,ignore);

%% model fitting and results
NN = size(CCG,1);
for pre = 1:NN % use parfor for parallel computing
    fprintf('neuron %i ',pre)
    model_fits(pre) = extendedGLM(CCG(pre,:), X, distance(pre,:),hyperparameter,ignore(pre,:));  
end

threshold = 5.09;
results = detect_cnx(model_fits,ignore,threshold);

%% plot CCG and fitting results
pre = 1;post = 14;
figure(1),
plotCCG(pre,post,CCG,t,model_fits,results)

%% ROC curve for synapse detection(regardless of the sign of connections)
true_label = data.syn.w_syn~=0;
true_label = true_label(eye(NN)~=1);
scores = results.llr_matrix(eye(NN)~=1);
scores(isnan(scores)) = -Inf;
[X,Y,T,AUC] = perfcurve(true_label,scores,1);

%% Compare overall connectivity matrices
figure,
subplot(1,3,1)
plot(X,Y,'LineWidth',2)
ylabel('True positive rate')
xlabel('False positive rate')
title('ROC for synapse detection')
axis square

subplot(1,3,2)
imagesc(sign(data.syn.w_syn))
ylabel('Presynaptic Neuron')
xlabel('Postsynaptic Neuron')
title ('true connections')
axis square
subplot(1,3,3)
imagesc(results.cnx_label)
xlabel('Postsynaptic Neuron')
title ('estimated connections')
axis square

end