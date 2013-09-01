curr_folder=pwd;

cd util;
mex pixelwise_hog31.cc;

cd(curr_folder);

cd features/ssim/vggSsim;
mex MEXfindnearestl2.cpp;
mex  mexFindSimMaps.cpp;
mex MEXkmeans_faster2.cpp;

cd(curr_folder);
