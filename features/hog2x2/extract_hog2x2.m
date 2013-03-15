function [feat, x, y, wid, hgt] = extract_hog2x2(img, c)

if(~exist('c', 'var'))
	c = conf();
end

featname = 'hog2x2';
p = c.feature_config.(featname);
[feat, info] = dense_hog2x2(padarray(img, [p.w p.w 0], 'symmetric'), p);
wid = size(img, 2);
hgt = size(img, 1);
x = info.x;
y = info.y;
feat = reshape(feat, [size(feat, 1)*size(feat, 2) size(feat, 3)]);
