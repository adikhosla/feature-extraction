function [c] = datasets_feature(names, trainlists, testlists, feature, c)
if(~exist('c', 'var'))
  c = conf();
end

openPool(c.cores);
c.feature_config.(feature).dictionary = build_dictionary(trainlists, feature, c);
cache_folder = c.cache;
idx = randperm(length(trainlists));

for j=1:length(trainlists)
  i = idx(j);
  fprintf('Dataset: %s\n', names{i});
  c.cache = [cache_folder '/' names{i} '/'];
  filelist_feature(trainlists{i}, 'train', feature, c);
  filelist_feature(testlists{i}, 'test', feature, c);
end

c.cache = cache_folder;
