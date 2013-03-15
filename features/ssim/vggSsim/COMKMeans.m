function [initmeans,finalmeans,dists,inds,iter]=COMKMeans(train,valid,K,NUMiter,NUMruns) 
% Wrapper function which runs KMeans many times and returns the best results.
%
% [initmeans,finalmeans,dists,inds,iter]=COMKMeans(train,valid,K,NUMiter,NUMruns)
%
% Inputs:
%   train      - NUMdims x NUMtrainpts matrix of training data points.
%   valid      - NUMdims x NUMvalidpts matrix of validation data
%                points. If a validatino set is not available then set
%                valid=[] and the best result on the training set will be
%                returned.
%   K          - Number of clusters.
%   NUMiter    - Maximum number of iterations allowed on a single run.
%   NUMruns    - Number of runs out of which best results will be returned.
%
% Outputs:
%   initmeans  - NUMdims x K vector of initial means.
%   finalmeans - NUMdims x K vector of best final means.
%   dists      - 1xN vector of the distance of each point from its
%                closest cluster centre.
%   inds       - 1xN vector of indices (1 <= inds_{i} <= K)
%                specifying the index of the closest cluster centre.
%   iter       - The number of iterations performed.              

  validists=+Inf;
  rand('state',100);
  %rand('state',sum(100*clock));
  [NUMdims,NUMpts]=size(train);
  for i=1:NUMruns,
    if (rand<0.5), % Randomly, either choose initmeans or initlabels
      initmeansi=train(:,COMuniquerand(K,[1,NUMpts]));
    else
      collapsed=1;
      while (collapsed==1),
	[initmeansi,collapsed]=maxparms(train,round(1+rand(1,NUMpts)*(K-1)),K);
      end;
    end;
    [finalmeansi,distsi,indsi,iteri]=MEXkmeans_faster2(train,initmeansi,NUMiter);
    if (isempty(valid)), 
      validistsi=sum(distsi.^2);
    else
      [x,validistsi,x,x]=MEXkmeans_faster2(valid,finalmeansi,0);
      validistsi=sum(validistsi.^2);
    end;
    if (validistsi<validists),
      initmeans=initmeansi;
      finalmeans=finalmeansi;
      dists=distsi;
      inds=indsi;
      iter=iteri;
      validists=validistsi;
    end;
  end;
end

function [means,BOOLcollapsed]=maxparms(datapts,labels,K)
  means=zeros(size(datapts,1),K);
  BOOLcollapsed=any(histc(labels,[1:K])==0);
  if (~BOOLcollapsed),
    for m=1:K, means(:,m)=mean(datapts(:,find(labels==m))')'; end;
  end;
end
