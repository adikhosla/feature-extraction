function compile()
mex util/pixelwise_hog31.cc '-outdir' 'util/';
mex features/ssim/vggSsim/MEXfindnearestl2.cpp '-outdir' 'features/ssim/vggSsim/';
mex features/ssim/vggSsim/mexFindSimMaps.cpp '-outdir' 'features/ssim/vggSsim/';
mex features/ssim/vggSsim/MEXkmeans_faster2.cpp '-outdir' 'features/ssim/vggSsim/';
