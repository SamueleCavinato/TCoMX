function patient = TCoMX_EPSTV(tomoplan, METRICS_LIST, patient)
% TCoMX_EPSTV Calculates PSTV, EPSTV_{Deltap, Deltal}
%
%   All the details concerning the definition and meaning of each metric 
%   can be found in the "TomoTherapy® Complexity Metrics Reference Guide". 
%
%   INPUT ARGUMENTS:
%      tomoplan: structure array containing information about a
%                TomoTherapy® plan as returned by the function TCoMX_read_plan
%                of TCoMX.
%       METRICS_LIST: structure array containing all the metrics to be
%                     computed according to the METRICS.in file.
%       patient: structure containing the results of the computation
%
%   OUTPUT ARGUMENTS:
%       patient: structure array containing the metrics computed according
%                to the METRICS.in file. The sub-fields are organized in
%                categories and sub-categories accordingly to the "TomoTherapy® 
%                Complexity Metrics Reference Guide"
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%        Author: Samuele Cavinato, MSc, Ph.D. Student
%   Affiliation: Department of Medical Physics, Veneto Institute of 
%                Oncology IOV-IRCCS /
%                Department of Physics and Astronomy 'G.Galilei',
%                University of Padova
%        e-mail: samuele.cavinato@iov.veneto.it
%                samuele.cavinato@phd.unipd.it
%       Created: November, 2020
%       Updated: September, 2021
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% DO NOT HESITATE CONTACTING ME FOR ANY QUESTION/DOUBT/SUGGESTION. I'LL BE
% VERY GLAD TO DISCUSS WITH YOU.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%% Preliminary operations

% Import the sinogram from tomoplan
sinogram = tomoplan.sinogram;

%% Computation of PSTV

output  = TCoMX_FIND_METRIC(METRICS_LIST, 'PSTV');

if ~isempty(output)
    
    if isempty(output.parameters)
        
        % Compute the PSTV metric at each projection (NProjections = NCP - 1)
        PSTV.PSTVcp = sum(abs(sinogram(1:end-2,1:end-1) - sinogram(1:end-2,2:end)),2) ...
            + sum(abs(sinogram(1:end-2, 1:end-1) - sinogram(2:end-1, 1:end-1)),2);
        
        % Compute the average over all CPs
        metricname = ['PSTV'];
        
        patient.(output.category).(output.subcategory).(metricname) = mean(PSTV.PSTVcp);
        
        % Compute the std over all CPs
        PSTV.PSTVstd  = std(PSTV.PSTVcp); % TO DECIDE WHAT TO DO WITH THE STD
        
    end
    
end

output  = TCoMX_FIND_METRIC(METRICS_LIST, 'EPSTV');

if ~isempty(output)
    
    if ~isempty(output.parameters)

        for pp = 1:numel(output.parameters)
            
            output_vector = TCoMX_READ_VECTOR_PARAMETER(output.parameters{pp});
           
            PSTV.PSTVcp = sum(abs(sinogram(1:end-output_vector(2)-1,1:end-output_vector(1)) - sinogram(1:end-output_vector(2)-1,1+output_vector(1):end)),2) ...
            + sum(abs(sinogram(1:end-output_vector(2)-1, 1:end-output_vector(1)) - sinogram(1+output_vector(2):end-1, 1:end-output_vector(1))),2);
            
            metricname = ['EPSTV' num2str(output_vector(1)) '_' num2str(output_vector(2))];
            patient.(output.category).(output.subcategory).(metricname) = mean(PSTV.PSTVcp, 'omitnan');
            
        end
        
    end
    
end

clear sinogram ProjectionTime

end
