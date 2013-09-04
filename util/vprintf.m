function [d] = vprintf(v,c,varargin)
if(v>=c)
	d=fprintf(varargin{:});
end
