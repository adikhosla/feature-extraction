function [beta] = max_pooling(integralData, imageInfo, poolRegion, pyramidLevels)
%
% Copyright Aditya Khosla http://mit.edu/khosla
%
% Please cite this paper if you use this code in your publication:
%   A. Khosla, J. Xiao, A. Torralba, A. Oliva
%   Memorability of Image Regions
%   Advances in Neural Information Processing Systems (NIPS) 2012
%

x=poolRegion.x1; px=poolRegion.x2-poolRegion.x1;
y=poolRegion.y1; py=poolRegion.y2-poolRegion.y1;

pyramid = 2.^(0:pyramidLevels);
stepSize.x = px/(pyramid(end));
stepSize.y = py/(pyramid(end));

pyramidIdx = cell(pyramid(end));
tBins = sum(pyramid.^2);
featureSize = size(integralData{1}, 2);
numImages = length(integralData);
beta = zeros(numImages, featureSize*tBins);
currentBin = 1;

for i=1:pyramid(end)
    start_x = x+(i-1)*stepSize.x;
    end_x = x+i*stepSize.x;
    x_idx = cellfun(@(x) getIdxX(x, start_x, end_x), imageInfo, 'UniformOutput', false);
    
    for j=1:pyramid(end)
        start_y = y + (j-1)*stepSize.y;
        end_y = y + j*stepSize.y;
        idx = cellfun(@(x, y) getIdxY(x, y,start_y, end_y), imageInfo, x_idx, 'UniformOutput', false);
        binIdx = (currentBin-1)*featureSize+1:currentBin*featureSize; 
        pyramidIdx{i, j} = binIdx;
				emptyIdx = find(cellfun(@(x) sum(x)==0, idx));

        if(~isempty(emptyIdx))
            binIdx = (currentBin-1)*featureSize+1:currentBin*featureSize;
            pyramidIdx{i, j} = binIdx;
            idx(emptyIdx) = [];
            tempIntegralData = integralData;
            tempIntegralData(emptyIdx) = [];
            tempbeta = cell2mat(cellfun(@maxIdx, tempIntegralData, idx, 'UniformOutput', false));
            for k=1:length(emptyIdx)
                tempbeta = insertrows(tempbeta, 0, emptyIdx(k)-1);
            end
            beta(:, binIdx) = tempbeta;
        else
            beta(:, binIdx) = cell2mat(cellfun(@maxIdx, integralData, idx, 'UniformOutput', false));
        end
        currentBin = currentBin + 1;
    end
end

pyramidCell = cell(length(pyramid));
pyramidCell{1} = pyramidIdx;
for i=1:length(pyramid)-1
    pyramidSize = pyramid(end-i);
    pyramidCell{i+1} = cell(pyramidSize);
    for j=1:pyramidSize
        for k=1:pyramidSize
            binIdx = (currentBin-1)*featureSize+1:currentBin*featureSize;
            pyramidCell{i+1}{j, k} = binIdx;
            beta(:, binIdx) = max(beta(:, pyramidCell{i}{2*(j-1)+1, 2*(k-1)+1}), beta(:, pyramidCell{i}{2*(j-1)+1, 2*k}));
            beta(:, binIdx) = max(beta(:, pyramidCell{i}{2*j, 2*(k-1)+1}), beta(:, binIdx));
            beta(:, binIdx) = max(beta(:, pyramidCell{i}{2*j, 2*k}), beta(:, binIdx));            
            currentBin = currentBin + 1;
        end
    end
end

norm_beta = sqrt(sum(beta.^2, 2));
beta = beta./repmat(norm_beta, [1 size(beta, 2)]);
