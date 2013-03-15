function [hog2x2_arr, info] = dense_hog3x3(I, HOG2x2param)

grid_spacing = HOG2x2param.grid_spacing;
patch_size = HOG2x2param.patch_size;
cell_win = floor(patch_size/3);

I = double(I);
if(size(I,3) < 3)
    I = cat(3, I, I, I); %make it a trivial color image
end

d = pixelwise_hog31(I,cell_win);
xmax = size(d,1); ymax = size(d,2);

grid_x = (1:grid_spacing:xmax-cell_win*2);
grid_y = (1:grid_spacing:ymax-cell_win*2);

hog2x2_arr = zeros([length(grid_x),length(grid_y),124]);

hog2x2_arr(:,:,  1: 31) = d(grid_x           ,grid_y           ,:);
hog2x2_arr(:,:, 32: 62) = d(grid_x+cell_win  ,grid_y           ,:);
hog2x2_arr(:,:, 63: 93) = d(grid_x+cell_win*2,grid_y           ,:);
hog2x2_arr(:,:, 94:124) = d(grid_x           ,grid_y+cell_win  ,:);
hog2x2_arr(:,:,125:155) = d(grid_x+cell_win  ,grid_y+cell_win  ,:);
hog2x2_arr(:,:,156:186) = d(grid_x+cell_win*2,grid_y+cell_win  ,:);
hog2x2_arr(:,:,187:217) = d(grid_x           ,grid_y+cell_win*2,:);
hog2x2_arr(:,:,218:248) = d(grid_x+cell_win  ,grid_y+cell_win*2,:);
hog2x2_arr(:,:,249:279) = d(grid_x+cell_win*2,grid_y+cell_win*2,:);

%grid_x = floor(cell_win * 2.5) + grid_x; 
%grid_y = floor(cell_win * 2.5) + grid_y;
[x y] = meshgrid(grid_x, grid_y);
info.y = x(:);
info.x = y(:);
