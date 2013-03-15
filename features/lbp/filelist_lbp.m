function [f] = filelist_lbp(filelist)
c = conf();
featName = 'lbp';
p = eval(['config_' featName '()']);

featureFile = [c.cache 'feature_' featName '_' num2str(p.feature_size) '.mat'];

if(exist(featureFile, 'file'))
  load(featureFile);
  return;
end

f = cell(length(filelist), 1);

parfor i=1:length(filelist)
  im = imgread(filelist{i}, p);
  d = lbp_feature(im);
	f{i} = [d.hists.L0/(sum(d.hists.L0)+eps); 4* d.hists.L1/ (sum(d.hists.L1)+eps); 16* 2*d.hists.L2/ (sum(d.hists.L2)+eps)]';
end

f = cell2mat(f);
save(featureFile, 'f', '-v7.3');
