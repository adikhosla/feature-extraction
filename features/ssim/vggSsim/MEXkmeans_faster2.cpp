#include <math.h>
#include <float.h>
#include <memory.h>
//#include "C:\MyProg\MatlabR14\extern\include\mex.h"
//#include "/home/varun/linuxSofts/matlab/extern/include/mex.h"
#include "mex.h"

typedef double btype;   //Define the base type to be a double.
typedef btype *matrix;  //Needs contiguous RAM chunk but will be faster.

inline btype sqr(btype x) {return(x*x);};

inline void copyvector(matrix target,matrix source,unsigned int D) {
	for (unsigned int i=0;i<D;i++) target[i]=source[i]; // Should be faster than memcpy as multiword.
};

inline int notequalvectors(matrix vec1,matrix vec2,unsigned int D) {
	unsigned int i;

	for (i=0;(i<D) && (vec1[i]==vec2[i]);i++);
	return(i!=D); // return(memcmp((void *)vec1,(void *)vec2,sizeof(btype)*D)); // This should be slower as extra jmps.
};

void err(char *msg1,char *msg2="") {
	mexPrintf("%s%s\n",msg1,msg2);
	mexErrMsgTxt("Exiting MATLAB");
};

void usagerr(char *msg) {
	mexPrintf("%s",msg);
	mexErrMsgTxt("Usage: [means,dists,inds,niter]=MEXkmeans(datapoints,initmeans,maxiter);\n");
};

void showpoints(matrix points,unsigned int N,unsigned int D) {
	for (unsigned int i=0;i<N;i++) {
		for (unsigned int j=0;j<D;j++,points++) mexPrintf("%f ",*points);
		mexPrintf("\n");
	};
};

void initvars(matrix &newmeans,unsigned int *&count,matrix initmeans,matrix &dc,
              bool *&rx,btype *&sc,btype *ux,btype *&dcmc,unsigned int *cx,matrix pts,
              unsigned int K,unsigned int N,unsigned int D){

  unsigned int i,j;
  matrix temp;
  btype tmpdist;
	
	newmeans=(matrix)mxMalloc(sizeof(btype)*K*D);
	count=(unsigned int *)mxMalloc(sizeof(unsigned int)*K);
  dc=(matrix)mxMalloc(sizeof(btype)*K*K);
  rx=(bool*)mxMalloc(sizeof(bool)*N);
  sc=(btype*)mxMalloc(sizeof(btype)*K);
  dcmc=(btype*)mxMalloc(2*sizeof(btype)*K);
	if ((newmeans==NULL) || (count==NULL) || dc==NULL || rx==NULL || dcmc==NULL || sc==NULL)
    err("Out of memory.");
	copyvector(newmeans,initmeans,D*K); // A one off so that we can have a general do loop in kmeans.

  for(i=0;i<N;i++){
    rx[i]=false;
    temp=newmeans+D*cx[i];
    for(tmpdist=0,j=0;j<D;j++,pts++,temp++) tmpdist+=sqr(*pts-*temp);
    ux[i]=tmpdist;
  }
  
};

void reset(matrix &means,matrix &newmeans,unsigned int count[],matrix dc,btype *sc,unsigned int K,unsigned int N,unsigned int D) {
	unsigned int i,j,k;
  unsigned int* tempinds;
  matrix temp,remc,curc;
  btype *col_ptr,*row_ptr;
  btype dist,mindist;
  
  temp=means;means=newmeans;newmeans=temp;
	for (i=0;i<K*D;i++) newmeans[i]=0;			// Should be faster than memset
	for (i=0;i<K;i++) count[i]=0;				// Again faster than memeset

  for(i=0,curc=means,col_ptr=dc;i<K;i++,curc+=D){
    col_ptr+=i;
    row_ptr=col_ptr+K;
    *col_ptr=0;col_ptr++;
    for(j=i+1,remc=curc+D;j<K;j++,col_ptr++,row_ptr+=K){
      for(k=0,dist=0,temp=curc;k<D;k++,remc++,temp++) dist+=sqr(*temp-*remc);
      *col_ptr=dist;*row_ptr=dist;
    }
  }

  for(i=0,temp=dc;i<K;i++){
    for(j=0,mindist=DBL_MAX;j<K;j++,temp++) if(j!=i) {if(*temp < mindist) mindist=*temp;}
    sc[i]=0.25*mindist;
  }
  
};

