function [p] = config_hog3x3(c)
%
% Copyright Aditya Khosla http://mit.edu/khosla
%
% Please cite this paper if you use this code in your publication:
%   A. Khosla, J. Xiao, A. Torralba, A. Oliva
%   Memorability of Image Regions
%   Advances in Neural Information Processing Systems (NIPS) 2012
%

p.grid_spacing = 6; % distance between grid centers
p.patch_size = 24;
p.Mw = 2; % number of spatial scales for spatial pyramid histogram
p.descriptor = 'hog';
p.w = p.patch_size; % boundary for HOG

p.pyramid_levels = 2;
p.llcknn = 3;
p.maxsize = 400;

% dictionary parameters
p.dictionary_size = 256;
p.num_images = 500;
p.descPerImage = 2000;
p.num_desc = 500000;

p.train_file = '%s/train_hog3x3_%d.mat';
p.test_file = '%s/test_hog3x3_%d.mat';
p.dictionary_file = '%s/dictionary_hog3x3_%d.mat';
