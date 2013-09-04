function [hog2x2_arr, info] = dense_hog2x2(I, HOG2x2param)
% Adapted from LabelMeToolbox
% URL: http://labelme.csail.mit.edu/Release3.0/browserTools/php/matlab_toolbox.php

grid_spacing = HOG2x2param.grid_spacing;
patch_size = HOG2x2param.patch_size;
half_win = floor(patch_size/2);

I = double(I);
d = pixelwise_hog31(I,half_win);
xmax = size(d,1); ymax = size(d,2);

grid_x = (1:grid_spacing:xmax-half_win);
grid_y = (1:grid_spacing:ymax-half_win);

hog2x2_arr = zeros([length(grid_x),length(grid_y),124]);

hog2x2_arr(:,:, 1: 31) = d(grid_x         ,grid_y         ,:);
hog2x2_arr(:,:,32: 62) = d(grid_x+half_win,grid_y         ,:);
hog2x2_arr(:,:,63: 93) = d(grid_x         ,grid_y+half_win,:);
hog2x2_arr(:,:,94:124) = d(grid_x+half_win,grid_y+half_win,:);

[x y] = meshgrid(grid_x, grid_y);
info.y = x(:);
info.x = y(:);
