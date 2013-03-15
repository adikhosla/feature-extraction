function [feat] = filelist_feature(filelist, imgset, feature, c)
if(~exist('c', 'var'))
  c = conf();
end

p = c.feature_config.(feature);
if(isfield(p, 'dictionary_size'))
	feature_file = sprintf(p.([imgset '_file']), c.cache, p.dictionary_size);
else
    feature_file = sprintf(p.([imgset '_file']), c.cache);
end

if(exist(feature_file, 'file'))
  load(feature_file);
  return;
end

patch_size.x = 1; patch_size.y = 1;
num_batches = ceil(length(filelist)/c.batch_size);
batch_idx = arrayfun(@(x) (x-1)*c.batch_size+1:min(x*c.batch_size, length(filelist)), 1:num_batches, 'UniformOutput', false);
batch_order = randperm(num_batches);
batch_files = cell(num_batches, 1);

if(isfield(p, 'dictionary_file'))
  for b=1:num_batches
    this_batch = batch_idx{batch_order(b)};
    batch_file = [c.cache imgset '_' feature '_' num2str(p.dictionary_size) '/' num2str(batch_order(b)) '.mat'];
    batch_files{batch_order(b)} = batch_file;
    fprintf('Processing filelist (%s, %s): batch %d of %d\n', imgset, feature, b, num_batches);
    if(~exist(batch_file, 'file'))
      parsaveLLC(batch_file, [], []);
      llcfeat = cell(length(this_batch), 1);
      info = cell(length(this_batch), 1);
      parfor j=1:length(this_batch)
        i = this_batch(j);
        img = imgread(filelist{i}, p);
        [llcfeat{j}, x, y, wid, hgt] = llc_feature(feature, img, c);
        info{j}.x = x; info{j}.y = y; info{j}.wid = wid; info{j}.hgt = hgt;
      end
      poolfeat = LLC_pooling(llcfeat, info, 0, 0, patch_size, p.pyramid_levels);
      parsaveLLC(batch_file, poolfeat, filelist(this_batch));
    end
  end
else
  for b = 1:num_batches
    this_batch = batch_idx{batch_order(b)};
    batch_file = [c.cache imgset '_' feature '_' num2str(p.feature_size) '/' num2str(batch_order(b)) '.mat'];
    batch_files{batch_order(b)} = batch_file;
    fprintf('Processing filelist (%s, %s): batch %d of %d\n', imgset, feature, b, num_batches);
    if(~exist(batch_file, 'file'))
      parsaveLLC(batch_file, [], []);
      poolfeat = cell(length(this_batch), 1);
      parfor i=1:length(this_batch)
        img = imgread(filelist{this_batch(i)}, p);
        poolfeat{i} = extract_feature(feature, img, c);
      end
      parsaveLLC(batch_file, poolfeat, filelist(this_batch));
    end
  end
end

if(nargout>0)
    feat = cell(num_batches, 1);
    for i=1:num_batches
        tmp = load(batch_files{i});
        feat{i} = tmp.poolfeat;
    end
    feat = cell2mat(feat);
else
    feat = {};
end

save(feature_file, 'feat', 'batch_files', '-v7.3');