function sift_arr = sp_normalize_sift(sift_arr)
% normalize SIFT descriptors (after Lowe)

% find indices of descriptors to be normalized (those whose norm is larger than 1)
tmp = sqrt(sum(sift_arr.^2, 2));
normalize_ind = find(tmp > 1);

sift_arr_norm = sift_arr(normalize_ind,:);
sift_arr_norm = sift_arr_norm ./ repmat(tmp(normalize_ind,:), [1 size(sift_arr,2)]);

% suppress large gradients
sift_arr_norm(find(sift_arr_norm > 0.2)) = 0.2;

% finally, renormalize to unit length
tmp = sqrt(sum(sift_arr_norm.^2, 2));
sift_arr_norm = sift_arr_norm ./ repmat(tmp, [1 size(sift_arr,2)]);

sift_arr(normalize_ind,:) = sift_arr_norm;
