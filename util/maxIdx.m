function [maxVal] = maxIdx(a, idx)
maxVal = max(a(idx, :), [], 1);
