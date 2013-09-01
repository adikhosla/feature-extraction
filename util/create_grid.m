function [x, y, gridX, gridY] = create_grid(hgt, wid, grid_spacing, patch_size)
remX = mod(wid-patch_size,grid_spacing);
offsetX = floor(remX/2)+1;
remY = mod(hgt-patch_size,grid_spacing);
offsetY = floor(remY/2)+1;

[gridX,gridY] = meshgrid(offsetX:grid_spacing:wid-patch_size+1, offsetY:grid_spacing:hgt-patch_size+1);

x = gridX(:)+patch_size/2-0.5;
y = gridY(:)+patch_size/2-0.5;
