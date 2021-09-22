function export_DICOM_sinogram(varargin)

outputfld = 'sinograms_dicom';

for vi = 1:numel(varargin)
    
    if strcmpi(varargin{vi}, 'outputfld')
        outputfld = varargin{vi+1};
    end
    
end

currfld = pwd;

inputpar = read_input_parameters();

load(fullfile(inputpar.inputfolder, 'dataset_finale_precision.mat'), 'dataset');

savefld  = inputpar.inputfolder;

if ~exist([savefld, outputfld], 'dir')
    disp('>>   Creating the following folder to store the DICOM sinograms:');
    disp(['>>      ' fullfile(savefld, outputfld)]);
    mkdir(fullfile(savefld, outputfld));
else
    disp('>>    Sinogram folder already exists. Do you want to proceed?');
    keyboard
end

for ld = 414:numel(dataset.registry)
    
    disp('**********************************************************************');
    disp(['>>   Creating dcm file for patient ', num2str(ld), ':', num2str(dataset.registry(ld).ID)]);
    mkdir(fullfile(savefld, outputfld, dataset.registry(ld).ID));
    
    % read dummy_dcmfile
    info = dicominfo(fullfile(currfld, '/database/utils/rt_struct.dcm'));
    
    % Overwrite the information
    info = overwrite_DICOM_fields(info, size(dataset.plans(ld).tomoplan.sinogram), 'CT');

    % Slice data
    SF = max(dataset.plans(ld).tomoplan.sinogram(:))/(2^10-1);
    dcmdata = uint16(dataset.plans(ld).tomoplan.sinogram/SF);

    % DICOM write
    tmpplanname = strrep(dataset.plans(ld).RTPlanName,'/','_');
    dicom_filename    = fullfile(savefld, outputfld, dataset.registry(ld).ID, ['CT.PT_' num2str(ld) '_' dataset.registry(ld).ID '_' dataset.registry(ld).BirthDate '_' tmpplanname '.dcm']);                
    rtstruct_filename = fullfile(savefld, outputfld, dataset.registry(ld).ID, ['RTSTRUCT.PT_' num2str(ld) '_' dataset.registry(ld).ID '_' dataset.registry(ld).BirthDate '_' tmpplanname '.dcm']);                
    
    info.PatientName.FamilyName = dataset.registry(ld).Surname;
    info.PatientName.GivenName  = dataset.registry(ld).Name;
    info.PatientID = dataset.registry(ld).ID;
    
    dicomwrite(dcmdata, dicom_filename, info,'CreateMode','Copy');
    
%   RT-STRUCT Creation
    export_RTSTRUCT_sinogram(dicom_filename, rtstruct_filename)
    
end

end