function compile()
%
% Copyright Aditya Khosla http://mit.edu/khosla
%
% Please cite this paper if you use this code in your publication:
%   A. Khosla, J. Xiao, A. Torralba, A. Oliva
%   Memorability of Image Regions
%   Advances in Neural Information Processing Systems (NIPS) 2012
%

mex util/pixelwise_hog31.cc '-outdir' 'util/';
mex features/ssim/vggSsim/MEXfindnearestl2.cpp '-outdir' 'features/ssim/vggSsim/';
mex features/ssim/vggSsim/mexFindSimMaps.cpp '-outdir' 'features/ssim/vggSsim/';
mex features/ssim/vggSsim/MEXkmeans_faster2.cpp '-outdir' 'features/ssim/vggSsim/';
