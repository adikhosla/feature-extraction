function [I] = imgread(img, c)
%
% Copyright Aditya Khosla http://mit.edu/khosla
%
% Please cite this paper if you use this code in your publication:
%   A. Khosla, J. Xiao, A. Torralba, A. Oliva
%   Memorability of Image Regions
%   Advances in Neural Information Processing Systems (NIPS) 2012
%

if(ischar(img))
    I = imread(img);
else
    I=img;
end

scale = min(min(c.maxsize/size(I, 1), c.maxsize/size(I, 2)), 1);
if(scale~=1)
	I = imresize(I, scale);
end

if(size(I,3)==1)
	I=cat(3, I, I, I);
end
