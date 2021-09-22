function patient = TCoMX_TTDF(tomoplan, METRICS_LIST, patient)
% TTDFcalc computes the TreatmentTime/FractionDose metric.
%   The metric is computed in the version presented in Santos et al., JACMP
%   2020, "On the complexity of helical tomotherapy treatment plans". 
%  
%   INPUT ARGUMENTS:
%      tomoplan: structure array containing information about a
%                TomoTherapy plan as returned by tomo_read_plan(filename) 
%                of TCoMX.
%      FractionDose: value of the dose per fraction
%
%   OUTPUT ARGUMENTS:
%      TTDF: Treatment time over fraction dose in s/cGy
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
%% Compute the TreatmentTime/FractionDose metric

output  = TCoMX_FIND_METRIC(METRICS_LIST, 'TTDF');

if ~isempty(output)
    
    if isempty(output.parameters)

        metricname = 'TTDF';
        
        patient.(output.category).(output.subcategory).(metricname) = tomoplan.TreatmentTime / FractionDose; % [s/cGy]

    end
    
end
clear patients FractionDose
end

