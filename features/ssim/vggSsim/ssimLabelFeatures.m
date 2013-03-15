function ssimLabelFeatures(ftrDir,vocabPath,labelDir,imgList,parms)
  
  load(vocabPath); % Gives the variable V

  for i=1:length(imgList),
    IMGname=imgList{i};
    onlyImgName=extractImgName(IMGname);
    fprintf('Labeling ssim descriptors of %s\n',onlyImgName);
    load([ftrDir onlyImgName '.mat']);
    textonlabels=uint16(MEXfindnearestl2(features,V));
    %save([RESdirs(j,:),IMGname],'textonlabels');

    origImg=ssimReadImg(IMGname,parms);
    [labelImage,cmap]=drawLabels(textonlabels,size(V,2),ftrCoords,salientCoords,uniformCoords,origImg); 
    
    %height=size(labelImage,1);width=size(labelImage,2);
    %labelImage=labelImage( (1+parms.margin):(height-parms.margin),(1+parms.margin):(width-parms.margin));
    save([labelDir onlyImgName '.mat'],'labelImage');

  end;
end

function [labelImage,cmap]=drawLabels(labels,numClusters,dCoords,sCoords,uCoords,origImg)
  numLabels=numClusters; 

  if size(labels,2)~=size(dCoords,2)
    fprintf('Something wrong with dimensions of arrays of labels and drawing coordinates\n');keyboard;exit;
  end;

  labelImage=zeros(size(origImg,1),size(origImg,2)); % Intialize with the unlabeled tag

  %for i=1:size(dCoords,2)
    %labelImage(dCoords(2,i),dCoords(1,i))=labels(i);
  %end
  labelImage(sub2ind(size(labelImage),dCoords(2,:),dCoords(1,:)))=labels;

  cmap=colorcube(numLabels);
  
end

%function [labelImage,cmap]=drawLabels(labels,numClusters,dCoords,sCoords,uCoords,origImg)
  %numLabels=numClusters+2; % Other than texton labels, we have salient,uniform 
  %labels=labels+2; % The first 2 labels are for uniform, and salient (in order)
%
  %if size(labels,2)~=size(dCoords,2)
    %fprintf('Something wrong with dimensions of arrays of labels and drawing coordinates\n');keyboard;exit;
  %end;
%
  %labelImage=zeros(size(origImg,1),size(origImg,2)); % Intialize with the unlabeled tag
%
  %%for i=1:size(dCoords,2)
    %%labelImage(dCoords(2,i),dCoords(1,i))=labels(i);
  %%end
  %labelImage(sub2ind(size(labelImage),dCoords(2,:),dCoords(1,:)))=labels;
%
  %for i=1:size(uCoords,2)
    %labelImage(uCoords(2,i),uCoords(1,i))=1;
  %end
%
  %for i=1:size(sCoords,2)
    %labelImage(sCoords(2,i),sCoords(1,i))=2;
  %end
  %
  %cmap=colorcube(numLabels);
  %
%end
