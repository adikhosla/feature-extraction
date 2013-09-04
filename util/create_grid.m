function [x, y, gridX, gridY] = create_grid(hgt, wid, grid_spacing, patch_size)
%
% Copyright Aditya Khosla http://mit.edu/khosla
%
% Please cite this paper if you use this code in your publication:
%   A. Khosla, J. Xiao, A. Torralba, A. Oliva
%   Memorability of Image Regions
%   Advances in Neural Information Processing Systems (NIPS) 2012
%

remX = mod(wid-patch_size,grid_spacing);
offsetX = floor(remX/2)+1;
remY = mod(hgt-patch_size,grid_spacing);
offsetY = floor(remY/2)+1;

[gridX,gridY] = meshgrid(offsetX:grid_spacing:wid-patch_size+1, offsetY:grid_spacing:hgt-patch_size+1);

x = gridX(:)+patch_size/2-0.5;
y = gridY(:)+patch_size/2-0.5;
