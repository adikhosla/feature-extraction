function [] = parsaveLLC(file, poolfeat, info)
make_dir(file);
save(file, 'poolfeat', 'info');
