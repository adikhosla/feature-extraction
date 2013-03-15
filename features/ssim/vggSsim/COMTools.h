#if !defined( COMTOOLS )
#define COMTOOLS

// --- IMP: while using with matlab, make sure MATLAB is defined
#define MATLAB

#include <math.h>
#include <float.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#if defined( MATLAB )
  #define INDEXBASE 1
  #define COMtxtout mexPrintf
  #define COMtxterr(x) mexErrMsgTxt(x);
  #define COMmalloc mxMalloc
  #define COMfree mxFree
  //#include "/home/varun/linuxSofts/matlab/extern/include/mex.h"
  #include "mex.h"
  //#include "/usr/local/matlabR14/extern/include/mex.h"
  //#include "/services/apps/matlab-R13/extern/include/mex.h"
  //#include "/local_home/varun/linuxSofts/matlab_margarita/extern/include/mex.h"
  //#include "c:\matlab\extern\include\mex.h"
#else
  #define INDEXBASE 0
  #define COMtxtout printf
  #define COMtxterr(x) {printf(x);exit(EXIT_FAILURE);}
  #define COMmalloc malloc
  #define COMfree free
#endif

#define NORM_EPSILON 0.000001
typedef double COMbasetype;
typedef unsigned int COMindextype;
typedef COMbasetype *COMmatrix;

typedef unsigned char COMlogical; // To be consistent with Matlab
extern const COMlogical COMTrue;
extern const COMlogical COMFalse;
extern const COMindextype COMbasetypesize;
extern const COMindextype COMindextypesize;

static inline double COMfsqr(double x) {return(x*x);};
static inline COMindextype COMisqr(COMindextype x) {return(x*x);};

void COMerr(char *msg1,char *msg2="");
void COMreadfile(char *filename,void *var,size_t num,size_t size);
void COMwritefile(char *filename,void *var,size_t num,size_t size);

double COMmean(COMmatrix x,COMindextype NUMpts);
void COMmeanstd(COMmatrix x,COMindextype NUMpts,double &mu,double &std);
void COM01normalise(COMmatrix x,COMindextype NUMpts,COMmatrix normx);
void COM01circnormalise(COMmatrix x,COMindextype NUMpts,COMmatrix normx,COMlogical *mask);
void COM02circnormalise(COMmatrix x,COMindextype NUMpts,COMmatrix normx,COMlogical *mask);
COMbasetype COMdotproduct(COMmatrix x,COMmatrix y,COMindextype NUMpts);
void COMmakecircmask(COMlogical *mask,COMindextype radius);

#endif
