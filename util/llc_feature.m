function [llcfeat, x, y, wid, hgt] = llc_feature(feature, img, c)
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

[llcfeat, x, y, wid, hgt] = feval(['llc_' feature], img, c);
