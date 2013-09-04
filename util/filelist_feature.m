function [poolfeat] = filelist_feature(dataset_name, filelist, feature, c)

if(~isempty(dataset_name) && c.common_dictionary==0)
    c.cache=[c.cache '/' dataset_name '/'];
end

p = c.feature_config.(feature);
if(~isfield(p, 'dictionary'))
    c.feature_config.(feature).dictionary = build_dictionary(filelist, feature, c);
end

if(isempty(c.feature_config.(feature).dictionary))
    % Feature does not require LLC encoding + max pooling
    poolfeat = cell(length(filelist), 1);
    parfor i=1:length(this_batch)
        img = imgread(filelist{i}, p);
        poolfeat{i} = extract_feature(feature, img, c);
    end
    poolfeat=cell2mat(poolfeat);
else
    % Feature requires LLC encoding + max pooling
    llcfeat = cell(length(filelist), 1);
    info = cell(length(filelist), 1);
    parfor i=1:length(filelist)
        img = imgread(filelist{i}, p);
        [llcfeat{i}, x, y, wid, hgt] = llc_feature(feature, img, c);
        info{i}.x = x; info{i}.y = y; info{i}.wid = wid; info{i}.hgt = hgt;
    end
    poolfeat = max_pooling(llcfeat, info, c.pool_region, p.pyramid_levels);
end