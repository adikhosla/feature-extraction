function feature = lbp_original(I)

mapping=getmapping(8,'u2');
feature=lbp(I,1,8,mapping,'h');
%H2=LBP(I);
