clear all
close all

% Check if the script is run from the T-CoMX directory
currentfld = pwd;

% Path of the TEST database

if (strcmp(currentfld(end-5:end), 'T-CoMX'))
    [inputpar, ~] = read_input_parameters();
        
    rt_paths = dir([inputpar.inputfolder '/DCM*']);

    maxiter = numel(rt_paths);
    
    for pp=1:maxiter
        
        if rt_paths(pp).isdir
            fname = dir([rt_paths(pp).folder '/' rt_paths(pp).name '/*.dcm']);
            info = dicominfo(fullfile(fname.folder, fname.name));
        else
            info = dicominfo(fullfile(rt_paths(pp).folder, rt_paths(pp).name));
        end
        
        patient(pp).name     = info.PatientName.GivenName;
        patient(pp).surname  = info.PatientName.FamilyName;
        patient(pp).planname = info.RTPlanName;
        
        disp(['>> New patient: ' patient(pp).name ' ' patient(pp).surname ' '  patient(pp).planname]);
    end
end