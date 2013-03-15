function img = imresizecrop(img, M, METHOD)
%
% img = imresizecrop(img, M, METHOD);
%
% Output an image of size M(1) x M(2).

if nargin < 3
    METHOD = 'bilinear';
end

if length(M) == 1
    M = [M(1) M(1)];
end

scaling = max([M(1)/size(img,1) M(2)/size(img,2)]);

%scaling = M/min([size(img,1) size(img,2)]);

newsize = round([size(img,1) size(img,2)]*scaling);
img = imresize(img, newsize, METHOD);

[nr nc cc] = size(img);

sr = floor((nr-M(1))/2);
sc = floor((nc-M(2))/2);

img = img(sr+1:sr+M(1), sc+1:sc+M(2),:);

