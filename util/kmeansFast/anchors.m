function [centers, mincenter, mindist, lower, computed] = anchors(firstcenter,k,data)
% choose k centers by the furthest-first method
% URL: http://cseweb.ucsd.edu/~elkan/fastkmeans.html

[n,dim] = size(data);
centers = zeros(k,dim);
lower = zeros(n,k);
mindist = Inf*ones(n,1);
mincenter = ones(n,1);
computed = 0;
centdist = zeros(k,k);

for j = 1:k
    if j == 1
        newcenter = firstcenter;
    else
        [maxradius,i] = max(mindist);
        newcenter = data(i,:);
    end

    centers(j,:) = newcenter;
    centdist(1:j-1,j) = calcdist(centers(1:j-1,:),newcenter);
    centdist(j,1:j-1) = centdist(1:j-1,j)';
    computed = computed + j-1;
    
    inplay = find(mindist > centdist(mincenter,j)/2);
    newdist = calcdist(data(inplay,:),newcenter);
    computed = computed + size(inplay,1);
    lower(inplay,j) = newdist;
        
    move = find(newdist < mindist(inplay));
    shift = inplay(move);
    mincenter(shift) = j;
    mindist(shift) = newdist(move);
end
