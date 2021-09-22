function patient = TCoMX_PSTV(tomoplan, METRICS_LIST, patient)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PSTVcalc Computes the PSTV for a Helical Tomotherapy plan.
%   PSTVcalc(tomoplan) computes the Projection Sinogram Time Variability
%   starting from the sinogram contained in tomoplan.sinogram. tomoplan is
%   the structure returned by tomo_read_plan(filename) function of TCoMX.
%   The PSTV metric is computed at each CP in [1:end-1]. The plan
%   PSTV is computed as the arithmetic average over all the projections.
%   The metric is computed in the version presented in Santos et al., JACMP
%   2020, "On the complexity of helical tomotherapy treatment plans". 
%
%   INPUT ARGUMENTS:
%      tomoplan: structure array containing information about a
%                TomoTherapy plan as returned by tomo_read_plan(filename) 
%                of TCoMX.
%
%   OUTPUT ARGUMENTS:
%      PSTV : struct containing the following fields:
%       PSTVcp  : Projection Sinogram Time Variability metric for al the
%                 projection in the interval [1:end-1].
%       PSTVplan: Arithmetic average of PSTVcp over all the [1:end-1]
%                 projections.
%       PSTVstd : Standard deviation of PSTVcp over all the [1:end-1]
%                 projections.
%                          
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%        Author: Samuele Cavinato, Research Fellow @IOV-IRCCS /
%                                  Ph.D. Student @unipd
%   Affiliation: Veneto Institute of Oncology, IOV-IRCCS /
%                University of Padova, Department of Physics and Astronomy
%        e-mail: samuele.cavinato@iov.veneto.it
%                samuele.cavinato@phd.unipd.it
%       Created: November, 2020
%       Updated: April, 2021
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