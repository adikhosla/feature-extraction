function [maxVal] = maxIdxPascal(a, idx)
maxVal = max(a(idx, :), [], 1);
