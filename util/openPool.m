function [] = openPool(s)
  if(matlabpool('size')==0)
		if(s==0)
 			matlabpool;
		elseif(s>1)
			matlabpool(s);
		end
	end
