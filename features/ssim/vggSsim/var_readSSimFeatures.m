function fvTrain = var_readSSimFeatures(ftrDir,imgList,par)
% Read in feature for the purpose of clustering
% Extracted features are in ftrDir,
% imgList is the list of images to consider for clutering
% par contains options about how many images to subsample
% and how many features per image
fvTrain = [];

for j=1:length(imgList)

    onlyImgName=extractImgName(imgList{j});
%onlyImgName=imgList{j};
    tmpLoad=load([ftrDir onlyImgName '.mat']);
    fv=tmpLoad.features;
    clear tmpLoad;

    usedfeatures = zeros(1,size(fv,2));
    if par.nFeaturesCluster <=size(fv,2)
        for k=1:par.nFeaturesCluster
            index = round(rand(1)*size(fv,2));
            while index ==0 || usedfeatures(1,index)
                index = round(rand(1)*size(fv,2));
            end
            fvTrain = [fvTrain fv(:,index)];
        end
    else
        fvTrain = [fvTrain fv];
    end
end
