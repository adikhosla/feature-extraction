function [idx] = getIdxY(imageInfo, x_idx, start_y, end_y) 
idx = imageInfo.y>=(imageInfo.hgt*start_y) & imageInfo.y< (imageInfo.hgt*end_y) & x_idx;