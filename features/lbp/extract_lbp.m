function [feat, x, y, wid, hgt] = extract_lbp(img, c)
if(~exist('c', 'var'))
  c = conf();
end

feature = 'lbp';
p = c.feature_config.(feature);
d = lbp_feature(img);
feat = [d.hists.L0/(sum(d.hists.L0)+eps); 4* d.hists.L1/ (sum(d.hists.L1)+eps); 16* 2*d.hists.L2/ (sum(d.hists.L2)+eps)]';
x = []; y=[]; wid=[]; hgt=[];
