function [p] = config_sift(c)
p.grid_spacing = 6; % distance between grid centers
p.patch_sizes = [8 16 24];

p.pyramid_levels = 2;
p.llcknn = 3;
p.maxsize = 400;

% dictionary parameters
p.dictionary_size = 256;
p.num_images = 500;
p.descPerImage = 2000;
p.num_desc = 500000;

p.train_file = '%s/train_sift_%d.mat';
p.test_file = '%s/test_sift_%d.mat';
p.dictionary_file = '%s/dictionary_sift_%d.mat';
