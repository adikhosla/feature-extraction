function [p] = config_color(c)
p.grid_spacing = 4; % distance between grid centers
p.patch_sizes = [6 8 10 12 14 16];

p.pyramid_levels = 2;
p.llcknn = 3;
p.maxsize = 500;

% dictionary parameters
p.dictionary_size = 200;
p.num_images = 2000;
p.descPerImage = 3000;
p.num_desc = 4000000;

p.train_file = '%s/train_color_%d.mat';
p.test_file = '%s/test_color_%d.mat';
p.dictionary_file = '%s/dictionary_color_%d.mat';

tmp = load('w2c.mat');
p.w2c = tmp.w2c;
p.num_colors = size(p.w2c, 2);
