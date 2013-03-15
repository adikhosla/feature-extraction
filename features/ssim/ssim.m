function [featMat, info]= ssim(im, param)
%% input image process
%resize input image
%input_image = rescale_max_size(input_image, 640);
%if black and white
%if(size(input_image,3) < 3)
    %black and white image
%    input_image = cat(3, input_image, input_image, input_image); %make it a trivial color image
%end



conf.coRelWindowRadius = 40 ;
conf.subsample_x       = 1 ;
conf.subsample_y       = 1 ;
conf.numRadiiIntervals = 3 ;
conf.numThetaIntervals = 10 ;
conf.saliencyThresh    = 1 ;
conf.size              = 5 ;
conf.varNoise          = 150 ;
conf.nChannels         = 3 ;
conf.useMask           = 0 ;
conf.autoVarRadius     = 1 ;

%% features
%feat = vggSsim(conf, input_image);

im = im2double(im);
if size(im, 3) > 1, im = rgb2gray(im) ; end

imagePath = sprintf('%s.jpg', tempname) ;
%[imageDir,imageName,imageExt] = fileparts(imagePath) ;
%imagePath = [imageName '.jpg'];
%[imageDir,imageName,imageExt] = fileparts(imagePath) ;

imwrite(im, imagePath) ;

[features, ftrCoords, salientCoords, uniformCoords] = getSSimFeatures(imagePath, conf) ;

delete(imagePath) ;

feat.frames = ftrCoords ;
feat.descrs = features ;


minIdx = min(feat.frames');
maxIdx = max(feat.frames');

featMat = zeros(maxIdx(2)-minIdx(2)+1,maxIdx(1)-minIdx(1)+1,30);

for i = 1:size(feat.frames,2)
    featMat(feat.frames(2,i)-minIdx(2)+1,feat.frames(1,i)-minIdx(1)+1,:) = feat.descrs(:,i);
end

grid_spacing = param.grid_spacing;
grid_x = (minIdx(1):grid_spacing:maxIdx(1));
grid_y = (minIdx(2):grid_spacing:maxIdx(2));

featMat = featMat(1:grid_spacing:end,1:grid_spacing:end,:);
[info.y info.x] = meshgrid(1:grid_spacing:size(featMat, 1), 1:grid_spacing:size(featMat, 2));
