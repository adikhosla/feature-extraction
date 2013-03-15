/***************************************************************************
Function to find the nearest points in a training set to a query set.

labels=MEXfindnearestl2(querypts,trainpts)

Inputs:
  querypts   - DxN set of N, D dimensional, points whose nearest neighbour we want to find in the training set.
  trainpts   - DxK set of K, D dimensional, points constituting the training set.

Outputs:
  labels     - 1xN set of labels representing the indices (1 based) of the points in the training set nearest the query points.
****************************************************************************/

#include <float.h>
//#include "C:\MyProg\MatlabR14\extern\include\mex.h"
//#include "/local_home/texture/softs/matlab/extern/include/mex.h"
//#include "/home/varun/linuxSofts/matlab/extern/include/mex.h"
//#include "/services/apps/matlab-R13/extern/include/mex.h"
  #include "mex.h"
//#include "/usr/local/matlabR14/extern/include/mex.h"
//#include "/local_home/varun/linuxSofts/matlab_margarita/extern/include/mex.h"
//#include "c:\matlab\extern\include\mex.h"

typedef double basetype;         // Define the input base type to be a double.
typedef unsigned int labelstype; // Define the output base type to be an unsigned int.
typedef struct {
	basetype *dataptr;  // The raw data
	unsigned int NR;    // Number of rows
	unsigned int NC;    // Number of columns
} matrix;

void usagerr(char *msg) {
	mexPrintf("%s",msg);
	mexErrMsgTxt("Usage: labels=MEXfindnearestl2(querypts,trainpts)\n");
};

inline basetype sqr(basetype x) {return(x*x);};

void computelabels(matrix querypts,matrix trainpts,labelstype *labels) {
	basetype dist,mindist,*temp;
	labelstype nearestindex,k;
	unsigned int c,r;

	for (c=0;c<querypts.NC;c++,labels++,querypts.dataptr+=querypts.NR) {
		for (mindist=DBL_MAX,temp=trainpts.dataptr,k=0;k<trainpts.NC;k++) {
			for (dist=r=0;r<querypts.NR;r++,temp++) dist+=sqr(*(querypts.dataptr+r)-*temp);
			if (dist<mindist) {
				mindist=dist;
				nearestindex=k+1; // Matlab indices are 1 based.
			};
		};
		*labels=nearestindex;
	};
}

void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]) {
	matrix querypts,trainpts;
	int outputdim[2]={1,0};
	labelstype *labels;

	if (sizeof(unsigned int)!=4) mexErrMsgTxt("Sizeof(unsigned int)!=4. Fix source [mxUINT32_CLASS].\n");
	if (nrhs!=2) usagerr("Two inputs are required.\n");
	if (nlhs!=1) usagerr("Only one output is allowed.\n");
	if (mxGetClassID(prhs[0])!=mxDOUBLE_CLASS) usagerr("Query points must be of type double.\n");
	if (mxGetClassID(prhs[1])!=mxDOUBLE_CLASS) usagerr("Training points must be of type double.\n");
	if (mxGetNumberOfDimensions(prhs[0])>2) mexErrMsgTxt("Query points must form a 2D matrix.\n");
	if (mxGetNumberOfDimensions(prhs[1])>2) mexErrMsgTxt("Training points must form  a 2D matrix.\n");
	if (mxGetM(prhs[0])!=mxGetM(prhs[1])) mexErrMsgTxt("Query, Training points dimensions do not match.\n");

	querypts.NR=mxGetM(prhs[0]);
	querypts.NC=mxGetN(prhs[0]);
	querypts.dataptr=(basetype *)mxGetData(prhs[0]);

	trainpts.NR=mxGetM(prhs[1]);
	trainpts.NC=mxGetN(prhs[1]);
	trainpts.dataptr=(basetype *)mxGetData(prhs[1]);

	outputdim[1]=querypts.NC;
	plhs[0]=mxCreateNumericArray(2,outputdim,mxUINT32_CLASS,mxREAL);
	labels=(labelstype *)mxGetData(plhs[0]);

	computelabels(querypts,trainpts,labels);
};
