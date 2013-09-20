function [] = cleanBadFiles(folder)
if(folder(end)~='/'), folder=[folder '/']; end
folders = dir(folder); folders = folders(3:end);
for i=1:length(folders)
	if(folders(i).isdir)
		cleanBadFiles([folder folders(i).name '/']);
	else
		file = [folder folders(i).name]; bad=0;
		try
			tmp = load(file, 'info', 'batch_files');
			if(isfield(tmp, 'info') && isempty(tmp.info)), bad=1; end

			if(isfield(tmp, 'batch_files'))
				for j=1:length(tmp.batch_files)
					if(~exist(tmp.batch_files{j}, 'file')), bad=1; 
					else, tmp2=load(tmp.batch_files{j});
						if(isfield(tmp2, 'info') && isempty(tmp2.info)), bad=1; end
					end
				end
			end
		catch e, bad=1;	end

		if(bad==1), disp(['Deleted bad file: ' file]); system(['rm ' file]); end
	end
end
