function [llcfeat, x, y, wid, hgt] = llc_sift(img, c)

if(~exist('c', 'var'))
	c = conf();
end

featname = 'sift';
p = c.feature_config.(featname);
if(isfield(p, 'dictionary'))
  dictionary = p.dictionary;
elseif(isfield(p, 'dictionary_file'))
  try
    tmp = load(p.dictionary_file);
    dictionary = tmp.dictionary;
  catch
    error('No dictionary found!');
  end     
else    
  error('Must specify dictionary!');
end

[feat, x, y, wid, hgt] = extract_sift(img, c);
llcfeat = sparse(LLC_coding_appr(dictionary, feat, p.llcknn));
