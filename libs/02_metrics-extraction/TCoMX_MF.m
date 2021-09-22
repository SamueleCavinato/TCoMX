function patient = TCoMX_MF(tomoplan, METRICS_LIST, patient)
% TCoMX_MF Calculates MF
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
%%

output  = TCoMX_FIND_METRIC(METRICS_LIST, 'MF');

if ~isempty(output)

    % Import the sinogram contained in tomoplan
    sinogram = tomoplan.sinogram;

    %Computation of MF 
    
    if isempty(output.parameters)
    
        patient.(output.category).(output.subcategory).(output.metric) = max(sinogram(:))/mean(nonzeros(sinogram(:)));
        
    end
    
end

end
