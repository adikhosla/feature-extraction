function [p] = config_lbp(c)
%
% Copyright Aditya Khosla http://mit.edu/khosla
%
% Please cite this paper if you use this code in your publication:
%   A. Khosla, J. Xiao, A. Torralba, A. Oliva
%   Memorability of Image Regions
%   Advances in Neural Information Processing Systems (NIPS) 2012
%

p.feature_size = 59*(1+4+16);
p.maxsize = 500;
p.train_file = ['%s/train_lbp_' num2str(p.feature_size) '.mat'];
p.test_file = ['%s/test_lbp_' num2str(p.feature_size) '.mat'];
