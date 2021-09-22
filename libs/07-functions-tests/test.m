% path = 'C:\Users\Samuele\OneDrive - Università degli Studi di Padova\IOV\materiale-MATLAB\T-CoMX\RTplans\Analisi_TOMO\Planned_Precision';
% name = 'RP.Plan5_10mm_Fixed_rev5.dcm';

path = 'C:\Users\Samuele\OneDrive - Università degli Studi di Padova\IOV\materiale-MATLAB\T-CoMX\RTplans\Analisi_TOMO\Planned_RayStation';
name = 'RP.Plan5_50mm_rev5.dcm';

%   path = 'C:\Users\Samuele\OneDrive - Università degli Studi di Padova\IOV\materiale-MATLAB\T-CoMX\RTplans\RS_3'
% name = 'RP3Rounded.dcm'

info  = dicominfo(fullfile(path, name));
tplan = tomo_read_RTplan(fullfile(path, name));

% tlp = info.PatientSetupSequence.Item_1.Private_4001_1022;
% % fj = info.BeamSequence.Item_1.Private_4001_1028;
% tmp = char(tlp');
% tmp = strsplit(tmp, '\');
% tlp = str2double(tmp);
% % tmp = char(fj');
% % tmp = strsplit(tmp, '\');
% % fj = str2double(tmp);
% 
% disp(['Intended bj position ', num2str(bj), '; intended fj position ', num2str(fj)]);

% csvname = 'RS_3.csv';
% csvsinogram = dlmread(fullfile(path,csvname));
% csvsinogram = csvsinogram(2:end, 1:64);
% 
% % Look at the difference
% difference = round(tplan.sinogram) - round(csvsinogram);
% figure;
% im = image(difference);
% im.CDataMapping = 'scaled';
% colorbar;

% figure;
% h = histogram(difference(:));