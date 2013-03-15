function [fresp,drawCoords,salientCoords,uniformCoords]=getSSimFeatures(IMGname,parms)
% Compute the self-similarity descriptors on the image
% Parameters are specified in parms

  ss_x=parms.subsample_x;ss_y=parms.subsample_y;

  img=ssimReadImg(IMGname,parms);
  NUMradius=(parms.size-1)/2;
  coRelWindowRadius=parms.coRelWindowRadius;
  [NUMrows,NUMcols]=size(img(:,:,1));

  xMargin=NUMradius+coRelWindowRadius;
  yMargin=NUMradius+coRelWindowRadius;
  xIndices=[xMargin+1:ss_x:(NUMcols-xMargin)];xIndices=round(xIndices); % 1 Based indices
  yIndices=[yMargin+1:ss_y:(NUMrows-yMargin)];yIndices=round(yIndices);
  [allXCoords,allYCoords]=meshgrid(xIndices,yIndices);
  allXCoords=allXCoords(:)';allYCoords=allYCoords(:)';

  [fresp,drawCoords,salientCoords,uniformCoords]=SSimCalFresp_draw(img,parms,allXCoords,allYCoords);

end
