function [I] = imgread(img, config)
I = imread(img);
scale = min(min(config.maxsize/size(I, 1), config.maxsize/size(I, 2)), 1);
if(scale~=1)
	I = imresize(I, scale);
end
