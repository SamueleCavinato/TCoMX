function export_RTSTRUCT_sinogram(dcm_filename, rtstruct_filename)

currfld = pwd;

rt_info = dicominfo(fullfile(currfld, '/database/utils/rt_struct.dcm'));

img = dicominfo(dcm_filename);

% ROI
% DATI PAZIENTE E IMMAGINE
rt_info.PatientID               = img.PatientID;
rt_info.PatientName             = img.PatientName;
rt_info.Width                   = img.Width;
rt_info.Height                  = img.Height;
rt_info.PixelSpacing            = img.PixelSpacing;
rt_info.ImagePositionPatient    = img.ImagePositionPatient;
rt_info.ImageOrientationPatient = img.ImageOrientationPatient;
rt_info.SliceLocation           = img.SliceLocation;
%rt_info.ReferringPhysicianName = info.ReferringPhysicianName;

% UID
rt_info.StudyInstanceUID           = img.StudyInstanceUID;
rt_info.SeriesInstanceUID          = img.SeriesInstanceUID;             %info.SeriesInstanceUID;
rt_info.SOPInstanceUID             = img.SOPInstanceUID;                %info.SOPInstanceUID;
rt_info.MediaStorageSOPInstanceUID = img.MediaStorageSOPInstanceUID;    %info.MediaStorageSOPInstanceUID;
rt_info.FrameOfReferenceUID        = img.FrameOfReferenceUID;
rt_info.ImplementationClassUID     = img.ImplementationClassUID;
rt_info.Manufacturer               = img.Manufacturer;
rt_info.ConversionType             = img.ConversionType;
%rt_info.SoftwareVersions           = img.SoftwareVersions';
%rt_info = my_rt_unique_metadata(rt_info, 'false');

% Modalità
rt_info.Modality                = 'RTSTRUCT';
rt_info.SOPClassUID             = '1.2.840.10008.5.1.4.1.1.481.3';  % Class RT-STRUCT
rt_info.MediaStorageSOPClassUID = '1.2.840.10008.5.1.4.1.1.481.3';  % Class RT-STRUCT

% REFERENCED STUDY SEQUENCE
rt_info.StructureSetLabel = 'AutoSS';
rt_info.StructureSetName  = 'AutoSS';
rt_info.StructureSetDate  = [];
rt_info.StructureSetTime  = [];

rt_info.ReferencedFrameOfReferenceSequence.Item_1.FrameOfReferenceUID = img.FrameOfReferenceUID;
rt_info.ReferencedFrameOfReferenceSequence.Item_1.RTReferencedStudySequence.Item_1.ReferencedSOPClassUID = img.SOPClassUID;
rt_info.ReferencedFrameOfReferenceSequence.Item_1.RTReferencedStudySequence.Item_1.ReferencedSOPInstanceUID = img.SOPInstanceUID;
rt_info.ReferencedFrameOfReferenceSequence.Item_1.RTReferencedStudySequence.Item_1.RTReferencedSeriesSequence.Item_1.SeriesInstanceUID = img.SeriesInstanceUID; 
rt_info.ReferencedFrameOfReferenceSequence.Item_1.RTReferencedStudySequence.Item_1.RTReferencedSeriesSequence.Item_1.ContourImageSequence.Item_1.ReferencedSOPClassUID    = img.SOPClassUID;
rt_info.ReferencedFrameOfReferenceSequence.Item_1.RTReferencedStudySequence.Item_1.RTReferencedSeriesSequence.Item_1.ContourImageSequence.Item_1.ReferencedSOPInstanceUID = img.SOPInstanceUID;

rt_info.ROIContourSequence.Item_1.ContourSequence.Item_1.ContourImageSequence.Item_1.ReferencedSOPClassUID = img.SOPClassUID;
rt_info.ROIContourSequence.Item_1.ContourSequence.Item_1.ContourImageSequence.Item_1.ReferencedSOPInstanceUID  = img.SOPInstanceUID;

% CREO SEGMENTAZIONE
offset = img.ImagePositionPatient;
scale  = img.PixelSpacing;

x_grid = (double(0:(img.Columns-1))*scale(1)-offset(1));
y_grid = (double(0:(img.Rows-1))*scale(2)-offset(2));

erosion    = 0.1;
up_left    = [max(x_grid)-erosion max(y_grid)-erosion img.SliceLocation];
up_rigth   = [min(x_grid)+erosion max(y_grid)-erosion img.SliceLocation];
down_right = [min(x_grid)+erosion min(y_grid)+erosion img.SliceLocation];
down_left  = [max(x_grid)-erosion min(y_grid)+erosion img.SliceLocation];

new_contour = [up_left up_rigth down_right down_left up_left]';

rt_info.ROIContourSequence.Item_1.ContourSequence.Item_1.ContourData = new_contour;
rt_info.ROIContourSequence.Item_1.ContourSequence.Item_1.NumberOfContourPoints = 5;

% figure
% x = rt_info.ROIContourSequence.Item_1.ContourSequence.Item_1.ContourData(1:3:end)';
% y = rt_info.ROIContourSequence.Item_1.ContourSequence.Item_1.ContourData(2:3:end)';
% z = rt_info.ROIContourSequence.Item_1.ContourSequence.Item_1.ContourData(3:3:end)';
% col = (1:length(x));
% surface([x;x],[y;y], [z;z],[col;col],'facecol','no','edgecol','interp','linew',2);
% axis equal

dicomwrite(1, [], rtstruct_filename, rt_info, 'CreateMode', 'copy');
