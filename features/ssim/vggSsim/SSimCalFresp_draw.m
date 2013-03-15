function [resp,drawCoords,salientCoords,uniformCoords]=SSimCalFresp_draw(img,parms,allXCoords,allYCoords)

  %img=TXTreadimg(imgName,parms);

  [resp,drawCoords,salientCoords,uniformCoords]= ...
  calcFresps(img,parms.size,parms.coRelWindowRadius,allXCoords,allYCoords,parms.numRadiiIntervals, ...
                 parms.numThetaIntervals,parms.varNoise,parms.autoVarRadius,parms.saliencyThresh,parms.nChannels);

end


function [ssimMaps,dCoords,sCoords,uCoords]=calcFresps(img,patchSize,coRelWindowRadius,allXCoords,allYCoords, ...
          numRadiiIntervals, numThetaIntervals,varNoise,autoVarRadius,saliencyThresh,nChannels)

NUMradius=(patchSize-1)/2; % Note: patchSize should be odd only
NUMpixels=patchSize*patchSize;

% -- Find all the image patches -----
[NUMrows,NUMcols]=size(img(:,:,1));
[colinds,rowinds]=meshgrid([1:NUMcols],[1:NUMrows]);
rowinds=rowinds(NUMradius+1:NUMrows-NUMradius,NUMradius+1:NUMcols-NUMradius);
colinds=colinds(NUMradius+1:NUMrows-NUMradius,NUMradius+1:NUMcols-NUMradius);
NUMvalid=prod(size(rowinds));
rowinds=reshape(rowinds,1,NUMvalid); % Row coordinates for extracting patches
colinds=reshape(colinds,1,NUMvalid); % Col coordinates for extracting patches

