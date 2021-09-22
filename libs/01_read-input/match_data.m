tic

clear all
close all

% Check if the script is run from the T-CoMX directory
currentfld = pwd;

% Path of the TEST database

if (strcmp(currentfld(end-5:end), 'T-CoMX'))
	[inputpar, ~] = read_input_parameters();
	
	try
		load(fullfile(inputpar.inputfolder, 'dataset-temporaneo-precision.mat'));
		if exist('dataset','var')
			disp('>> Existing Matlab dataset found! Delete it to create a new one.');
		end
	catch
		
		t = readtable(fullfile(inputpar.inputfolder, 'datasheet-raystation-raccolti.xlsx'));
		
		% Find the index of the data which are present in the database
		sel_idx = find(strcmpi(t.ExportedRTPlan, 'true'));

		% Select only the lines of the datasheet corresponding to sel_idx
		sel_list = t(sel_idx,:);
		
		rt_paths = dir([inputpar.inputfolder '/RP*']);
		
		match_found = 0;
		
		for pp=1:numel(rt_paths)
			
			if rt_paths(pp).isdir
				fname = dir([rt_paths(pp).folder '/' rt_paths(pp).name '/*.dcm']);
				path(pp) = strcat(rt_paths(pp).folder, "/", rt_paths(pp).name, "/", fname.name);
				info = dicominfo(fullfile(fname.folder, fname.name));
			else
				info = dicominfo(fullfile(rt_paths(pp).folder, rt_paths(pp).name));
				path(pp) = strcat(rt_paths(pp).folder, "/", rt_paths(pp).name);
			end
			
			name     = info.PatientName.GivenName;
			surname  = info.PatientName.FamilyName;
			planname = info.RTPlanName;
			
			disp(['>> Searching match for: ' name ' ' surname ' ' planname]);
			
			try
				index = find(strcmpi(sel_list.Surname, surname));
                tmp1 = index;
                tmp2 = find(strcmpi(sel_list.Name, name));
                index = [];
                index = intersectall(tmp1,tmp2);
                tmp1 = index;
                tmp2 = find(strcmpi(sel_list.RTPlanName, planname));
                index = [];
                index = intersectall(tmp1,tmp2);
			catch
				keyboard
			end
			
			if length(index) == 1
				match_found = match_found + 1;
				
				% Fill the database
				registry(pp).ID        = info.PatientID;
				registry(pp).Name      = name;
				registry(pp).Surname   = surname;
				registry(pp).BirthDate = info.PatientBirthDate;
				registry(pp).Sex       = info.PatientSex;
				
				plans(pp).RTPlanName   = planname;
				
                try
                    plans(pp).DoseFractionCGy  = (sel_list.Dose_fr_cGy(index));
                catch
                end
                
                try
                    plans(pp).Site  = sel_list.Site(index);
                catch
                end
                
                try
                    plans(pp).AvoidanceSector = sel_list.AvoidanceSector(index);
                catch
                end
                
                try
                    plans(pp).TPS = sel_list.TPS(index);
                catch
                end
                
                try
                    plans(pp).BeamRevisionNumber = sel_list.BeamRevisionNumber(index);
                catch
                end
                    
                try
                    plans(pp).ACPlug = sel_list.ACPlug(index);
                catch
				end
                
				tomoplan = tomo_read_RTplan(path(pp));
				
				plans(pp).tomoplan = tomoplan;
				
				gamma(pp).local22  = sel_list.Gamma_22_local(index);
				gamma(pp).global22 = sel_list.Gamma_22_global(index);
				gamma(pp).local33  = sel_list.Gamma_33_local(index);
				gamma(pp).global33 = sel_list.Gamma_33_global(index);
				gamma(pp).local32  = sel_list.Gamma_32_local(index);
				gamma(pp).global32 = sel_list.Gamma_32_global(index);
				
			elseif isempty(index)
				disp(['>>	No match found for ' name ' ' surname ' ' planname]);
			end
		end
		
		disp(['>>	End of the execution. Matches found: ' num2str(match_found) '/' num2str(length(rt_paths)) '.']);
		toc
		dataset.path     = path.';
		dataset.registry = registry;
		dataset.plans    = plans;
		dataset.gamma    = gamma;
		
		save(fullfile(inputpar.inputfolder, "dataset-temporaneo-precision+raystation"), 'dataset');
		
		clear registry plans gamma path
	end
	
else
	disp("You are not in the T-CoMX directory. Move there to execute the script!");
end
