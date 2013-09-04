function [idx] = getIdxX(imageInfo, start_x, end_x)
%
% Copyright Aditya Khosla http://mit.edu/khosla
%
% Please cite this paper if you use this code in your publication:
%   A. Khosla, J. Xiao, A. Torralba, A. Oliva
%   Memorability of Image Regions
%   Advances in Neural Information Processing Systems (NIPS) 2012
%

idx = imageInfo.x>=imageInfo.wid*start_x & imageInfo.x<imageInfo.wid*end_x;
