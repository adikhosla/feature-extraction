function [idx] = getIdxX(imageInfo, start_x, end_x)
idx = imageInfo.x>=imageInfo.wid*start_x & imageInfo.x<imageInfo.wid*end_x;