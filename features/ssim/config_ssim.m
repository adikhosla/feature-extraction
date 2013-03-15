function [p] = config_hog3x3(c)
p.grid_spacing = 1; % distance between grid centers
p.Mw = 2; % number of spatial scales for spatial pyramid histogram
p.descriptor = 'ssim';
p.w = 42;

p.pyramid_levels = 2;
p.llcknn = 3;
p.maxsize = 500;

% dictionary parameters
p.dictionary_size = 25;
p.num_images = 2000;
p.descPerImage = 3000;
p.num_desc = 4000000;

p.train_file = '%s/train_ssim_%d.mat';
p.test_file = '%s/test_ssim_%d.mat';
p.dictionary_file = '%s/dictionary_ssim_%d.mat';

