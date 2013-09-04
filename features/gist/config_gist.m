function [p] = config_gist(c)
%
% Copyright Aditya Khosla http://mit.edu/khosla
%
% Please cite this paper if you use this code in your publication:
%   A. Khosla, J. Xiao, A. Torralba, A. Oliva
%   Memorability of Image Regions
%   Advances in Neural Information Processing Systems (NIPS) 2012
%

p.maxsize = 500;
p.imageSize = [256 256];
p.orientationsPerScale = [8 8 8 8];
p.numberBlocks = 4;
p.fc_prefilt = 4;
p.feature_size = 512;

p.train_file = ['%s/train_gist_' num2str(p.feature_size) '.mat'];
p.test_file = ['%s/test_gist_' num2str(p.feature_size) '.mat'];
