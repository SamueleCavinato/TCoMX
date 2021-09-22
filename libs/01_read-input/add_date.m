clear all
close all

% Check if the script is run from the T-CoMX directory
currentfld = pwd;

% Path of the TEST database

if (strcmp(currentfld(end-5:end), 'T-CoMX'))
    [inputpar, ~] = read_input_parameters();
          
    load(fullfile(inputpar.inputfolder, 'dataset1.mat'));
    ex_dataset = 1;
    
    for dt = 1:numel(dataset.registry)
        disp(['>>    Processing patient: ', dataset.registry(dt).ID]);
        
        info = dicominfo(dataset.path(dt));
        
        StudyDate  = str2num(info.StudyDate);
        RTPlanDate = str2num(info.RTPlanDate);
        
        dataset.plans(dt).StudyDate  = StudyDate;
        dataset.plans(dt).RTPlanDate = RTPlanDate;
        
    end
    
    save(fullfile(inputpar.inputfolder, "dataset1"), 'dataset');
    
else
    disp("You are not in the T-CoMX directory. Move there to execute the script!");
end
