function [c] = conf(cache_folder)
if(~exist('cache_folder', 'var'))
  c.cache = 'cache/';
else
  c.cache = [cache_folder '/'];
end
make_dir(c.cache);

c.batch_size = 500;

c.cores = 0;
c.feature_list = {'color', 'gist', 'hog2x2', 'hog3x3', 'lbp', 'sift', 'ssim'};

for i=1:length(c.feature_list)
	feat = c.feature_list{i};
	c.feature_config.(feat) = [];
	if(exist(['config_' feat]))
        c.feature_config.(feat) = feval(['config_' feat], c);
	end
end

c.pool_region.x1 = 0; c.pool_region.x2 = 1;
c.pool_region.y1 = 0; c.pool_region.y2 = 1;
c.common_dictionary = 0;

stream = RandStream('mt19937ar','Seed', sum(100*clock));
RandStream.setGlobalStream(stream);
