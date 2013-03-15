function [p] = config_lbp(c)
p.feature_size = 59*(1+4+16);
p.maxsize = 500;
p.train_file = ['%s/train_lbp_' num2str(p.feature_size) '.mat'];
p.test_file = ['%s/test_lbp_' num2str(p.feature_size) '.mat'];

