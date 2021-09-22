function info = overwrite_DICOM_fields(info, s, modality)

% anonimize dcmfile
info.Filename  = [];
info.StudyDate = [];
info.StudyTime = [];
info.PatientID = [];
info.PatientName.GivenName = [];
info.PatientName.MiddleName = [];
info.PatientName.FamilyName = [];
info.PatientBirthDate = [];
info.PatientSex = [];
info.StudyID = '';
info.SeriesDate = [];
info.AcquisitionDate = [];
info.ContentDate = [];
info.AcquisitionDateTime = [];
info.StudyTime = [];
info.SeriesTime = [];
info.AcquisitionTime = [];
info.ContentTime = [];
info.InstitutionName = [];
info.InstitutionAddress = [];
info.ReferringPhysicianName = [];
info.StationName = [];
info.StudyDescription = [];
info.SeriesDescription = [];
info.ManufacturerModelName = [];

info.Manufacturer = 'V-CoMX';
info.ConversionType = '';
info.SoftwareVersions = '01';


% Specifico la modalità
info.Modality = modality; %'MR' %'CT'
if strcmp(modality, 'MR')
    info.SOPClassUID = '1.2.840.10008.5.1.4.1.1.4'; 
    info.MediaStorageSOPClassUID = '1.2.840.10008.5.1.4.1.1.4'; 
elseif strcmp(modality, 'CT')
    info.SOPClassUID = '1.2.840.10008.5.1.4.1.1.2'; 
    info.MediaStorageSOPClassUID = '1.2.840.10008.5.1.4.1.1.2'; 
    
% intercetta e slope
info.RescaleIntercept = 0;
info.RescaleSlope = 1; %SF;

% fill dicom info with relevant infos from fluence map
info.Rows = s(1);
info.Columns = s(2);
info.Width = s(2);
info.Height = s(1);
info.PixelSpacing = [0.5 0.5];
info.ImagePositionPatient = [0 0 0];
info.SliceLocation = 0;
info.SliceThickness = 1;
info.ImageOrientationPatient = [1 0 0 0 1 0];

% dicomUID stuff
info = my_rt_unique_metadata(info, 'true');
info.StudyInstanceUID = dicomuid;
info.SeriesInstanceUID = dicomuid;
SOPInstanceUID = dicomuid;
info.SOPInstanceUID = SOPInstanceUID;
info.MediaStorageSOPInstanceUID = SOPInstanceUID;
info.FrameOfReferenceUID = dicomuid;

end


