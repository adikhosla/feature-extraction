function [f] = extract_hog2x2(filelist)
c = conf();
featName = 'hog2x2';
p = eval(['config_' featName '()']);

dictionaryFile = [c.cache 'dictionary_' featName '_' num2str(p.dictionary_size) '.mat'];
featureFile = [c.cache 'feature_' featName '_' num2str(p.dictionary_size) '.mat'];

if(exist(featureFile, 'file'))
	load(featureFile);
	return;
end

if(~exist(dictionaryFile, 'file'))
	fprintf('Learning dictionary of size: %d\n', p.dictionary_size);
	perm = randperm(length(filelist));
	descriptors = cell(min(length(filelist), p.num_images), 1);
	parfor i=1:min(length(filelist), p.num_images)
      fprintf('Dictionary learning: %d of %d\n', i, min(length(filelist), p.num_images));
	  img = imgread(filelist{perm(i)}, p);
	  feat = dense_hog2x2(padarray(img, [p.w p.w 0], 'symmetric'), p);
		r = unique([randi(size(feat, 1), p.descPerImage,1) randi(size(feat, 2), p.descPerImage,1)], 'rows');
	  descriptors{i} = squeeze(cell2mat(arrayfun(@(x, y) feat(x, y, :), r(:, 1), r(:, 2), 'UniformOutput', false)));
	end
	descriptors = cell2mat(descriptors);
	ndata = size(descriptors, 1);
	if(ndata>p.num_desc)
		idx = randperm(ndata);
		descriptors = descriptors(idx(1:p.num_desc), :);
	end
	dictionary = litekmeans(descriptors', p.dictionary_size);
	dictionary = dictionary';
	make_dir(dictionaryFile);
    fprintf('Saving dictionary: %s\n', dictionaryFile);
	save(dictionaryFile, 'dictionary');
end

fprintf('Loading dictionary from file: %s\n', dictionaryFile);
load(dictionaryFile);
f = cell(length(filelist), 1);
patchSize.x = 1; patchSize.y = 1;

parfor i=1:length(filelist)
  [~, filename] = fileparts(filelist{i});
  llcFile = [c.cache 'llc_' featName '_' num2str(p.dictionary_size) '/' filename '.mat'];
	fprintf('Extract LLC: %d of %d: %s\n', i, length(filelist), llcFile);
	if(~exist(llcFile, 'file'))
    img = imgread(filelist{i}, p);
    [feat info] = dense_hog2x2(padarray(img,[p.w p.w 0], 'symmetric'), p);
		info.wid = size(img, 2);
		info.hgt = size(img, 1);
		llcfeat = sparse(LLC_coding_appr(dictionary, reshape(feat, [size(feat,1)*size(feat, 2), size(feat, 3)]), p.llcknn));
    parsaveLLC(llcFile, llcfeat, info);
	else
		tmp = load(llcFile);
        llcfeat = tmp.llcfeat;
        info = tmp.info;
	end
  f{i} = LLC_pooling({llcfeat}, {info}, 0, 0, patchSize, p.pyramid_levels);
end

f = cell2mat(f);
save(featureFile, 'f', '-v7.3');
