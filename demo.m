%
% Copyright Aditya Khosla http://mit.edu/khosla
%
% Please cite this paper if you use this code in your publication:
%   A. Khosla, J. Xiao, A. Torralba, A. Oliva
%   Memorability of Image Regions
%   Advances in Neural Information Processing Systems (NIPS) 2012
%

addpath(genpath(pwd));

load images/filelists.mat;
datasets = {'demo'};
train_lists = {train_list};
test_lists = {test_list};
feature = 'color';

c = conf();
c = datasets_feature(datasets, train_lists, test_lists, feature, c);


