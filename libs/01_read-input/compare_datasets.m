tic

clear all
close all

% Check if the script is run from the T-CoMX directory
currentfld = pwd;

% Path of the TEST database

if (strcmp(currentfld(end-5:end), 'T-CoMX'))
    [inputpar, ~] = read_input_parameters();
     
    t1 = readtable(fullfile(inputpar.inputfolder, 'datasheet_precision_raccolti.xlsx'));
    t2 = readtable(fullfile(inputpar.inputfolder, 'dataset_temporaneo_precision.xlsx'), 'Sheet', 'plans');
    
    % Find the index of the data which are present in the database
    sel_idx = find(strcmpi(t1.ExportedRTPlan, 'true'));
    
    % Select only the lines of the datasheet corresponding to sel_idx
    sel_list = t1(sel_idx,:);

    not_found = struct('name', [], 'surname',[], 'planname', []);
    idx = numel(not_found);
    
    for sl = 1:length(sel_idx)
        
        name     = sel_list.Name{sl};
        surname  = sel_list.Surname{sl};
        planname = sel_list.RTPlanName{sl};
        
        disp(['>> Searching match for: ' name ' ' surname ' ' planname]);

        index = find(strcmpi(t2.Surname, surname));
        tmp1 = index;
        tmp2 = find(strcmpi(t2.Name, name));
        index = [];
        index = intersectall(tmp1,tmp2);
        tmp1 = index;
        tmp2 = find(strcmpi(t2.RTPlanName, planname));
        index = [];
        index = intersectall(tmp1,tmp2);
        
        if isempty(index)
            not_found(idx).name     = name;
            not_found(idx).surname  = surname;
            not_found(idx).planname = planname;
            idx = idx+1;
        end
        
    end

end