function [feat, x, y, wid, hgt] = extract_lbp(img, c)
%
% Copyright Aditya Khosla http://mit.edu/khosla
%
% Please cite this paper if you use this code in your publication:
%   A. Khosla, J. Xiao, A. Torralba, A. Oliva
%   Memorability of Image Regions
%   Advances in Neural Information Processing Systems (NIPS) 2012
%

if(~exist('c', 'var'))
  c = conf();
end

feature = 'lbp';
p = c.feature_config.(feature);
d = lbp_feature(img);
feat = [d.hists.L0/(sum(d.hists.L0)+eps); 4* d.hists.L1/ (sum(d.hists.L1)+eps); 16* 2*d.hists.L2/ (sum(d.hists.L2)+eps)]';
x = []; y=[]; wid=[]; hgt=[];