inline bool assign(matrix pt,matrix means,unsigned int K,unsigned int D, 
					         unsigned int count[],unsigned int &cx,btype &ux,bool &rx,matrix dc){ 

	btype dist;
	unsigned int i,j;
	matrix temp;
  btype *tmp_pt,*tmp_mean;
  bool changed=false;

	for (i=0;i<K;i++) {
    if(4*ux>*(dc+i*K+cx) && i!=cx){
      if(rx){
        for(j=0,dist=0,tmp_pt=pt,tmp_mean=means+D*cx;j<D;j++,tmp_pt++,tmp_mean++) dist+=sqr(*tmp_mean-*tmp_pt);
        ux=dist;rx=false;
        if(4*ux>*(dc+i*K+cx)){
          for(j=0,dist=0,tmp_pt=pt,tmp_mean=means+D*i;j<D;j++,tmp_pt++,tmp_mean++) dist+=sqr(*tmp_mean-*tmp_pt);
          if(dist < ux) {cx=i;ux=dist;changed=true;}
        }
      }
      else{
        for(j=0,dist=0,tmp_pt=pt,tmp_mean=means+D*i;j<D;j++,tmp_pt++,tmp_mean++) dist+=sqr(*tmp_mean-*tmp_pt);
        if(dist < ux) {cx=i;ux=dist;changed=true;}
      }
    }
	};
  return changed;

};

unsigned int update_u(matrix means,matrix newmeans,unsigned int count[],btype *ux,btype *dcmc,
                       unsigned int *cx,bool *rx,unsigned int K,unsigned int D,matrix points,unsigned int N) {
	unsigned int i,j,loop=0;
	matrix pt,tmp_newmeans,tmp_means;
  btype dist,tmp;

	for (i=0,tmp_newmeans=newmeans;i<K;i++) {
		if (count[i]) {
			for (j=0;j<D;j++,tmp_newmeans++) *tmp_newmeans/=count[i];
		} else {
			mexPrintf("No vectors assigned to centre %d. Choosing one randomly.\n",i);
			pt=points+D*(rand()%N);
			for (j=0;j<D;j++,tmp_newmeans++,pt++) *tmp_newmeans=*pt; // Could do a copyvector over here but updating means also.
			loop=1;
		};
	};

  // --- update the bounds --
  // -- first calculate shifts in centre --
  for(i=0,tmp_newmeans=newmeans,tmp_means=means;i<K;i++){
    for(j=0,dist=0;j<D;j++,tmp_means++,tmp_newmeans++) dist+=sqr(*tmp_means-*tmp_newmeans);
    dcmc[(i<<1)]=dist;
    dist=sqrt(dist);
    dcmc[(i<<1)+1]=dist;
  }

  // -- update the upper bounds --
  for(i=0;i<N;i++,ux++,rx++,cx++){
    *ux=*ux+dcmc[((*cx)<<1)]+2*sqrt(*ux)*dcmc[((*cx)<<1)+1];
    *rx=true;
  }

	return(loop==1);
};

// sets all the upper bounds to actual distances
void update_u(matrix means,btype *ux,matrix points,unsigned int* cx,unsigned int N,unsigned int D)
{
  unsigned int i,j;
  btype dist;
  btype *tmp_means;
  for(i=0;i<N;i++,cx++,ux++){
    for(j=0,dist=0,tmp_means=means+D*(*cx);j<D;j++,points++,tmp_means++) dist+=sqr(*points-*tmp_means);
    dist=sqrt(dist);
    *ux=dist;
  }
}

void correct_ptr(matrix &means,matrix &newmeans,matrix orig_means,matrix orig_newmeans,
                 unsigned int K,unsigned int N,unsigned int D)
{
  unsigned int i;
  matrix tmp_means,tmp_newmeans;
  unsigned int *tmp_newinds,*tmp_inds;

  if(means != orig_means){
    for(i=0,tmp_means=means,tmp_newmeans=newmeans;i<K*D;i++,tmp_means++,tmp_newmeans++) *tmp_newmeans=*tmp_means;
  }
  means=orig_means; // also equal to newmeans
  newmeans=orig_newmeans;

}


void cleanup(matrix &newmeans,unsigned int *&count,bool *&rx,matrix &dc,
             btype *&sc,btype *&dcmc) {
	mxFree(newmeans);
	mxFree(count);
	mxFree(rx);
	mxFree(dc);
	mxFree(sc);
	mxFree(dcmc);
};

