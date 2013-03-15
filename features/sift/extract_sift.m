function [feat, x, y, wid, hgt] = extract_sift(img, c)
if(~exist('c', 'var'))
  c = conf();
end

feature = 'sift';
p = c.feature_config.(feature);

if(size(img, 3)==3)
  img = rgb2gray(img);
end

[hgt wid] = size(img);
grid_spacing = p.grid_spacing;
x = cell(length(p.patch_sizes), 1);
y = cell(length(p.patch_sizes), 1);
feat = cell(length(p.patch_sizes), 1);

for i=1:length(p.patch_sizes)
  patch_size = p.patch_sizes(i);
  [x{i}, y{i}, gridX, gridY] = create_grid(hgt, wid, grid_spacing, patch_size);
  feat{i} = sp_find_sift_grid(img, gridX, gridY, patch_size, 0.8);
  feat{i} = sp_normalize_sift(feat{i});
end

x = cell2mat(x);
y = cell2mat(y);
feat = cell2mat(feat);
