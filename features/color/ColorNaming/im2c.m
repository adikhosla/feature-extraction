function out=im2c(im,w2c,color)
% input im should be DOUBLE !
% color=0 is color names out
% color=-1 is colored image with color names out
% color=1-11 is prob of colorname=color out;

% order of color names: black ,   blue   , brown       , grey       , green   , orange   , pink     , purple  , red     , white    , yellow
color_values =     {  [0 0 0] , [0 0 1] , [.5 .4 .25] , [.5 .5 .5] , [0 1 0] , [1 .8 0] , [1 .5 1] , [1 0 1] , [1 0 0] , [1 1 1 ] , [ 1 1 0 ] };

if(nargin<3)
   color=0;
end

RR=im(:,:,1);GG=im(:,:,2);BB=im(:,:,3);

index_im = 1+floor(RR(:)/8)+32*floor(GG(:)/8)+32*32*floor(BB(:)/8);

if(color==0)
   [max1,w2cM]=max(w2c,[],2);  
   out=reshape(w2cM(index_im(:)),size(im,1),size(im,2));
end

if(color>0 && color < 12)
   w2cM=w2c(:,color);
   out=reshape(w2cM(index_im(:)),size(im,1),size(im,2));
end

if(color==-1)
   out=im;
   [max1,w2cM]=max(w2c,[],2);  
   out2=reshape(w2cM(index_im(:)),size(im,1),size(im,2));
         
   for jj=1:size(im,1)
        for ii=1:size(im,2) 
          out(jj,ii,:)=color_values{out2(jj,ii)}'*255;
        end
   end
end