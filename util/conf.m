function [c] = conf(cache_folder)
%
% Copyright Aditya Khosla http://mit.edu/khosla
%
% Please cite this paper if you use this code in your publication:
%   A. Khosla, J. Xiao, A. Torralba, A. Oliva
%   Memorability of Image Regions
%   Advances in Neural Information Processing Systems (NIPS) 2012
%

% cache folder is where features, dictionary, etc are stored
if(~exist('cache_folder', 'var'))
  c.cache = 'cache/';
else
  c.cache = [cache_folder '/'];
end
make_dir(c.cache);

% Batch size for feature processing (reduce for less RAM usage)
c.batch_size = 500;

% Enable/disable parallelization 
%  0 - max cores possible, else use number specified
c.cores = 0;

% Load configurations for all the features
c.feature_list = {'color', 'gist', 'hog2x2', 'hog3x3', 'lbp', 'sift', 'ssim'};

for i=1:length(c.feature_list)
	feat = c.feature_list{i};
	c.feature_config.(feat) = [];
	if(exist(['config_' feat]))
        c.feature_config.(feat) = feval(['config_' feat], c);
	end
end

% Region of image to perform pooling over (full image by default)
c.pool_region.x1 = 0; c.pool_region.x2 = 1;
c.pool_region.y1 = 0; c.pool_region.y2 = 1;

% Use a common dictionary for all datasets (not true by default)
c.common_dictionary = 0;

% Verbosity of process: -1 is none, 0 is low, 1 is high (low by default)
c.verbosity = 0;

% Storage type: single or double precision (single by default)
c.precision = 'single';

% Reset the random seed
seed = sum(1000*clock);

if exist('OCTAVE_VERSION','builtin')
    rand('state',seed);  % Octave
    randn('state',seed); % Octave
else
    try
        RandStream.setGlobalStream(RandStream('mt19937ar','seed',seed)); % matlab 7.9+
    catch
        rand('state',seed);  % Matlab 5+
        randn('state',seed); % Matlab 5+
    end
end
