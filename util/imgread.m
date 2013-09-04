function [I] = imgread(img, c)

if(ischar(img))
    I = imread(img);
else
    I=img;
end


scale = min(min(c.maxsize/size(I, 1), c.maxsize/size(I, 2)), 1);
if(scale~=1)
	I = imresize(I, scale);
end
