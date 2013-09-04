addpath(genpath(pwd));

load images/filelists.mat;
datasets = {'demo'};
train_lists = {train_list};
test_lists = {test_list};
feature = 'color';

c = conf();
c = datasets_feature(datasets, train_lists, test_lists, feature, c);


