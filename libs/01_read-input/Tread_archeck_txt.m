function s = Tread_archeck_txt(folder,file)
	
	if ~exist('file'); fid = fopen(folder); else fid = fopen([folder,file]); end
	
% leggo intestazione
	for j=1:18; fgetl(fid); end
	spstr = regexp(fgetl(fid),'\t','split');
 	s.date = spstr(2); s.time = spstr(4);
	for j=1:14; fgetl(fid); end
	spstr = regexp(fgetl(fid),'\t','split');	s.Rows = str2double(spstr(2));
	spstr = regexp(fgetl(fid),'\t','split');	s.Cols = str2double(spstr(2));
	spstr = regexp(fgetl(fid),'\t','split');	s.XCAX = str2double(spstr(2));
	spstr = regexp(fgetl(fid),'\t','split');	s.YCAX = str2double(spstr(2));
	for j=1:8; fgetl(fid); end
	
%	read while EOF is reached
	tlinefirst = fgetl(fid);
	tline = tlinefirst;
	while ~feof(fid) | numel(tline) ==0;
		tlinepre = tline;
		tline = fgetl(fid);
		spstr = regexp(tline,'\t','split');
		if strcmp(spstr(1),'Ycm');
			Ycm = []; ROW = []; Xcm = []; COL = []; mat = [];
			for j=1:s.Rows;
				tline = fgetl(fid);
				spstr = regexp(tline,'\t','split');
				tmp =  str2double(spstr);
				Ycm(j) = tmp(1);
				ROW(j) = tmp(2);
				mat(j,:) = tmp(3:end);
			end
			tline = fgetl(fid);
			spstr = regexp(tline,'\t','split');
			tmp =  str2double(spstr);
			COL = tmp(3:end);
			tline = fgetl(fid);
			spstr = regexp(tline,'\t','split');
			tmp =  str2double(spstr);
			Xcm = tmp(3:end);
			field = tlinepre; field(field == ' ') = []; field(field == ')' | field == '(') = []; 
			eval(['s.',field,'.mat = transpose(flipud(mat));']);
			eval(['s.',field,'.Xcm = transpose(Xcm);']);
			eval(['s.',field,'.Ycm = transpose(Ycm);']);
			eval(['s.',field,'.COL = COL;']);
			eval(['s.',field,'.ROW = ROW;']);
		end
	end
	fclose(fid);
	
end