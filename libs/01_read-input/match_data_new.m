tic

clear all
close all

% Check if the script is run from the T-CoMX directory
currentfld = pwd;

% Path of the TEST database

if (strcmp(currentfld(end-5:end), 'T-CoMX'))
    [inputpar, ~] = read_input_parameters();
    
    try
        load(fullfile(inputpar.inputfolder, 'dataset2.mat'));
        if exist('dataset','var')
            disp('>> Existing Matlab dataset found! Delete it to create a new one.');
        end
        
    catch
        
        t = readtable(fullfile(inputpar.inputfolder, 'datasheet-raystation-mancanti.xlsx'));
        
        try
            load(fullfile(inputpar.inputfolder, 'dataset_temporaneo_precision+raystation.mat'));
            ex_dataset = 1;
        catch
            disp('No existing dataset found. New dataset will be created at the end of the execution.');
            ex_dataset = 0;
        end
        
        
        % Find the index of the data which are present in the database
        sel_idx = find(strcmpi(t.ExportedRTPlan, 'true'));
        
        % Select only the lines of the datasheet corresponding to sel_idx
        sel_list = t(sel_idx,:);
        
        try
            rt_paths = dir([inputpar.inputfolder '/DCM*']);
        catch
            rt_paths = dir([inputpar.inputfolder '/RP*']);
        end
        
        tmppathnames = {rt_paths.name};
        tmppathnames = cellfun(@(x) x(1:end-12), tmppathnames, 'UniformOutput', false);
        [~, uniqueidx] = unique(tmppathnames);
        
        rt_paths = rt_paths(uniqueidx);
        
        new_match_found = 0;
        ex_match_found  = 0;
        match_not_found = 0;
        
        maxiter = numel(rt_paths);
        
        for pp=1:maxiter
            
            if rt_paths(pp).isdir
                fname = dir([rt_paths(pp).folder '/' rt_paths(pp).name '/*.dcm']);
                info = dicominfo(fullfile(fname.folder, fname.name));
            else
                info = dicominfo(fullfile(rt_paths(pp).folder, rt_paths(pp).name));
                path(pp) = strcat(rt_paths(pp).folder, "/", rt_paths(pp).name);
            end
            
            
            name     = info.PatientName.GivenName;
            surname  = info.PatientName.FamilyName;
            planname = info.RTPlanName;
                        
            disp(['>> Searching match for: ' name ' ' surname ' ' planname]);
          
            % Check whether the plan has already been added to the dataset
            if ex_dataset == 1
                index = find(strcmpi({dataset.registry.Surname}, surname));
                tmp1 = index;
                tmp2 = find(strcmpi({dataset.registry.Name}, name));
                index = [];
                index = intersectall(tmp1,tmp2);
                tmp1 = index;
                tmp2 = find(strcmpi({dataset.plans.RTPlanName}, planname));
                index = [];
                index = intersectall(tmp1,tmp2);          
            else
                index = [];
            end
            
            if ~isempty(index)
                disp('     Patient already present in the dataset!')
                path(pp) = "";
                ex_match_found = ex_match_found + 1;
            else
                
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
                
                if length(index)>1
                    
                    disp(['     Multiple match found in the datasheet for: ' name ' ' surname ' ' planname]);
                    multiple_match(pp).name = name;
                    multiple_match(pp).surname = surname;
                    multiple_match(pp).RTPlanName = planname;
                
                elseif length(index) == 1
                    
                    new_match_found = new_match_found + 1;
                    
                    if rt_paths(pp).isdir
                        path(pp) = strcat(rt_paths(pp).name, "/", fname.name);
                    else
                        path(pp) = rt_paths(pp).name;
                    end
                    
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
                        if strcmpi(info.ManufacturerModelName, 'RayStation')
                            plans(pp).BeamRevisionNumber = str2double(char(info.BeamSequence.Item_1.Private_4001_1026));
                        else
                            plans(pp).BeamRevisionNumber = sel_list.BeamRevisionNumber(index);
                        end
                    catch
                    end

                    try
                        plans(pp).ACPlug = sel_list.ACPlug(index);
                    catch
                    end

                    tomoplan = tomo_read_RTplan(fullfile(inputpar.inputfolder, path(pp)));

                    plans(pp).tomoplan = tomoplan;
                    
                    StudyDate  = str2num(info.StudyDate);
                    RTPlanDate = str2num(info.RTPlanDate);
        
                    plans(pp).StudyDate  =  str2num(info.StudyDate);
                    plans(pp).RTPlanDate = str2num(info.RTPlanDate);
                    
                    gamma(pp).local22  = sel_list.Gamma_22_local(index);
                    gamma(pp).global22 = sel_list.Gamma_22_global(index);
                    gamma(pp).local33  = sel_list.Gamma_33_local(index);
                    gamma(pp).global33 = sel_list.Gamma_33_global(index);
                    gamma(pp).local32  = sel_list.Gamma_32_local(index);
                    gamma(pp).global32 = sel_list.Gamma_32_global(index);

                elseif isempty(index)
                    disp(['>>	No match found for ' name ' ' surname ' ' planname]);
                    
                    path(pp) = "";
                    
                    not_found(pp).Name       = name;
                    not_found(pp).Surname    = surname;
                    not_found(pp).RTPlanName = planname;
                    
                    match_not_found = match_not_found + 1;
                    
                end
            end
        end
        
        disp(' ');
        disp(['End of the execution.']);
        toc
        disp(['-----------------------------------------------------------------------']);
        disp(['        New matches found: ' num2str(new_match_found)]);
        disp(['        Matches not found: ' num2str(match_not_found)]);
        disp(['        Existing matches found: ' num2str(ex_match_found)]);
        disp(['        Number of dcm files analyzed : ' num2str(maxiter)]);
        disp(['        Number of dcm files in the folder : ' num2str(length(rt_paths))]);
        disp(['        Number of patient expected : ' num2str(length(sel_idx))]);
        disp('-----------------------------------------------------------------------');
    
        if new_match_found >= 1
            
            path( all( cell2mat( arrayfun( @(x) structfun( @isempty, x ), registry, 'UniformOutput', false ) ), 1 )) = [];
            registry( all( cell2mat( arrayfun( @(x) structfun( @isempty, x ), registry, 'UniformOutput', false ) ), 1 ) ) = [];
            plans( all( cell2mat( arrayfun( @(x) structfun( @isempty, x ), plans, 'UniformOutput', false ) ), 1 ) ) = [];
            gamma( all( cell2mat( arrayfun( @(x) structfun( @isempty, x ), gamma, 'UniformOutput', false ) ), 1 ) ) = [];
            path = path(~strcmp(path,""));
            
            if ex_dataset == 1
                dataset.path     = [dataset.path; path.'];
                dataset.registry = [dataset.registry registry];
                dataset.plans    = [dataset.plans plans];
                dataset.gamma    = [dataset.gamma gamma];
            elseif ex_dataset == 0
                dataset.path     = path.';
                dataset.registry = registry;
                dataset.plans    = plans;
                dataset.gamma   = gamma;
            end    
        end
        
        if match_not_found >= 1
            not_found( all( cell2mat( arrayfun( @(x) structfun( @isempty, x ), not_found, 'UniformOutput', false ) ), 1 ) ) = [];
        end
        
        save(fullfile(inputpar.inputfolder, "dataset_temporaneo_precision+raystation"), 'dataset');
        
%         clear registry plans gamma path
    end
    
else
    disp("You are not in the T-CoMX directory. Move there to execute the script!");
end
