function unit_evaluation(unit_info, varargin)

do_save = false;

varStrInd = find(cellfun(@ischar,varargin));
for iv = 1:length(varStrInd)
    switch varargin{varStrInd(iv)}
        case {'glo_spks'}
            glo_spks = varargin{varStrInd(iv)+1};
        case {'glo_info'}
            glo_info = varargin{varStrInd(iv)+1};
        case {'rf_spks'}
            rf_spks = varargin{varStrInd(iv)+1};
        case {'rf_info'}
            rf_info = varargin{varStrInd(iv)+1};
        case {'opto_spks'}
            opto_spks = varargin{varStrInd(iv)+1};
        case {'opto_info'}
            opto_info = varargin{varStrInd(iv)+1};
        case {'units'}
            units = varargin{varStrInd(iv)+1};  
        case {'save'}
            do_save = true; 
    end
end

if ~exist("units", "var"); units = 1:unit_info.total; end

if exist("glo_spks", "var")

    figure;
    subplot()

end

end