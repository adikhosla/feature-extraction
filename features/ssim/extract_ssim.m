function [feat, x, y, wid, hgt] = extract_ssim(img, c)
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

featname = 'ssim';
p = c.feature_config.(featname);
[feat, info] = ssim(padarray(img, [p.w p.w 0], 'symmetric'), p);
wid = size(img, 2);
hgt = size(img, 1);
x = info.x;
y = info.y;
feat = reshape(feat, [size(feat, 1)*size(feat, 2) size(feat, 3)]);
