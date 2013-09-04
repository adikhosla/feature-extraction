function [c] = datasets_feature(dataset_names, train_lists, test_lists, feature, c)
if(~exist('c', 'var'))
  c = conf();
end

openPool(c.cores);

if(c.common_dictionary)
    c.feature_config.(feature).dictionary = build_dictionary(train_lists, feature, c);
end
cache_folder = c.cache;
idx = randperm(length(train_lists));

for j=1:length(train_lists)
  i = idx(j);
  fprintf('Dataset: %s\n', dataset_names{i});
  c.cache = [cache_folder '/' dataset_names{i} '/'];

  if(~c.common_dictionary)
      c.feature_config.(feature).dictionary = build_dictionary(train_lists, feature, c);
  end
  
  batch_feature(train_lists{i}, 'train', feature, c);
  batch_feature(test_lists{i}, 'test', feature, c);
end

c.cache = cache_folder;
