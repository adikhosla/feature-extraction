function [idx] = getIdxY(imageInfo, x_idx, start_y, end_y) 
%
% Copyright Aditya Khosla http://mit.edu/khosla
%
% Please cite this paper if you use this code in your publication:
%   A. Khosla, J. Xiao, A. Torralba, A. Oliva
%   Memorability of Image Regions
%   Advances in Neural Information Processing Systems (NIPS) 2012
%

idx = imageInfo.y>=(imageInfo.hgt*start_y) & imageInfo.y< (imageInfo.hgt*end_y) & x_idx;
