function [header Inline Crossline PDD] = Tread_RS_data(input_file)

%	SCOPO:
%		Legge i profili esportati da RayStation in formato csv
%
%	VARIABILI:
%		- input_file: indirizzo assoluto del file da leggere
%
%	RITORNO:
%		Struttura che contine: 
%		- 
%
%	A. Scaggion - Padova - 18/03/2015


	header = {}; Inline =[]; Crossline = []; PDD = [];
	
	% Open dynalog file
	fid = fopen(input_file,'r');
	
	% leggo heaqder non interessante
	tmp = fgetl(fid);
	count = 1;
	while( strcmp(tmp(1),'#') );
		header(count) = {tmp(2:end)};
		count = count+1;
		tmp = fgetl(fid);
	end
	header = header';
	
	incount = 1; crcount = 1;	pddcount = 1;
	while ~feof(fid);	
		energy = [];
		SSD = [];
		FieldSize = [];
		FieldCenter = [];
		RadiationType = [];
		Quantity = [];
		StartPoint = [];
		loc = [];
		data = [];
		% comincio a prendere l'header del beam
		% energia
		C = strsplit(tmp,'; '); energy = str2num(C{2});

		% SSD
		tmp = fgetl(fid); C = strsplit(tmp,'; '); SSD = str2num(C{2});
		% FieldSize / FieldCenter
		tmp = fgetl(fid); C = strsplit(tmp,'; '); 
		FieldSize = [str2num(C{4})-str2num(C{2}); str2num(C{5})-str2num(C{3})];
		FieldCenter = [str2num(C{4})+str2num(C{2}); str2num(C{5})+str2num(C{3})]/2;
		% CurveType
		tmp = fgetl(fid); C = strsplit(tmp,'; '); CurveType = strtrim(C{2});
		% RadiationType
		tmp = fgetl(fid); C = strsplit(tmp,'; '); RadiationType = C{2};
		% Quantity
		tmp = fgetl(fid); C = strsplit(tmp,'; '); Quantity = C{2};
		% StartPoint
		tmp = fgetl(fid); C = strsplit(tmp,'; '); for j=2:4; StartPoint(j-1) = str2num(C{j}); end  
		tmp = fgetl(fid);
		count = 1;
		% dati
		while ~strcmp(tmp,'End');
			C = strsplit(tmp,'; '); loc(count) = str2num(C{1}); data(count) = str2num(C{2}); 
			count = count+1;
			tmp = fgetl(fid);
		end
				
		switch CurveType
			case 'Inline'
				Inline(incount).energy = energy;
				Inline(incount).SSD = SSD;
				Inline(incount).FieldSize = FieldSize;
				Inline(incount).FieldCenter = FieldCenter;
				Inline(incount).RadiationType = RadiationType;
				Inline(incount).Quantity = Quantity;
				Inline(incount).StartPoint = StartPoint;
				fn = sprintf('inline_%dx%d_@%3.1fdcm',FieldSize(1),FieldSize(2),StartPoint(3)/10);
				if sum(FieldCenter) ~ 0; fn = [fn '_OFF']; end
				Inline(incount).name = fn;
				Inline(incount).loc = loc;
				Inline(incount).data = data;
				incount = incount+1;
			case 'Crossline'
				Crossline(crcount).energy = energy;
				Crossline(crcount).SSD = SSD;
				Crossline(crcount).FieldSize = FieldSize;
				Crossline(crcount).FieldCenter = FieldCenter;
				Crossline(crcount).RadiationType = RadiationType;
				Crossline(crcount).Quantity = Quantity;
				Crossline(crcount).StartPoint = StartPoint;
				fn = sprintf('crossline_%dx%d_@%3.1fcm',FieldSize(1),FieldSize(2),StartPoint(3)/10);
				if sum(FieldCenter) ~ 0; fn = [fn '_OFF']; end
				Crossline(crcount).name = fn;
				Crossline(crcount).loc = loc;
				Crossline(crcount).data = data;
				crcount = crcount+1;
			case 'Depth'
				PDD(pddcount).energy = energy;
				PDD(pddcount).SSD = SSD;
				PDD(pddcount).FieldSize = FieldSize;
				PDD(pddcount).FieldCenter = FieldCenter;
				PDD(pddcount).RadiationType = RadiationType;
				PDD(pddcount).Quantity = Quantity;
				PDD(pddcount).StartPoint = StartPoint;
				fn = sprintf('PDD_%dx%d',FieldSize(1),FieldSize(2));
				if sum(FieldCenter) ~ 0; fn = [fn '_OFF']; end
				PDD(pddcount).name = fn;
				PDD(pddcount).loc = loc;
				PDD(pddcount).data = data;
				pddcount = pddcount+1;
		end
		tmp = fgetl(fid);
	end
	
% 	fprintf('PROFILI INLINE: \n')
% 	for j=1:numel(Inline);
% 		try
% 			fprintf('%d) FieldSize: %dx%d Depth %d \n',j, Inline(j).FieldSize(1), Inline(j).FieldSize(2), Inline(j).StartPoint(3) )
% 		catch
% 			keyboard
% 		end
% 	end
% 	fprintf('PROFILI CROSSLINE: \n')
% 	for j=1:numel(Crossline);
% 		fprintf('%d) FieldSize: %dx%d Depth %d \n',j, Crossline(j).FieldSize(1), Crossline(j).FieldSize(2), Crossline(j).StartPoint(3) )
% 	end
% 	fprintf('PDD: \n')
% 	for j=1:numel(PDD);
% 		fprintf('%d) FieldSize: %dx%d Depth %d \n',j, PDD(j).FieldSize(1), PDD(j).FieldSize(2), PDD(j).StartPoint(3) )
% 	end
		
end
