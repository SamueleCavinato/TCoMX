clear all
close all

load('/home/samu/Documenti/FS/M0.matlab_common/T-CoMX_v2/database/utils/dataset_debug.mat');

tomoplan = dataset.plans(1).tomoplan;

METRICS_LIST = TCoMX_READ_METRICS;

%% MFcalc
patient = eval('MFcalc(tomoplan, METRICS_LIST)');

%% LOT distribution
patient = eval('LOTstats(tomoplan, METRICS_LIST)');

%% 
for planidx=1:1

    metidx = 1;

    disp(['>>   Reading: '  convertStringsToChars(dataset.path(planidx))]);

    % tomo_read_RTplan legge i piani DICOM tomo e costruisce una struttura con le info fondamentali

    tomoplan = dataset.plans(planidx).tomoplan;

    patients(planidx).patient = TCoMX_COMPUTE_METRICS(tomoplan, METRICS_LIST);

end