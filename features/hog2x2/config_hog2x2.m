function [p] = config_hog2x2(c)
p.grid_spacing = 6; % distance between grid centers
p.patch_size = 16;
p.Mw = 2; % number of spatial scales for spatial pyramid histogram
p.descriptor = 'hog';
p.w = 20; %p.patch_size; % boundary for HOG

p.pyramid_levels = 2;
p.llcknn = 3;
p.maxsize = 400;

% dictionary parameters
p.dictionary_size = 256;
p.num_images = 2000;
p.descPerImage = 3000;
p.num_desc = 2000000;

p.train_file = '%s/train_hog2x2_%d.mat';
p.test_file = '%s/test_hog2x2_%d.mat';
p.dictionary_file = '%s/dictionary_hog2x2_%d.mat';
