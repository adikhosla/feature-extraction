function [feat, x, y, wid, hgt] = extract_gist(img, c)
if(~exist('c', 'var'))
  c = conf();
end

feature = 'gist';
p = c.feature_config.(feature);
feat = LMgist(img, [], p);
x = []; y=[]; wid=[]; hgt=[];
