function [llcfeat, x, y, wid, hgt] = llc_color(img, c)
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

featname = 'color';
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

[feat, x, y, wid, hgt] = extract_color(img, c);
llcfeat = sparse(LLC_coding_appr(dictionary, feat, p.llcknn));
