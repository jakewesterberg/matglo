function nwb = load_nwb(filename)

% Jake Westerberg
% Vanderbilt University
% jakewesterberg@gmail.com

% wrapper that call nwbRead so that I can make future changes to the load
% procedure if necessary. at the moment, this script is unnecessary...

nwb = nwbRead(filename);

end