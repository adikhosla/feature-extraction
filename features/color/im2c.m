function out=im2c(im,w2c)
% Function to convert image to color values
% Adapted from: http://cat.uab.es/~joost/code/ColorNaming.tar

im = double(im);
imR = im(:,:,1);
imG = im(:,:,2);
imB = im(:,:,3);

index_im = 1+floor(imR(:)/8)+32*floor(imG(:)/8)+32*32*floor(imB(:)/8);

[~,w2cM]=max(w2c,[],2);  
out=reshape(w2cM(index_im(:)),size(im,1),size(im,2));

