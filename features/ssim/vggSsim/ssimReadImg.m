function img=ssimReadImg(imgName,parms)
% Read an image, and converts it into appropriate
% channels depending on the parameters

img=imread(imgName);
if parms.nChannels==3
  if(size(img,3)==1)
    img(:,:,2)=img(:,:,1);img(:,:,3)=img(:,:,1);
  end;
elseif parms.nChannels==1
  if(size(img,3)==3)
    img=rgb2gray(img);
  end;
else
  error('Invalid number of image channels\n');
end

img=double(img);