rexpand=repmat([-NUMradius:NUMradius]',patchSize,1);
cexpand=reshape(repmat([-NUMradius:NUMradius],patchSize,1),NUMpixels,1);
if (NUMvalid>0),
  rowinds=repmat(rowinds,NUMpixels,1)+repmat(rexpand,1,NUMvalid);
  colinds=repmat(colinds,NUMpixels,1)+repmat(cexpand,1,NUMvalid);
  inds=sub2ind([NUMrows NUMcols],rowinds,colinds);
  clear rowinds,colinds; % saving memory
  if nChannels==3,
    ch=img(:,:,1);
    imgpatches(:,:,1)=ch(inds);
    ch=img(:,:,2);
    imgpatches(:,:,2)=ch(inds);
    ch=img(:,:,3);
    imgpatches(:,:,3)=ch(inds);
  else
    imgpatches(:,:)=img(inds);
  end;
  clear inds; % saving memory
else
  imgpatches=[];
end;

counter=1;


simMapParams=makeSimMapParams(coRelWindowRadius,NUMrows,NUMradius,autoVarRadius,numRadiiIntervals, ...
                              numThetaIntervals,varNoise);

%ssimMaps=zeros(numRadiiIntervals*numThetaIntervals,length(xIndices)*length(yIndices));
%for x=xIndices
%  for y=yIndices
%    ssimMaps(:,counter)=findSimMap(x-NUMradius,y-NUMradius,imgpatches,simMapParams);
%    counter=counter+1;
%  end
%end
%ssimMaps

simMapParams.interiorH=uint32(simMapParams.interiorH);
simMapParams.coRelCircleOffsets=int32(simMapParams.coRelCircleOffsets);
simMapParams.numRadiiIntervals=uint32(simMapParams.numRadiiIntervals);
simMapParams.numThetaIntervals=uint32(simMapParams.numThetaIntervals);
simMapParams.autoVarianceIndices=uint32(simMapParams.autoVarianceIndices-1); % Making it 0 indexed
for i=1:length(simMapParams.binIndices)
  simMapParams.binIndices{i}=uint32(simMapParams.binIndices{i}-1); %Making it 0 indexed
end

ssimMaps=mexFindSimMaps(uint32(allXCoords-1-NUMradius),uint32(allYCoords-1-NUMradius),imgpatches,simMapParams, ...
                        uint32(nChannels));
allCoords(1,:)=allXCoords;allCoords(2,:)=allYCoords;
%clear allXCoords,allYCoords;
%[indsSalient,indsUniform,indsOkay,ssimMaps]=pruneAndScaleMaps(ssimMaps,saliencyThresh); % TO BE COMPLETED 
%dCoords=allCoords(:,indsOkay);
%sCoords=allCoords(:,indsSalient);
%uCoords=allCoords(:,indsUniform);
%ssimMaps=ssimMaps(:,indsOkay);

dCoords=allCoords;
sCoords=zeros(2,0);
uCoords=zeros(2,0);

end

function [indsSalient,indsUniform,indsOkay,newMaps]=pruneAndScaleMaps(simMaps,saliencyThresh)
  threshMaps=simMaps<saliencyThresh;
  threshMaps=sum(threshMaps,1);
  indsUniform=[];
  indsSalient=find(threshMaps==0);
  indsOkay=find(threshMaps~=0);
  newMaps=simMaps(:,indsOkay);
  clear simMaps;
  maxMaps=max(newMaps); %Takes the max along the columns
  maxMaps=repmat(maxMaps,size(newMaps,1),1);
  newMaps=newMaps./maxMaps;
end

function simMap=findSimMap(xInterior,yInterior,imgPatches,parms)
  % Note: xInterior,yInterior are 1 based indices
  interiorH=parms.interiorH;
  coRelCircleOffsets=parms.coRelCircleOffsets;
  autoVarianceIndices=parms.autoVarianceIndices;

  curIndex=(xInterior-1)*interiorH+yInterior;
  curPatch=imgPatches(:,curIndex,:);
  allPatches=imgPatches(:,curIndex+coRelCircleOffsets,:);
  numPatches=size(allPatches,2);
  curPatchRep=repmat(curPatch,1,numPatches);
  ssdS=curPatchRep-allPatches;
  %diffs=ssdS(:,autoVarianceIndices,:);diffMeans=sum(diffs,1)/parms.numPixels;diffMeansSqr=diffMeans.*diffMeans;
  ssdS=ssdS.*ssdS;
  ssdS=sum(ssdS,1);
  %autoVariances=ssdS(:,autoVarianceIndices,:)/parms.numPixels-diffMeansSqr;
  %autoVariances=sum(autoVariances,3);
  ssdS=sum(ssdS,3);
  autoVariances=ssdS(autoVarianceIndices);
  autoQ=max(autoVariances);
  ssdS=exp(-1*ssdS/max(parms.varNoise,autoQ));
  
  numBins=length(parms.binIndices);
  simMap=zeros(numBins,1);
  % Now quantize the SSD's into bins
  for i=1:numBins
    if(length(parms.binIndices{i}) == 0) simMap(i)=0;
    else simMap(i)=max(ssdS(parms.binIndices{i}));
    end;
  end
  
end

function parms=makeSimMapParams(coRelWindowRadius,imgHeight,patchRad,autoVarRadius,numRadiiIntervals,numThetaIntervals ...
                                ,noiseVariance)

  if (autoVarRadius>coRelWindowRadius)
    fprintf('Incorrect data, autoVarRadius cant be greater than coRelWindowRadius\n');keyboard;return;
  end
  
  parms.interiorH=imgHeight-2*patchRad;
  parms.numPixels=(2*patchRad+1)*(2*patchRad+1);
  parms.varNoise=noiseVariance;
  parms.numThetaIntervals=numThetaIntervals;
  parms.numRadiiIntervals=numRadiiIntervals;
  [xGrid,yGrid]=meshgrid([-coRelWindowRadius:1:coRelWindowRadius],[coRelWindowRadius:-1:-coRelWindowRadius]);
  circleMask=((xGrid.*xGrid+yGrid.*yGrid)<=coRelWindowRadius*coRelWindowRadius);
  circleMask(coRelWindowRadius+1,coRelWindowRadius+1)=0;
  autoVarMask=((xGrid.*xGrid+yGrid.*yGrid)<=autoVarRadius*autoVarRadius);
  autoVarMask(coRelWindowRadius+1,coRelWindowRadius+1)=0; % No need to calc at the pixel location itself
  circleMask=circleMask+autoVarMask;

  radii=xGrid.*xGrid+yGrid.*yGrid;
  thetas=zeros(size(circleMask));
  for x=1:(2*coRelWindowRadius+1)
    for y=1:(2*coRelWindowRadius+1)
      xC=xGrid(x,y);yC=yGrid(x,y);
      xQuad=(xC>=0);yQuad=(yC>=0);
      quad=xQuad*2+yQuad;
      switch quad
        case 0
          if(xC==0) thetas(x,y)=pi;
          else thetas(x,y)=1.5*pi-atan(yC/xC);
          end;
        case 1
          if(xC==0) thetas(x,y)=0;
          else thetas(x,y)=1.5*pi-atan(yC/xC);
          end;
        case 2
          if(xC==0) thetas(x,y)=pi;
          else thetas(x,y)=0.5*pi-atan(yC/xC);
          end;
        case 3
          if(xC==0) thetas(x,y)=0;
          else thetas(x,y)=0.5*pi-atan(yC/xC);
          end;
      end
    end
  end

  thetaInterval=2*pi/numThetaIntervals; 
  thetaIndexes=floor(thetas/thetaInterval); % 0 indexed
  radiiInterval=log(1+coRelWindowRadius)/numRadiiIntervals; 
  for i=1 : numRadiiIntervals-1
    radiiQuants(i)=exp(i*radiiInterval)-1;
  end
  radiiQuants(numRadiiIntervals)=coRelWindowRadius;
  radiiQuants=radiiQuants.*radiiQuants; % Using squares of the radii for comparison
  radiiIndexes=zeros(size(circleMask));
  for i=1:length(radiiQuants)
    radiiIndexes=radiiIndexes+(radii<=radiiQuants(i)); 
  end
  radiiIndexes=radiiIndexes-1; % To make it 0 indexed, Dont worry about pixels which are outside the circle, they will be
                               % pruned anyway

  binIndexes=thetaIndexes*length(radiiQuants)+radiiIndexes;
  
  xGrid=xGrid(:);yGrid=yGrid(:);circleMask=circleMask(:);binIndexes=binIndexes(:);
  interiorIndices=find(circleMask);
  xGrid=xGrid(interiorIndices);yGrid=yGrid(interiorIndices);binIndexes=binIndexes(interiorIndices);
  circleMask=circleMask(interiorIndices);
  parms.coRelCircleOffsets=(xGrid*parms.interiorH+yGrid)';
  parms.autoVarianceIndices=find(circleMask==2);

  totalBins=numRadiiIntervals*numThetaIntervals; 
  for i= 1 : totalBins
    parms.binIndices{i}=find(binIndexes==(i-1));
  end

end
