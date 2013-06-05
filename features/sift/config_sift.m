function [p] = config_sift(c)
p.grid_spacing = 6; % distance between grid centers
p.patch_sizes = [8 16 24];

p.pyramid_levels = 2;
p.llcknn = 3;
p.maxsize = 400;

% dictionary parameters
p.dictionary_size = 256;
p.num_images = 2000;
p.descPerImage = 3000;
p.num_desc = 2000000;

p.train_file = '%s/train_sift_%d.mat';
p.test_file = '%s/test_sift_%d.mat';
p.dictionary_file = '%s/dictionary_sift_%d.mat';
