function s = Tread_ArcCheck_snc(folder,file)

	if ~exist('file'); fid = fopen(folder); else fid = fopen([folder,file]); end
	
% 	leggo intestazione
	fgetl(fid);
	spstr = regexp(fgetl(fid),'\t','split'); s.DoseUnits = spstr(2); 
	spstr = regexp(fgetl(fid),'\t','split'); s.DoseScalar = spstr(2); 
	spstr = regexp(fgetl(fid),'\t','split'); s.CoordUnits = spstr(2); 
	fgetl(fid);
	
%	read while EOF is reached
	tline = fgetl(fid);
	spstr = regexp(tline,'\t','split');
	tmp = str2double(spstr);
	s.X = tmp(~isnan(tmp));
	count = 1;
	while ~feof(fid) | numel(tline) ==0;
		tline = fgetl(fid);
		spstr = regexp(tline,'\t','split');
		tmp = str2double(spstr);
		Y(count) = tmp(1);
		tmp = tmp(2:end); mat(:,count) = tmp(~isnan(tmp));
		count = count+1;
	end
	s.Y = Y;
	s.data = mat;
end