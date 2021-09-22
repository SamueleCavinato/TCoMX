function out = my_rt_unique_metadata(metadata, flag)
% rt_info.StudyInstanceUID = img.StudyInstanceUID;
% rt_info.SeriesInstanceUID = dicomuid;                   %img.SeriesInstanceUID;
% SOPInstanceUID = dicomuid;
% rt_info.SOPInstanceUID = SOPInstanceUID;                %img.SOPInstanceUID;
% rt_info.MediaStorageSOPInstanceUID = SOPInstanceUID;    %img.MediaStorageSOPInstanceUID;
% rt_info.FrameOfReferenceUID = [];

dictionary = dicomdict('get_current');

% Make new UIDs for attributes that must be different than the input.
SOPInstanceUID = dicomuid;
StudyUID = dicomuid;
SeriesUID = dicomuid;
FrameUID = dicomuid;
SyncUID = dicomuid;
SrUID = dicomuid;

metadata = my_changeAttr(metadata, '0008', '0018', SOPInstanceUID, dictionary);
metadata = my_changeAttr(metadata, '0008', '1155', SOPInstanceUID, dictionary);
if flag
	metadata = my_changeAttr(metadata, '0020', '000D', StudyUID, dictionary);
    metadata = my_changeAttr(metadata, '0020', '0010', StudyUID, dictionary);
    
    metadata = my_changeAttr(metadata, '0020', '0052', FrameUID, dictionary);
    metadata = my_changeAttr(metadata, '3006', '0024', FrameUID, dictionary);
    metadata = my_changeAttr(metadata, '3006', '00C2', FrameUID, dictionary);
end
metadata = my_changeAttr(metadata, '0020', '000E', SeriesUID, dictionary);
metadata = my_changeAttr(metadata, '0020', '0200', SyncUID, dictionary);
metadata = my_changeAttr(metadata, '0040', 'A124', SrUID, dictionary);


out = metadata;

function metadata = my_changeAttr(metadata, group, element, newValue, dictionary)
%my_changeAttr  Update an attribute's value.

name = dicom_name_lookup(group, element, dictionary);

if ((~isempty(name)) && (isfield(metadata, name)))
    metadata.(name) = newValue;
end

function name = dicom_name_lookup(groupStr, elementStr, dictionary)
%DICOM_NAME_LOOKUP   Get an attribute's from the DICOM data dictionary.
%   NAME = DICOM_NAME_LOOKUP(GROUP, ELEMENT, DICTIONARY) returns the NAME
%   of the DICOM attribute with the GROUP and ELEMENT specified as strings.
%
%   The purpose of this function is to avoid hardcoding mutable attribute
%   names into access and modification functions.
%
%   Example:
%      dicom_name_lookup('7fe0','0010', dictionary) returns 'PixelData'
%      (provided that its name is PixelData in the data dictionary).
%
%   See also DICOM_DICT_LOOKUP, DICOM_GET_DICTIONARY.

%   Copyright 1993-2010 The MathWorks, Inc.
%   

attr = dicom_dict_lookup(groupStr, elementStr, dictionary);

if (isempty(attr))
    name = '';
else
    name = attr.Name;
end

function attr = dicom_dict_lookup(group, element, dictionary)
%DICOM_DICT_LOOKUP  Lookup an attribute in the data dictionary.
%   ATTRIBUTE = DICOM_DICT_LOOKUP(GROUP, ELEMENT, DICTIONARY) searches for
%   the attribute (GROUP,ELEMENT) in the data dictionary, DICTIONARY.  A
%   structure containing the attribute's properties from the dictionary
%   is returned.  ATTRIBUTE is empty if (GROUP,ELEMENT) is not in
%   DICTIONARY.
%
%   Note: GROUP and ELEMENT can be either decimal values or hexadecimal
%   strings.

%   Copyright 1993-2010 The MathWorks, Inc.


% IMPORTANT NOTE:
%
% This function must be wrapped inside of a try-catch-end block in order
% to prevent the DICOM file from being left open after an error.


MAX_GROUP = 65535;   % 0xFFFF
MAX_ELEMENT = 65535;  % 0xFFFF

%
% Load the data dictionary.
%

persistent tags values prev_dictionary;
mlock;

% Load dictionary for the first time or if dictionary has changed.
if ((isempty(values)) || (~isequal(prev_dictionary, dictionary)))
    
    [tags, values] = images.internal.dicom.loadDictionary(dictionary);
    prev_dictionary = dictionary;
    
end

%
% Convert hex strings to decimals.
%

if (ischar(group))
    group = sscanf(group, '%x');
end

if (ischar(element))
    element = sscanf(element, '%x');
end

if (group > MAX_GROUP)
    error(message('images:dicom_dict_lookup:groupOutOfRange', sprintf( '%x', group ), sprintf( '(%x,%04x)', group, element )))
end


if (element > MAX_ELEMENT)
    error(message('images:dicom_dict_lookup:elementOutOfRange', sprintf( '%x', element ), sprintf( '(%04x,%x)', group, element )))
end

%
% Look up the attribute.
%

% Group and Element values in the published data dictionary are 0-based.
index = tags((group + 1), (element + 1));

if (index == 0)
    attr = struct([]);
else
    attr = values(index);
end