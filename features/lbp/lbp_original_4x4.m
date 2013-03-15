function [feature_L0 feature_L1 feature_L2] = lbp_original_4x4(I)

feature_L0(:,1) = lbp_original(I);
fL = length(feature_L0);

h = size(I,1);  w = size(I,2);


feature_L1(1     :  fL,1) = lbp_original(I(1:round(h/2),1:round(w/2)));
feature_L1(fL+1  :2*fL,1) = lbp_original(I(1:round(h/2),round(w/2)+1:end));
feature_L1(2*fL+1:3*fL,1) = lbp_original(I(round(h/2)+1:end,round(w/2)+1:end));
feature_L1(3*fL+1:4*fL,1) = lbp_original(I(round(h/2)+1:end,1:round(w/2)));


feature_L2( 1     :   fL,1) = lbp_original(I(1:round(h/4),              1:round(w/4)));  
feature_L2( fL+1  : 2*fL,1) = lbp_original(I(1:round(h/4),              round(w/4)+1:round(w/2)));  
feature_L2( 2*fL+1: 3*fL,1) = lbp_original(I(1:round(h/4),              round(w/2)+1:round(w/4*3)));    
feature_L2( 3*fL+1: 4*fL,1) = lbp_original(I(1:round(h/4),              round(w/4*3)+1:end));
feature_L2( 4*fL+1: 5*fL,1) = lbp_original(I(round(h/4)+1:round(h/2),   1:round(w/4)));  
feature_L2( 5*fL+1: 6*fL,1) = lbp_original(I(round(h/4)+1:round(h/2),   round(w/4)+1:round(w/2)));  
feature_L2( 6*fL+1: 7*fL,1) = lbp_original(I(round(h/4)+1:round(h/2),   round(w/2)+1:round(w/4*3)));    
feature_L2( 7*fL+1: 8*fL,1) = lbp_original(I(round(h/4)+1:round(h/2),   round(w/4*3)+1:end));
feature_L2( 8*fL+1: 9*fL,1) = lbp_original(I(round(h/2)+1:round(h/4*3), 1:round(w/4)));  
feature_L2( 9*fL+1:10*fL,1) = lbp_original(I(round(h/2)+1:round(h/4*3), round(w/4)+1:round(w/2)));  
feature_L2(10*fL+1:11*fL,1) = lbp_original(I(round(h/2)+1:round(h/4*3), round(w/2)+1:round(w/4*3)));    
feature_L2(11*fL+1:12*fL,1) = lbp_original(I(round(h/2)+1:round(h/4*3), round(w/4*3)+1:end));
feature_L2(12*fL+1:13*fL,1) = lbp_original(I(round(h/4*3)+1:end,        1:round(w/4)));  
feature_L2(13*fL+1:14*fL,1) = lbp_original(I(round(h/4*3)+1:end,        round(w/4)+1:round(w/2)));  
feature_L2(14*fL+1:15*fL,1) = lbp_original(I(round(h/4*3)+1:end,        round(w/2)+1:round(w/4*3)));    
feature_L2(15*fL+1:16*fL,1) = lbp_original(I(round(h/4*3)+1:end,        round(w/4*3)+1:end));
