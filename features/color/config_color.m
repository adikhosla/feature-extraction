function [p] = config_color(c)
%
% Copyright Aditya Khosla http://mit.edu/khosla
%
% Please cite this paper if you use this code in your publication:
%   A. Khosla, J. Xiao, A. Torralba, A. Oliva
%   Memorability of Image Regions
%   Advances in Neural Information Processing Systems (NIPS) 2012
%

p.grid_spacing = 4; % distance between grid centers
p.patch_sizes = [8 12 16];

p.pyramid_levels = 2;
p.llcknn = 3;
p.maxsize = 500;

% dictionary parameters
p.dictionary_size = 256;
p.num_images = 500;
p.descPerImage = 2000;
p.num_desc = 500000;

p.train_file = '%s/train_color_%d.mat';
p.test_file = '%s/test_color_%d.mat';
p.dictionary_file = '%s/dictionary_color_%d.mat';

tmp = load('DD50_w2c.mat');
p.w2c = tmp.w2c;
p.num_colors = size(p.w2c, 2);
