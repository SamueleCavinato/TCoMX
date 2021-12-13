function tomoplan = TCoMX_read_RTplan(filename, varargin)

try
    % Read DICOM RT
    info = dicominfo(filename);
    if strcmpi(info.Modality, 'RTPLAN')
        
        % Define the plan name
        if contains(upper(info.ManufacturerModelName), 'RAYSTATION')
            % Add RS prefix for RayStation plans
            tomoplan.TPS = 'RAYSTATION';
            tomoplan.name = ['RS_' info.RTPlanName];
            % Substitute _ with - (useful for plots)
            %     tomoplan.name(regexp(tomoplan.name, '_')) = '-';
        elseif contains(upper(info.ManufacturerModelName), 'HI-ART')
            % Add HA prefix for Hi-Art plans
            tomoplan.TPS = 'PRECISION';
            tomoplan.name = ['HA_' info.RTPlanName];
            % Substitute _ with - (useful for plots)
            %     tomoplan.name(regexp(tomoplan.name, '_')) = '-';
        end
        
        
        %% GENERAL INFORMATION
        
        tomoplan.OriginalPlanName = info.RTPlanName;
        tomoplan.PatientID = info.PatientID;
        tomoplan.PatientName = info.PatientName;
        tomoplan.PatientBirthDate = info.PatientBirthDate;
        tomoplan.PatientSex = info.PatientSex;
        tomoplan.RTPlanDate = info.RTPlanDate;
        
        %% IMPORT ATTRIBUTES THAT ARE EQUAL IN RATSTATION AND HI-ART
        
        for vi = 1:numel(varargin)
            if strcmpi(varargin{vi}, 'DoseFraction')
                tomoplan.DoseFraction = varargin{vi+1};
            end
        end
        
        % Import plan manufacturer name
        tomoplan.ManufacturerModelName = info.ManufacturerModelName;
        
        % Read the number of CP
        tomoplan.NCP =info.BeamSequence.Item_1.NumberOfControlPoints;
        
        % Define the rotating direction
        tomoplan.RotationDirection = info.BeamSequence.Item_1.ControlPointSequence.Item_1.GantryRotationDirection;
        
        % Allocate the vector with the gantry angles
        tomoplan.GantryAngle = zeros(tomoplan.NCP,1);
        
        % Import number of leaves
        tomoplan.Nleaves = 64;
        
        % Import information at each CP
        tomoplan.sinogram = zeros(tomoplan.NCP, tomoplan.Nleaves);
        
        % Number of Projections per rotation
        tomoplan.NProjectionsPeriod = 51;
        
        % Number of Rotations
        tomoplan.NRotations = (tomoplan.NCP-1)/tomoplan.NProjectionsPeriod;
        
        % Import the dose rate
        % tomoplan.DoseRate = 850; %MU/min % To convert it in Gy/s, how? At the ISO?
        
        %% IMPORT ATTRIBUTES THAT ARE DIFFERENT IN RAYSTATION AND HI-ART
        
        % RAYSTATION TPS
        if contains(upper(info.ManufacturerModelName), 'RAYSTATION')
            
            % Allocate memory for the CouchPositions at each CP
            tomoplan.CouchPosition = zeros(tomoplan.NCP,1);
            
            %     % THIS IS A TEMPORARY PART AND IT WILL PROBABLY REMOVED AFTER SOME CHECK
            %     if strcmpi(info.BeamSequence.Item_1.BeamType, 'DYNAMIC')
            %
            %         % Allocate memory for the instantaneous FW
            %         tomoplan.inFieldWidth = zeros(tomoplan.NCP,1);
            %
            %         % Allocate memory for the instantaneous pitch
            %         tomoplan.inPitch      = zeros(tomoplan.NCP,1);
            %
            %     end
            %
            % Import the nominal FieldWidth from the variables:
            % Private_4001_1027(IntentedBackJawPosition)
            % Private_4001_1028(IntentedFrontJawPosition)
            tomoplan.NominalFieldWidth = abs(str2double(strsplit(char(info.BeamSequence.Item_1.Private_4001_1027'),'\'))) ...
                + abs(str2double(strsplit(char(info.BeamSequence.Item_1.Private_4001_1028'),'\')));
            
            if tomoplan.NominalFieldWidth == 7
                tomoplan.NominalFieldWidth = 10.48;
            elseif tomoplan.NominalFieldWidth == 20
                tomoplan.NominalFieldWidth = 25.12;
            elseif tomoplan.NominalFieldWidth == 42
                tomoplan.NominalFieldWidth = 50.48;
            else
                disp('Unknown NominalFieldWidth value');
                keyboard
            end
            
        end
        
        for cp=1:tomoplan.NCP
            
            % Import the GantryAngle at the current CP
            tomoplan.GantryAngle(cp,1) =  info.BeamSequence.Item_1.ControlPointSequence.(['Item_' num2str(cp)]).GantryAngle;
            
            if contains(upper(info.ManufacturerModelName), 'RAYSTATION')
                
                % Import the CouchPosition at the current CP
                tomoplan.CouchPosition(cp,1) = info.BeamSequence.Item_1.ControlPointSequence.(['Item_', num2str(cp)]).TableTopLateralPosition;
                %
                %         % THIS PART WILL BE PROBABLY REMOVED AFTER SOME CHECK
                %         if strcmpi(info.BeamSequence.Item_1.BeamType, 'DYNAMIC')
                %             % Import the instantaneouse Field Width at the current CP
                %             tomoplan.inFieldWidth(cp,1) = abs(info.BeamSequence.Item_1.ControlPointSequence.(['Item_', num2str(cp)]).BeamLimitingDevicePositionSequence.Item_2.LeafJawPositions(1)) ...
                %                                         + abs(info.BeamSequence.Item_1.ControlPointSequence.(['Item_', num2str(cp)]).BeamLimitingDevicePositionSequence.Item_2.LeafJawPositions(2));
                %
                %         end
                %
            end
            
            try
                
                % Import the plan sinogram at the current CP (for all leaves)
                tmp = char(info.BeamSequence.Item_1.ControlPointSequence.(['Item_' num2str(cp)]).Private_300d_10a7');
                tmp = strsplit(tmp,'\');
                tomoplan.sinogram(cp,:) = str2double(tmp);
                
            catch
                
                continue;
                
            end
            
        end
        
        % RAYSTATION TPS
        if contains(upper(info.ManufacturerModelName), 'RAYSTATION')
            
            try
                % Import the ProjectionTime [s]
                tomoplan.ProjectionTime = str2double(strsplit(char(info.BeamSequence.Item_1.Private_4001_1053'),'\'));
                
                % Compute the GantryPeriod from the ProjectionTime [s]
                tomoplan.GantryPeriod   = tomoplan.ProjectionTime * tomoplan.NProjectionsPeriod;
                
            catch
                
                % Import the Gantry Period [s]
                tomoplan.GantryPeriod    = str2double(strsplit(char(info.BeamSequence.Item_1.Private_300d_1040'),'\'));
                
                % Compute the ProjectionTime from the Gantry Period [s]
                tomoplan.ProjectionTime  = tomoplan.GantryPeriod/tomoplan.NProjectionsPeriod;
                
            end
            
            
            % Compute the TreatmentTime [s]
            tomoplan.TreatmentTime = tomoplan.NRotations * tomoplan.GantryPeriod;
            
            % Compute the CouchTranslation [mm]
            tomoplan.CouchTranslation = tomoplan.CouchPosition(end) - tomoplan.CouchPosition(1);
            
            % Compute the average (it should be constant!) translational step
            tomoplan.CouchStep = mean(diff(tomoplan.CouchPosition));
            
            %     % THIS PART WILL BE PROBABLY REMOVED AFTER SOME CHECK
            %     if strcmpi(info.BeamSequence.Item_1.BeamType, 'DYNAMIC')
            %         % Compute the instantaneous Pitch
            %         tomoplan.inPitch = tomoplan.CouchTranslation / tomoplan.NRotations ./ tomoplan.inFieldWidth;
            %
            %         % Compute the NominalPitch as:
            %         % 1) Average of inPitch
            %         tomoplan.av_inPitch = mean(tomoplan.inPitch);
            %     end
            % 2) Using the NominalField Width
            tomoplan.NominalPitch = tomoplan.CouchTranslation / tomoplan.NRotations / tomoplan.NominalFieldWidth;
            
            % Compute the TargetLength from the NominalFieldWidth [mm]
            tomoplan.TargetLength = tomoplan.CouchTranslation - tomoplan.NominalFieldWidth;
            
            % Compute the CouchSpeed [mm/s]
            tomoplan.CouchSpeed = mean(tomoplan.CouchStep / tomoplan.ProjectionTime);
            
            % Import the BeamMeterset (from Conformance Statement it is: Total
            % MU of the Beam
            tomoplan.BeamMeterset = info.FractionGroupSequence.Item_1.ReferencedBeamSequence.Item_1.BeamMeterset;
            
            % Compute the MF using the approximated formula provided by ACCURAY
            %tomoplan.MF = tomoplan.GantryPeriod / (tomoplan.BeamMeterset / tomoplan.DoseRate * 60) / tomoplan.NominalPitch;
            
            
            % HI-ART TPS
        elseif contains(upper(info.ManufacturerModelName), 'HI-ART')
            
            % Import the Gantry Period [s]
            tomoplan.GantryPeriod    = str2double(strsplit(char(info.BeamSequence.Item_1.Private_300d_1040'),'\'));
            
            % Compute the ProjectionTime from the Gantry Period [s]
            tomoplan.ProjectionTime  = tomoplan.GantryPeriod/tomoplan.NProjectionsPeriod;
            
            % Compute the TreatmentTime [s]
            tomoplan.TreatmentTime   = tomoplan.NRotations * tomoplan.GantryPeriod;
            
            % Import the CouchSpeed [mm/s]
            tomoplan.CouchSpeed      = str2double(strsplit(char(info.BeamSequence.Item_1.Private_300d_1080'),'\'));
            
            % Compute the CouchTranslation [mm]
            tomoplan.CouchTranslation = tomoplan.CouchSpeed * tomoplan.TreatmentTime;
            
            % Import the Pitch
            tomoplan.NominalPitch = str2double(strsplit(char(info.BeamSequence.Item_1.Private_300d_1060'), '\'));
            
            % Compute the Field Width [mm]
            tomoplan.NominalFieldWidth = tomoplan.CouchTranslation / tomoplan.NRotations / tomoplan.NominalPitch;
            
            % Compute the TargetLength [mm]
            tomoplan.TargetLength = tomoplan.CouchTranslation - tomoplan.NominalFieldWidth;
            
            % Import BeamMeterset (predicted duration of the treatment)
            tomoplan.BeamMeterset = info.FractionGroupSequence.Item_1.ReferencedBeamSequence.Item_1.BeamMeterset;
            
            % Compute the MF using the approximated formula provided by ACCURAY
            %tomoplan.MF = tomoplan.GantryPeriod / (tomoplan.BeamMeterset * 60) / tomoplan.NominalPitch;
            
        end
        
        
        try
            % Import the fraction dose (works for RayStation)
            tomoplan.DoseFraction = info.FractionGroupSequence.Item_1.ReferencedBeamSequence.Item_1.BeamDose*100;
            tomoplan.TTDF = tomoplan.TreatmentTime/tomoplan.DoseFraction;
        catch
            try
                tomoplan.TTDF = tomoplan.TreatmentTime/tomoplan.DoseFraction;
            catch
            end
            
        end
    else
        tomoplan = [];
    end
    
catch
    
    tomoplan = [];
end

end
