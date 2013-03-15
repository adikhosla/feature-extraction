function [feat boxes] = lbp_feature(im)

if(size(im,3) < 3)
    %black and white image
    im = cat(3, im, im, im); %make it a trivial color image
end
boxes = [1;1;size(im,1);size(im,2)];


[lbp_L0 lbp_L1 lbp_L2] = lbp_original_4x4(im);

feat.hists.L0 = lbp_L0;
feat.hists.L1 = lbp_L1;
feat.hists.L2 = lbp_L2;

