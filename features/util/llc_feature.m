function [llcfeat, x, y, wid, hgt] = llc_feature(feature, img, c)
if(~exist('c', 'var'))
	c = conf();
end

[llcfeat, x, y, wid, hgt] = feval(['llc_' feature], img, c);
