% Check if the script is run from the T-CoMX directory
clear all
close all
clc

currentfld = pwd;

[inputpar,fldcode] = TCoMX_read_input_parameters();

% Look for an existing dataset created using match_data

% AGGIUNGERE LA POSSIBILITA' DI ESTRARRE IL FILE DALLE SOTTOCARTELLE.
% QUESTO È IMPORTANTE PERCHÉ PRECISION SALVA I DATI IN SOTTOCARTELLE

plans = dir(fullfile(inputpar.inputfolder, '/*.dcm'));
nplans = numel(plans);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ------------------------------------------------------------------- %

%%%%%%%%%%%%%%%%%% READ THE LIST OF METRICS TO COMPUTE %%%%%%%%%%%%%%%%
METRICS_LIST = TCoMX_READ_METRICS;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear fid inputdata;

%%%%%%%%%%%% CREATE OUTPUT FOLDER TO STORE THE RESULTS %%%%%%%%%%%%%%%%
if ~exist('fldcode', 'var')
    fldcode = regexprep(num2str(clock), ' ', '');
else
    id = size(dir([inputpar.resultsfolder '/*' fldcode '*']),1);
    tmpid = regexprep(num2str(clock), ' ', '');
    mkdir([inputpar.resultsfolder '/' num2str(id) '-' fldcode '-' tmpid]);
    savefld = [inputpar.resultsfolder '/' num2str(id) '-' fldcode '-' tmpid];
end

clear id
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ------------------------------------------------------------------- %

%%%%%%%%%%%%%%%%%%%%%%% METRICS EXTRACTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Iterate over the plans
parfor planidx=1:nplans
    
    
    disp(['>>   Reading: '  fullfile(plans(planidx).folder, plans(planidx).name)]);
    
    tomoplan = TCoMX_read_RTplan(fullfile(plans(planidx).folder, plans(planidx).name));
    
    % -----------------------------------------------------------------
    
    patients(planidx).patient = TCoMX_COMPUTE_METRICS(tomoplan, METRICS_LIST);
    
    % -----------------------------------------------------------------
    % Pitch, FW, PT, GP, TT, TL, CS, CT
    % -----------------------------------------------------------------
    patients(planidx).patient.machine.plan_parameters.Pitch   = tomoplan.NominalPitch;
    patients(planidx).patient.machine.plan_parameters.FieldWidth = tomoplan.NominalFieldWidth;
    patients(planidx).patient.machine.plan_parameters.ProjectionTime = tomoplan.ProjectionTime;
    patients(planidx).patient.machine.plan_parameters.GantryPeriod = tomoplan.GantryPeriod;
    patients(planidx).patient.machine.plan_parameters.TreatmentTime = tomoplan.TreatmentTime;
    patients(planidx).patient.machine.plan_parameters.TargetLength = tomoplan.TargetLength;
    patients(planidx).patient.machine.plan_parameters.CouchSpeed = tomoplan.CouchSpeed;
    patients(planidx).patient.machine.plan_parameters.CouchTranslation = tomoplan.CouchTranslation;
    patients(planidx).patient.machine.plan_parameters.NProjections = tomoplan.NCP-1;
    patients(planidx).patient.machine.plan_parameters.NRotations = tomoplan.NRotations;
    patients(planidx).patient.machine.plan_parameters.NProjectionsPeriod = tomoplan.NProjectionsPeriod;
    
    info(planidx).Folder = plans(planidx).folder;
    info(planidx).Filename   = plans(planidx).name;
    info(planidx).ID = tomoplan.PatientID;
    info(planidx).Name = tomoplan.PatientName.GivenName;
    info(planidx).Surname = tomoplan.PatientName.FamilyName;
    info(planidx).BirthDate = tomoplan.PatientBirthDate;
    info(planidx).Sex = tomoplan.PatientSex;
    info(planidx).RTPlanName = tomoplan.OriginalPlanName;
    info(planidx).RTPlanDate = tomoplan.RTPlanDate;
    info(planidx).TPS = tomoplan.TPS;
    
end

metrics_table = TCoMX_export_metrics_table(patients);

dataset.info = struct2table(info);
dataset.metrics = metrics_table;

metrics_statistics = TCoMX_COMPUTE_STATISTICS(metrics_table);

dataset.metrics_statistics = metrics_statistics;

save(fullfile(savefld, 'dataset'), 'dataset');
writetable(struct2table(info), fullfile(savefld, 'dataset.xlsx'), 'Sheet', 'info');
writetable(metrics_table, fullfile(savefld, 'dataset.xlsx'), 'Sheet', 'metrics');
writetable(metrics_statistics, fullfile(savefld, 'dataset.xlsx'), 'Sheet', 'statistics');

logfile = fopen(fullfile(savefld, 'logfile.txt'), 'w');
fprintf(logfile, '%s\n%s\n%s\n%s\n%s\n%s\n%s\n%i\n%s\n%i', ....
    'Execution ID: ', num2str(tmpid), ...
    'Input folder: ', inputpar.inputfolder, ...
    'Results folder: ', savefld, ...
    'Number of metrics computed:', size(metrics_table,2),...
    'Number of plans analyzed:',nplans);

fclose(logfile);

copyfile(fullfile(inputpar.PATH_TO_TCoMX_FOLDER, 'database/input/CONFIG.in'), savefld);
copyfile(fullfile(inputpar.PATH_TO_TCoMX_FOLDER, 'database/input/METRICS.in'), savefld);

clear logfile status

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