unsigned int kmeans(matrix points,matrix initmeans,matrix means,btype *ux,
					unsigned int *cx,unsigned int K,unsigned int N,unsigned int D,
					unsigned int MAXITER) {
	unsigned int *count,i,j,loop,iter=0;
  bool* rx;
	matrix newmeans,pt,dc,orig_means,orig_newmeans;
  btype *sc,*temp,*dcmc;
	btype olderr,toterr=1;
  bool changed=false;

	initvars(newmeans,count,initmeans,dc,rx,sc,ux,dcmc,cx,points,K,N,D);
  orig_means=means;orig_newmeans=newmeans;
	do {
		olderr=toterr;
		reset(means,newmeans,count,dc,sc,K,N,D);
		for (pt=points,toterr=i=0;i<N;i++) {
      if(ux[i]>sc[cx[i]]) {changed|=assign(pt,means,K,D,count,cx[i],ux[i],rx[i],dc);}
      for (temp=newmeans+D*cx[i],j=0;j<D;j++,temp++,pt++) *temp+=*pt; 
      count[cx[i]]++;
			toterr+=sqr(ux[i]);
		};
		loop=update_u(means,newmeans,count,ux,dcmc,cx,rx,K,D,points,N); // Loop if a new mean has been chosen randomly because of a 0 points assignment.
		//mexPrintf("Error after iteration(u bound) %02d : %f [%07.4f%%]\n",iter++,toterr,100*abs(toterr-olderr)/olderr);
	} while (((loop) || changed) && (MAXITER--));

  update_u(means,ux,points,cx,N,D); // Not req for fast kmeans, but orig kmeans expected actual distances from centres
                                    // to be returned
  correct_ptr(means,newmeans,orig_means,orig_newmeans,K,N,D);
	for (i=0;i<N;i++) cx[i]++; // Matlab indices start from 1 rather than 0
	cleanup(newmeans,count,rx,dc,sc,dcmc);
	return(iter-1);
};

void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]) {
	unsigned int K,N,D,MAXITER,*inds;
	matrix points,means,initmeans;
	btype *dists; // We're being pedantic over here but if matrix were to be redefined in a later version ...

  srand(100); // Setting the seed to preserve repeatibility of results

	if (sizeof(unsigned int)!=4) mexErrMsgTxt("Sizeof(unsigned int)!=4. Fix source [mxUINT32_CLASS]");
	if (nrhs!=3) usagerr("Three inputs are required.\n");
	if (nlhs!=4) usagerr("Three outputs are required.\n");
	if (mxGetClassID(prhs[0])!=mxDOUBLE_CLASS) usagerr("Datapoints must be of type double.\n");
	if (mxGetClassID(prhs[1])!=mxDOUBLE_CLASS) usagerr("Initmeans must be of type double.\n");
	if (mxGetNumberOfDimensions(prhs[0])>2) mexErrMsgTxt("Datapoints must be a 2D matrix.");
	if (mxGetNumberOfDimensions(prhs[1])>2) mexErrMsgTxt("Initmeans must be a 2D matrix.");
	if (mxGetM(prhs[0])!=mxGetM(prhs[1])) mexErrMsgTxt("Datapoints, Initmeans dimensions do not match.");

	// Determine input parameters
	K=mxGetN(prhs[1]);N=mxGetN(prhs[0]);D=mxGetM(prhs[0]);MAXITER=(unsigned int)mxGetScalar(prhs[2]);
	points=mxGetPr(prhs[0]);
	initmeans=mxGetPr(prhs[1]);
	
	// Create output variables
	plhs[0]=mxCreateDoubleMatrix(D,K,mxREAL);means=mxGetPr(plhs[0]);
	plhs[1]=mxCreateDoubleMatrix(1,N,mxREAL);dists=mxGetPr(plhs[1]);
	plhs[2]=mxCreateNumericArray(2,mxGetDimensions(plhs[1]),mxUINT32_CLASS,mxREAL);inds=(unsigned int *)mxGetData(plhs[2]);
	plhs[3]=mxCreateDoubleMatrix(1,1,mxREAL); // Later on force niter from unsigned int to double

	mexPrintf("Clustering %dx%d data points into %d clusters in less than %d iterations ...\n",D,N,K,MAXITER);
	*(mxGetPr(plhs[3]))=kmeans(points,initmeans,means,dists,inds,K,N,D,MAXITER);
}
