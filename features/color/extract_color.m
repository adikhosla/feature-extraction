function [feat, x, y, wid, hgt] = extract_color(img, c)
%
% Copyright Aditya Khosla http://mit.edu/khosla
%
% Please cite this paper if you use this code in your publication:
%   A. Khosla, J. Xiao, A. Torralba, A. Oliva
%   Memorability of Image Regions
%   Advances in Neural Information Processing Systems (NIPS) 2012
%

if(~exist('c', 'var'))
  c = conf();
end

featname = 'color';
p = c.feature_config.(featname);

if(size(img, 3)==1)
  img = repmat(img, [1 1 3]);
end

img_color = im2c(img, p.w2c);

[hgt, wid, ~] = size(img);
grid_spacing = p.grid_spacing;
x = cell(length(p.patch_sizes), 1);
y = cell(length(p.patch_sizes), 1);
feat = cell(length(p.patch_sizes), 1);


for i=1:length(p.patch_sizes)
  patch_size = p.patch_sizes(i);
  numPixelsPerPatch = patch_size.^2;
  [x{i}, y{i}, gridX, gridY] = create_grid(hgt, wid, grid_spacing, patch_size);
  feat{i} = cell2mat(arrayfun(@(x, y) histc(reshape(img_color(y:y+patch_size-1, x:x+patch_size-1), [numPixelsPerPatch 1]), 1:p.num_colors), gridX(:), gridY(:), 'UniformOutput', false)')'./numPixelsPerPatch;
end

x = cell2mat(x);
y = cell2mat(y);
feat = cell2mat(feat);
