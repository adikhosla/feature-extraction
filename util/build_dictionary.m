function [dictionary] = build_dictionary(filelist, feature, c)
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
if(~isfield(p, 'dictionary_file'))
  dictionary = [];
  return;
end
p.dictionary_file = sprintf(p.dictionary_file, c.cache, p.dictionary_size);
found_dictionary = 0;
check_building = 0;

while(found_dictionary == 0)
  if(~exist(p.dictionary_file, 'file'))
    hostname = getComputerName();
		make_dir(p.dictionary_file);
    save(p.dictionary_file, 'hostname');
    
    %check for multiple datasets
    if(iscell(filelist{1}))
      trainlists = filelist;
      num_datasets = length(trainlists);
      images_per_dataset = ceil(p.num_images/num_datasets);
      filelists = cellfun(@(x) x(randperm(length(x), min(length(x), images_per_dataset))), trainlists, 'UniformOutput', false);
      filelist = {};
      for i=1:length(filelists)
				if(size(filelists{i},1)~=1), filelists{i}=filelists{i}'; end
        filelist = [filelist filelists{i}];
      end
    end
    
		vprintf(c.verbosity, 0, 'Learning dictionary for feature: %s, size %d\n', feature, p.dictionary_size);
    perm = randperm(length(filelist));
    descriptors = cell(min(length(filelist), p.num_images), 1);
    num_images = min(length(filelist), p.num_images);
    parfor i=1:num_images
      vprintf(c.verbosity, 1, 'Dictionary learning (%s): %d of %d\n', feature, i, num_images);
      img = imgread(filelist{perm(i)}, p);
      feat = extract_feature(feature, img, c);
      r = randperm(size(feat, 1));
      descriptors{i} = feat(r(1:min(length(r), p.descPerImage)), :);
    end
    descriptors = cell2mat(descriptors);
    ndata = size(descriptors, 1);
    if(ndata>p.num_desc)
      idx = randperm(ndata);
      descriptors = descriptors(idx(1:p.num_desc), :);
    end
    vprintf(c.verbosity, 0, 'Running k-means, dictionary size %d...', p.dictionary_size);
    dictionary = kmeansFast(descriptors, p.dictionary_size);
    vprintf(c.verbosity, 0, 'done!\n');
    vprintf(c.verbosity, 0, 'Saving dictionary: %s\n', p.dictionary_file);
    save(p.dictionary_file, 'dictionary');
    found_dictionary = 1;
  else
    load(p.dictionary_file);
    if(~exist('dictionary', 'var'))
      if(check_building == 0)
        vprintf(c.verbosity, 0, 'Dictionary building in progress on %s..', hostname);
        check_building = 1;
      end
      vprintf(c.verbosity, 1, '.');
      pause(5);
    else
      found_dictionary = 1;
      if(check_building == 1)
        vprintf(c.verbosity, 0, '\n');
      end
    end
  end
end
