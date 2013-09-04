% ========================================================================
% USAGE: [Coeff]=LLC_coding_appr(B,X,knn,lambda)
% Approximated Locality-constraint Linear Coding
%
% Inputs
%       B       -M x d codebook, M entries in a d-dim space
%       X       -N x d matrix, N data points in a d-dim space
%       knn     -number of nearest neighboring
%       lambda  -regulerization to improve condition
%
% Outputs
%       Coeff   -N x M matrix, each row is a code for corresponding X
%
% Jinjun Wang, march 19, 2010
% URL: http://www.ifp.illinois.edu/~jyang29/codes/CVPR10-LLC.rar
%
% Minor edits by Aditya Khosla
% ========================================================================

function [Coeff] = LLC_coding_appr(B, X, knn, beta)

if ~exist('knn', 'var') || isempty(knn),
    knn = 5;
end

if ~exist('beta', 'var') || isempty(beta),
    beta = 3e-2;
end

nframe=size(X,1);
nbase=size(B,1);

% find k nearest neighbors
D = sp_dist2(X, B);
[~, sort_idx] = sort(D, 2, 'ascend');
IDX = sort_idx(:, 1:knn);

% llc approximation coding
II = eye(knn, knn);
Coeff = zeros(nframe, nbase);
for i=1:nframe
   idx = IDX(i,:);
   z = bsxfun(@minus, B(idx,:), X(i,:));           % shift ith pt to origin
   C = z*z';                                        % local covariance
   C = C + II*beta*trace(C);                        % regularlization (K>D)
   w = C\ones(knn,1);
   w = w/sum(w);                                    % enforce sum(w)=1
   Coeff(i,idx) = w';
end
