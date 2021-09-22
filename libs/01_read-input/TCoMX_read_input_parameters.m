function [inputpar,fldcode] = TCoMX_read_input_parameters()

%%%%%%%%%%%%%%%% READ THE INPUT PARAMETER FROM THE INPUT SHEET %%%%%%%%%%%%
inputpar = struct('inputfolder', '', ...
                  'resultsfolder', '');


f1 = fopen('PATH_TO_TCoMX_FOLDER.in');
PATH_TO_TCoMX_FOLDER = textscan(f1, '%s', 'Delimiter', '\n');
fclose(f1);

clear f1

fid       = fopen(fullfile(string(PATH_TO_TCoMX_FOLDER), 'database', 'input', 'CONFIG.in'), 'r');
inputdata = textscan(fid, '%s', 'Delimiter', '\n');
fclose(fid);

clear fid;

idx = find(contains(upper(inputdata{1,1}), "ID NAME"));
if ~isempty(idx)
	fldcode   = cell2mat(inputdata{1,1}(idx+1));
end

idx = find(contains(upper(inputdata{1,1}), "INPUT FOLDER"));
if ~isempty(idx)
	inputpar.inputfolder   = cell2mat(inputdata{1,1}(idx+1));
end

idx = find(contains(upper(inputdata{1,1}), "OUTPUT FOLDER"));
if ~isempty(idx)
	inputpar.resultsfolder   = cell2mat(inputdata{1,1}(idx+1));
end

inputpar.PATH_TO_TCoMX_FOLDER = string(PATH_TO_TCoMX_FOLDER);

end

