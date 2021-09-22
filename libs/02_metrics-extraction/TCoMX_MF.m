function patient = TCoMX_MF(tomoplan, METRICS_LIST, patient)
%function [MFleaf, MFplan, MFstd] = MFcalc(tomoplan)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MFcalc Computes the MF metric for a Helical Tomotherapy plan.
%   MFcalc(tomoplan) computes the Modulation Factor starting from the
%   sinogram contained in tomoplan.sinogra. tomplan si tge structure
%   returned by tomo_read_plan(filename) function of TCoMX. 
%
%   MF is computed by taking the maximum LOT value in the sinogram and
%   dividing it by the arithmetic average of non-zero LOT in the sinogram.
% 
%   INPUT ARGUMENTS:
%      tomoplan: structure array containing information about a
%                TomoTherapy plan as returned by tomo_read_plan(filename) 
%                of TCoMX.
%--------------------------------------------------------------------------
%   OUTPUT ARGUMENTS: OLD VERSION
%      MFleaf: Modulation Factor for each leaf
%      MFplan: Arithmetic average of MFleaf computed over all the leaves 
%              which open at least once during the treatment
%      MFstd:  Standard deviation of MFleaf computed over all the leaves 
%              which open at least once during the treatment
%-------------------------------------------------------------------------- 
%   OUTPUT ARGUMENTS: NEW VERSION
%      MF : stuct containing the following fields:
%       MFplan: Modulation Factor computed over the whole sinogram.
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
