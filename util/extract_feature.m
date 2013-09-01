function [feat, x, y, wid, hgt] = extract_feature(feature, img, c)
if(~exist('c', 'var'))
  c = conf();
end

[feat, x, y, wid, hgt] = feval(['extract_' feature], img, c);
