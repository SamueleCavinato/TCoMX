% Check if the script is run from the T-CoMX directory
clear all
close all
clc

disp('    TCoMX');

[inputpar,fldcode] = TCoMX_read_input_parameters();

% Look for an existing dataset created using match_data

% AGGIUNTA LA POSSIBILITA' DI ESTRARRE IL FILE DALLE SOTTOCARTELLE.
% QUESTO È IMPORTANTE PERCHÉ PRECISION SALVA I DATI IN SOTTOCARTELLE
% AGGIUNTA LA POSSIBILITA' DI LEGGERE I NOMI DEI PIANI DA UNA LISTA. LA
% LISTA DEVE CONTENERE IL PATH ASSOLUTO AL PIANO, COMPRESO IL NOME DEL
% PIANO

if strcmpi(inputpar.read_from_file, "False")
    disp('    >> Reading the list of plans in the folder...');

    plans = dir(fullfile(inputpar.inputfolder));
    plans = plans(~ismember({plans.name},{'.','..'}));
    nplans = numel(plans);

    disp('        ...done.');

else
    disp('    >> Reading the list of plans from file..');
    plans = readtable(fullfile(inputpar.inputfolder, inputpar.list_file_name));
    nplans = size(plans,1);
    disp('        ...done');
end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ------------------------------------------------------------------- %

disp('    >> Searching the DoseFraction file...');

%%%%%%%%%%%%%%%%%% READ THE LIST OF METRICS TO COMPUTE %%%%%%%%%%%%%%%%
try 
    DoseFraction = readtable(fullfile(inputpar.inputfolder, 'DoseFraction.xlsx'));
    disp('        ...done.');
catch
    disp('        ...not found');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('    >> Reading the list of metrics to compute...');

%%%%%%%%%%%%%%%%%% READ THE LIST OF METRICS TO COMPUTE %%%%%%%%%%%%%%%%
METRICS_LIST = TCoMX_READ_METRICS;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('        ...done.');
clear fid inputdata;

%%%%%%%%%%%% CREATE OUTPUT FOLDER TO STORE THE RESULTS %%%%%%%%%%%%%%%%
if ~exist('fldcode', 'var')
    fldcode = regexprep(num2str(clock), ' ', '');
else
    id = size(dir(fullfile(inputpar.resultsfolder, ['*' fldcode '*'])),1);
    tmpid = regexprep(num2str(clock), ' ', '');
    mkdir(fullfile(inputpar.resultsfolder, [num2str(id) '-' fldcode '-' tmpid]));
    savefld = fullfile(inputpar.resultsfolder, [num2str(id) '-' fldcode '-' tmpid]);
end

clear id
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ------------------------------------------------------------------- %

%%%%%%%%%%%%%%%%%%%%%%% METRICS EXTRACTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('    >> Extracting the metrics...')

datasetidx = 1;

% Iterate over the plans
for planidx = 1:nplans
    
    listofplans     = [];
    
    if strcmpi(inputpar.read_from_file, "False")
    
        if plans(planidx).isdir == 1
            listofplans = dir(fullfile(plans(planidx).folder, plans(planidx).name, '*'));
        elseif plans(planidx).isdir == 0
            listofplans(1).folder = plans(planidx).folder;
            listofplans(1).name   = plans(planidx).name;
        end
        
    elseif strcmpi(inputpar.read_from_file, "True")
        listofplans(1).folder = convertStringsToChars(string(plans.folder(planidx)));
        listofplans(1).name = convertStringsToChars(string(plans.name(planidx)));
    end

    for lopidx = 1:numel(listofplans)
              
        if exist('DoseFraction', 'var')
            df_idx = find(contains(DoseFraction.filename, listofplans(lopidx).name, 'IgnoreCase', true));
        end
        
        if exist('df_idx','var')
            tomoplan = TCoMX_read_RTplan(fullfile(listofplans(lopidx).folder, listofplans(lopidx).name), 'DoseFraction', DoseFraction{df_idx,2});            
        else
            tomoplan = TCoMX_read_RTplan(fullfile(listofplans(lopidx).folder, listofplans(lopidx).name));
        end
        
        if ~isempty(tomoplan)
            
            disp(['        Reading: '  fullfile(listofplans(lopidx).folder, listofplans(lopidx).name)]);
               
            % -----------------------------------------------------------------

            patients(datasetidx).patient = TCoMX_COMPUTE_METRICS(tomoplan, METRICS_LIST);

               % -----------------------------------------------------------------
            % Pitch, FW, PT, GP, TT, TL, CS, CT
            % -----------------------------------------------------------------
            patients(datasetidx).patient.TPS.delivery.Pitch   = tomoplan.NominalPitch;
            patients(datasetidx).patient.TPS.delivery.FieldWidth = tomoplan.NominalFieldWidth;
            patients(datasetidx).patient.TPS.delivery.ProjectionTime = tomoplan.ProjectionTime;
            patients(datasetidx).patient.TPS.delivery.GantryPeriod = tomoplan.GantryPeriod;
            patients(datasetidx).patient.TPS.delivery.TreatmentTime = tomoplan.TreatmentTime;
            patients(datasetidx).patient.TPS.delivery.TargetLength = tomoplan.TargetLength;
            patients(datasetidx).patient.TPS.delivery.CouchSpeed = tomoplan.CouchSpeed;
            patients(datasetidx).patient.TPS.delivery.CouchTranslation = tomoplan.CouchTranslation;
            patients(datasetidx).patient.TPS.delivery.NProjections = tomoplan.NCP-1;
            patients(datasetidx).patient.TPS.delivery.NRotations = tomoplan.NRotations;
            patients(datasetidx).patient.TPS.delivery.NProjectionsPeriod = tomoplan.NProjectionsPeriod;
            patients(datasetidx).patient.TPS.delivery.MF = max(tomoplan.sinogram(:))/(mean(nonzeros(tomoplan.sinogram(:))));
            
            try
                patients(datasetidx).patient.TPS.delivery.TTDF = tomoplan.TTDF;
            catch
                patients(datasetidx).patient.TPS.delivery.TTDF = NaN;
            end
            
            info(datasetidx).Folder = listofplans(lopidx).folder;
            info(datasetidx).Filename   = listofplans(lopidx).name;
            info(datasetidx).ID = tomoplan.PatientID;
            info(datasetidx).Name = tomoplan.PatientName.GivenName;
            info(datasetidx).Surname = tomoplan.PatientName.FamilyName;
            info(datasetidx).BirthDate = tomoplan.PatientBirthDate;
            info(datasetidx).Sex = tomoplan.PatientSex;
            info(datasetidx).RTPlanName = tomoplan.OriginalPlanName;
            info(datasetidx).RTPlanDate = tomoplan.RTPlanDate;
            info(datasetidx).TPS = tomoplan.TPS;

            datasetidx = datasetidx + 1;
            
        end
        
    end
        
end

disp('         ...done.');

disp('    >> Saving results');
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
    'Number of plans analyzed:',size(metrics_table,1));

fclose(logfile);

copyfile(fullfile(inputpar.PATH_TO_TCoMX_FOLDER, 'input', 'CONFIG.in'), savefld);
copyfile(fullfile(inputpar.PATH_TO_TCoMX_FOLDER, 'input', 'METRICS.in'), savefld);

clear logfile status

disp('        ...done.');
disp('    END');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

