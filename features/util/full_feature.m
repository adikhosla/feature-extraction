function [train_feat, test_feat] = full_feature(trainlist, testlist, feature, c)
if(~exist('c', 'var'))
  c = conf();
end

openPool(c.cores);
c.feature_config.(feature).dictionary = build_dictionary(trainlist, feature, c);
train_feat = filelist_feature(trainlist, 'train', feature, c);
test_feat = filelist_feature(testlist, 'test', feature, c);
