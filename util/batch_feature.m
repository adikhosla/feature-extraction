function [feat] = batch_feature(filelist, imgset, feature, c)
%
% Copyright Aditya Khosla http://mit.edu/khosla
%
% Please cite this paper if you use this code in your publication:
%   A. Khosla, J. Xiao, A. Torralba, A. Oliva
%   Memorability of Image Regions
%   Advances in Neural Information Processing Systems (NIPS) 2012
%

if(~exist('c', 'var'))
  c = conf();
end

p = c.feature_config.(feature);
if(isfield(p, 'dictionary_size') && isfield(p, 'dictionary_file'))
	feature_file = sprintf(p.([imgset '_file']), c.cache, p.dictionary_size);
	batch_folder = [c.cache '/' imgset '_' feature '_' num2str(p.dictionary_size) '/'];
else
  feature_file = sprintf(p.([imgset '_file']), c.cache);
	batch_folder = [c.cache '/' imgset '_' feature '_' num2str(p.feature_size) '/'];
end

if(exist(feature_file, 'file'))
  load(feature_file);
  return;
end

num_batches = ceil(length(filelist)/c.batch_size);
batch_idx = arrayfun(@(x) (x-1)*c.batch_size+1:min(x*c.batch_size, length(filelist)), 1:num_batches, 'UniformOutput', false);
batch_order = randperm(num_batches);
batch_files = cell(num_batches, 1);

vprintf(c.verbosity, 0, 'Processing filelist (%s, %s): batch %d of %d\r', imgset, feature, 0, num_batches);
for b=1:num_batches
    this_batch = batch_idx{batch_order(b)};
    batch_file = [batch_folder num2str(batch_order(b)) '.mat'];
    batch_files{batch_order(b)} = batch_file;
    vprintf(c.verbosity, 0, 'Processing filelist (%s, %s): batch %d of %d\r', imgset, feature, b, num_batches);
    if(~exist(batch_file, 'file'))
        parsaveFeat(batch_file, [], []);
        poolfeat = filelist_feature('', filelist(this_batch), feature, c);
        parsaveFeat(batch_file, poolfeat, this_batch);
    end
end
vprintf(c.verbosity, 0, '\n');

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

if exist('OCTAVE_VERSION','builtin')
    save(feature_file, 'feat', 'batch_files', '-v7');
else
    % -v7.3 is used for storing large files
    save(feature_file, 'feat', 'batch_files', '-v7.3');
end
