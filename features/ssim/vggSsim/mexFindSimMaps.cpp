//#include "/local_home/texture/softs/matlab/extern/include/mex.h"
//#include "/home/varun/linuxSofts/matlab/extern/include/mex.h"
#include "COMTools.h"
//#include "/usr/matlab_R2007a_64/extern/include/mex.h"
#include "mex.h"
//#include "c:\matlab\extern\include\mex.h"
//#include ".h"
#include <math.h>
#define FLOAT_MAX 1e20
#define NCHANNELS 3

void usagerr(char *msg) {
  mexPrintf("%s",msg);
  mexErrMsgTxt("Usage: patches=testMex(xIndices,yIndices,imgpatches,simMapParams);\n");
}

void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]) {

  // Input params are (in order) xIndices,yIndices,imgpatches,simMapParams (a structure), nChannels
  // IMPORTANT: DO NOT modify any thing in prhs please.

  COMindextype numRadiiIntervals,numThetaIntervals,numDescriptors;
  COMindextype interiorH,numSSDs,numAutoVarianceIndices;
  COMindextype *xIndices,*yIndices;
  COMindextype **binIndices;
  COMindextype* numBinIndices;
  COMindextype numBins;
  COMindextype nChannels;
  COMbasetype varNoise;
  int *coRelCircleOffsets;
  int nFields,nStructElements;
  COMindextype *autoVarianceIndices;
  mxArray *tmpArray,*cellArrayPtr; int numPatches,dimPatches;


  if (nrhs<5) usagerr("Atleast Five inputs are required.\n");
  if (nlhs!=1) usagerr("One output is required.\n");

  if (mxGetClassID(prhs[0])!=mxUINT32_CLASS) usagerr("xIndices must be of unsigned int.\n");
  if (mxGetClassID(prhs[1])!=mxUINT32_CLASS) usagerr("yIndices must be of unsigned int.\n");
  if (mxGetClassID(prhs[2])!=mxDOUBLE_CLASS) usagerr("imgpatches must be of type double.\n");
  if (mxGetClassID(prhs[3])!=mxSTRUCT_CLASS) usagerr("simMapParams must be a structure.\n");
  if (mxGetClassID(prhs[4])!=mxUINT32_CLASS) usagerr("nChannels must be a uint32.\n");
  
  xIndices=(COMindextype*)mxGetData(prhs[0]);
  yIndices=(COMindextype*)mxGetData(prhs[1]);
  numPatches=mxGetN(prhs[2])/3; // 3 channel image
  dimPatches=mxGetM(prhs[2]);
  //mexPrintf("numPatches=%d,dimPatches=%d\n",numPatches,dimPatches);return;

  //numXIndices=mxGetN(prhs[0]);numYIndices=mxGetN(prhs[1]);
  //numDescriptors=numXIndices*numYIndices;
  numDescriptors=mxGetN(prhs[0]);
  if(mxGetN(prhs[1])!=numDescriptors)
    usagerr("number of x-coordinates != number of y-coordinates; Exiting\n");

  nChannels=*(COMindextype*)mxGetData(prhs[4]);

  nFields=mxGetNumberOfFields(prhs[3]);
  nStructElements=mxGetNumberOfElements(prhs[3]);

  tmpArray=mxGetField(prhs[3],0,"interiorH");
  if(mxGetClassID(tmpArray)!=mxUINT32_CLASS) usagerr("interior Height, should be uint32\n");
  interiorH=(*(COMindextype*)mxGetData(tmpArray));

  tmpArray=mxGetField(prhs[3],0,"numRadiiIntervals");
  if(mxGetClassID(tmpArray)!=mxUINT32_CLASS) usagerr("numRadiiIntervals , should be uint32\n");
  numRadiiIntervals=(*(COMindextype*)mxGetData(tmpArray));

  tmpArray=mxGetField(prhs[3],0,"numThetaIntervals");
  if(mxGetClassID(tmpArray)!=mxUINT32_CLASS) usagerr("numThetaIntervals, should be uint32\n");
  numThetaIntervals=(*(COMindextype*)mxGetData(tmpArray));

  tmpArray=mxGetField(prhs[3],0,"coRelCircleOffsets");
  if(mxGetClassID(tmpArray)!=mxINT32_CLASS) usagerr("coRelCircleOffsets, should be int32\n");
  coRelCircleOffsets=(int*)mxGetData(tmpArray);
  numSSDs=mxGetN(tmpArray);

  tmpArray=mxGetField(prhs[3],0,"autoVarianceIndices");
  if(mxGetClassID(tmpArray)!=mxUINT32_CLASS) usagerr("autoVarianceIndices, should be uint32\n");
  autoVarianceIndices=(COMindextype*)mxGetData(tmpArray);
  numAutoVarianceIndices=mxGetM(tmpArray);

  tmpArray=mxGetField(prhs[3],0,"varNoise");
  if(mxGetClassID(tmpArray)!=mxDOUBLE_CLASS) usagerr("varNoise, should be double\n");
  varNoise=*mxGetPr(tmpArray);
 
  cellArrayPtr=mxGetField(prhs[3],0,"binIndices");
  if(mxGetClassID(cellArrayPtr)!=mxCELL_CLASS) usagerr("binIndices, should be cell class type\n");
  numBins=mxGetNumberOfElements(cellArrayPtr);

  binIndices=(COMindextype**)mxMalloc(sizeof(COMindextype*)*numBins);
  numBinIndices=(COMindextype*)mxMalloc(sizeof(COMindextype)*numBins);
  //mexPrintf("numBins=%d\n",numBins);
  for(int i=0;i<numBins;i++){
    tmpArray=mxGetCell(cellArrayPtr,i);
    if(mxGetClassID(tmpArray)!=mxUINT32_CLASS) usagerr("binIndices , should be uint32 type\n");
    binIndices[i]=(COMindextype*)mxGetData(tmpArray);
    numBinIndices[i]=mxGetM(tmpArray);
    //mexPrintf("numBinIndices[%d]=%d\n",i,numBinIndices[i]);
  }

  if(nChannels==3){
    COMmatrix imgPatches[3];
    imgPatches[0]=(COMmatrix)mxGetData(prhs[2]);
    imgPatches[1]=numPatches*dimPatches+imgPatches[0];
    imgPatches[2]=numPatches*dimPatches+imgPatches[1];

    COMmatrix curPatch[3];
    COMmatrix ssdS=(COMmatrix)mxMalloc(sizeof(COMbasetype)*numSSDs);
    COMindextype descSize=numThetaIntervals*numRadiiIntervals;
    plhs[0]=mxCreateDoubleMatrix(descSize,numDescriptors,mxREAL);
    COMmatrix outTraveller=(COMmatrix)mxGetData(plhs[0]);

    //mexPrintf("0=%f 1=%f 2=%f\n",(float)*imgPatches[0],(float)(*imgPatches[1]),(float)*imgPatches[2]);
    //mexPrintf("x= %d, y=%d \n",numXIndices,numYIndices); 

    for(int x=0;x<numDescriptors;x++,xIndices++,yIndices++){
      curPatch[0]=imgPatches[0]+((*xIndices)*interiorH+(*yIndices))*dimPatches;
      curPatch[1]=imgPatches[1]+((*xIndices)*interiorH+(*yIndices))*dimPatches;
      curPatch[2]=imgPatches[2]+((*xIndices)*interiorH+(*yIndices))*dimPatches;

      int* offsetTraveller=coRelCircleOffsets;
      COMmatrix ssdTraveller=ssdS;
      COMmatrix tmpPatch[3],tmpPatch2[3];
      for(int i=0;i<numSSDs;i++,offsetTraveller++,ssdTraveller++){
        *ssdTraveller=0;
        tmpPatch[0]=curPatch[0]+(*offsetTraveller)*dimPatches;
        tmpPatch[1]=curPatch[1]+(*offsetTraveller)*dimPatches;
        tmpPatch[2]=curPatch[2]+(*offsetTraveller)*dimPatches;
        tmpPatch2[0]=curPatch[0];
        tmpPatch2[1]=curPatch[1];
        tmpPatch2[2]=curPatch[2];
        for(int j=0;j<dimPatches;j++){
          COMbasetype diff;
          diff=*tmpPatch2[0]-*tmpPatch[0];tmpPatch[0]++;tmpPatch2[0]++;
          *ssdTraveller+=diff*diff;
          diff=*tmpPatch2[1]-*tmpPatch[1];tmpPatch[1]++;tmpPatch2[1]++;
          *ssdTraveller+=diff*diff;
          diff=*tmpPatch2[2]-*tmpPatch[2];tmpPatch[2]++;tmpPatch2[2]++;
          *ssdTraveller+=diff*diff;
        }

      }

      COMbasetype autoQ=0;
      for(int j=0;j<numAutoVarianceIndices;j++){
        COMbasetype tmp=ssdS[autoVarianceIndices[j]];
        autoQ=(tmp>autoQ)?tmp:autoQ;
      }

      COMbasetype divisor= (autoQ>varNoise)?autoQ:varNoise;
      ssdTraveller=ssdS;
      for(int k=0;k<numSSDs;k++,ssdTraveller++)
        *ssdTraveller=exp(-1*(*ssdTraveller)/divisor); 

      for(int l=0;l<numBins;l++,outTraveller++){
        COMbasetype max=0;
        COMindextype* curBinIndices=binIndices[l];
        for(int j=0;j<numBinIndices[l];j++){
          if(ssdS[curBinIndices[j]] > max) max=ssdS[curBinIndices[j]];
        }
        *outTraveller=max;
      }

    }
    mxFree(ssdS);mxFree(binIndices);mxFree(numBinIndices);
  }
  else if(nChannels==1){

    COMmatrix imgPatches;
    imgPatches=(COMmatrix)mxGetData(prhs[2]);

    COMmatrix curPatch;
    COMmatrix ssdS=(COMmatrix)mxMalloc(sizeof(COMbasetype)*numSSDs);
    COMindextype descSize=numThetaIntervals*numRadiiIntervals;
    plhs[0]=mxCreateDoubleMatrix(descSize,numDescriptors,mxREAL);
    COMmatrix outTraveller=(COMmatrix)mxGetData(plhs[0]);

    //mexPrintf("0=%f 1=%f 2=%f\n",(float)*imgPatches[0],(float)(*imgPatches[1]),(float)*imgPatches[2]);
    //mexPrintf("x= %d, y=%d \n",numXIndices,numYIndices); 

    for(int x=0;x<numDescriptors;x++,xIndices++,yIndices++){
      curPatch=imgPatches+((*xIndices)*interiorH+(*yIndices))*dimPatches;

      int* offsetTraveller=coRelCircleOffsets;
      COMmatrix ssdTraveller=ssdS;
      COMmatrix tmpPatch,tmpPatch2;
      for(int i=0;i<numSSDs;i++,offsetTraveller++,ssdTraveller++){
        *ssdTraveller=0;
        tmpPatch=curPatch+(*offsetTraveller)*dimPatches;
        tmpPatch2=curPatch;
        for(int j=0;j<dimPatches;j++){
          COMbasetype diff;
          diff=*tmpPatch2-*tmpPatch;tmpPatch++;tmpPatch2++;
          *ssdTraveller+=diff*diff;
        }

      }

      COMbasetype autoQ=0;
      for(int j=0;j<numAutoVarianceIndices;j++){
        COMbasetype tmp=ssdS[autoVarianceIndices[j]];
        autoQ=(tmp>autoQ)?tmp:autoQ;
      }

      COMbasetype divisor= (autoQ>varNoise)?autoQ:varNoise;
      ssdTraveller=ssdS;
      for(int k=0;k<numSSDs;k++,ssdTraveller++)
        *ssdTraveller=exp(-1*(*ssdTraveller)/divisor); 

      for(int l=0;l<numBins;l++,outTraveller++){
        COMbasetype max=0;
        COMindextype* curBinIndices=binIndices[l];
        for(int j=0;j<numBinIndices[l];j++){
          if(ssdS[curBinIndices[j]] > max) max=ssdS[curBinIndices[j]];
        }
        *outTraveller=max;
      }

    }
    mxFree(ssdS);mxFree(binIndices);mxFree(numBinIndices);
  }
  else{ usagerr("nChannels can only be 1 or 3\n");}

  // Free: 
}
