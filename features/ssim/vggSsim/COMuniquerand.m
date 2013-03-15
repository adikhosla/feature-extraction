function [r,err]=COMuniquerand(N,BOUNDS)
% Function which returns a randomly generated, sorted list on N unique
% integers lying in the closed interval specified by BOUNDS.
%
% [r,err]=COMuniquerand(N,BOUNDS)
%
% Inputs:
%   N      - The number of random points required.
%   BOUNDS - The range in which they must lie.
% Outputs:
%   r      - The sorted list of N, unique random numbers.
%   err    - err=0 if no errors occured. Otherwise set to 1.

  D=diff(BOUNDS);
  r=[];err=0;
  if (N<1) | (N>(D+1)),
    fprintf('Invalid value of N=%d.\n',N);err=1;
  elseif (D<0),
    fprintf('Lower Bounds must be < Upper Bound\n');err=1;
  else
    nunique=0;
    uniqueinds=logical(zeros(1,D+1));
    while (nunique<N),
      uniqueinds(round(1+D*rand(1,N-nunique)))=1;
      nunique=sum(uniqueinds);
    end;
    tmp=[BOUNDS(1):BOUNDS(2)];
    r=tmp(uniqueinds);
  end;
end

function [r,err]=COMuniquerandold(N,BOUNDS)
% Function which returns a randomly generated, sorted list on N unique
% integers lying in the closed interval specified by BOUNDS.
%
% [r,err]=COMuniquerand(N,BOUNDS)
%
% Inputs:
%   N      - The number of random points required.
%   BOUNDS - The range in which they must lie.
% Outputs:
%   r      - The sorted list of N, unique random numbers.
%   err    - err=0 if no errors occured. Otherwise set to 1.

  D=diff(BOUNDS);
  r=[];err=0;
  if (N<1) | (N>(D+1)),
    fprintf('Invalid value of N=%d.\n',N);err=1;
  elseif (D<0),
    fprintf('Lower Bounds must be < Upper Bound\n');err=1;
  else
    while (length(r)~=N), 
      r=unique([r round(BOUNDS(1)+rand(1,N-length(r))*D)]);
    end;
  end;
end
