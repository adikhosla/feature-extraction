function [ ] = make_dir( folderPath )

folder = fileparts(folderPath);

if(~isdir(folder))
    mkdir(folder);
end

